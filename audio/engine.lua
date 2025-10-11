local Waveforms = require("utils.waveforms")
local osc = require("audio.osc")
local config = require("config")
-- local adsr = require("audio.adsr")
-- local filter = require("audio.filter")
-- local fft = require("audio.fft")

local engine = {}
local lastBuffer = {}
local underruns = 0
-- local spectrum = {}

-- NOTE: previous `t = 0` which basically phase, is now in a `voices` table
local MAX_VOICES = 16
local voices = {} --TODO: refactor to a separate module later in ADSR implementation
local waveform = Waveforms.SINE

function engine.init()
	engine.source = love.audio.newQueueableSource(config.sampleRate, 16, 1)
	for i = 1, MAX_VOICES do
		voices[i] = { active = false, freq = 0, phase = 0, wf = waveform }
	end
end

function engine.setWaveform(w)
	if osc[w] == nil then
		error("Unsupported waveform: " .. tostring(w))
	end
	waveform = w
end

local function activeVoiceCount()
	local n = 0
	for _, v in ipairs(voices) do
		if v.active then
			n = n + 1
		end
	end
	return n
end

-- @param freq TODO: maybe some other smart algo to switch which voice.
local function getVoice(freq)
	for _, v in ipairs(voices) do
		-- take a free voice
		if not v.active then
			return v
		end
	end
	-- or steal the first instance
	return voices[1]
end

local function normalize(s)
	local gain = 1 / math.sqrt(activeVoiceCount())
	return s * gain * 0.3
end

function engine.createSample()
	-- local oscRaw = osc[waveform](config.frequency, t, config.sampleRate)
	-- local adsrShaped = adsr.apply(oscRaw, t, noteState)
	-- local filtered = filter.apply(adsrShaped)
	-- voices is currently global - so utilize this fact for now
	local s = 0
	for _, v in ipairs(voices) do
		if v.active then
			s = s + osc[waveform](v.freq, v.phase, config.sampleRate)
			v.phase = v.phase + 1 / config.sampleRate
		end
	end
	if activeVoiceCount() > 0 then
		s = normalize(s)
	end
	return s
end

function engine.noteOff(freq)
	for _, v in ipairs(voices) do
		-- find and switch off the voice with exact frequency
		if v.active and v.freq == freq then
			v.active = false
		end
	end
end

function engine.noteOn(freq)
	local v = getVoice(freq)
	-- set voice parameters
	v.active = true
	v.freq = freq
	--v.phase = 0 -- TODO: open later for detuning possibilities
	v.phase = math.random() * 2 * math.pi -- try out randomized phase
	v.wf = waveform
end

function engine.queueSoundData(sd)
	engine.source:queue(sd)
end

function engine.getBuffer()
	return lastBuffer
end

function engine.update(dt)
	local src = engine.source
	local freeBuffers = src:getFreeBufferCount()

	local active = activeVoiceCount() > 0

	-- handle play/stop logic
	if active and not src:isPlaying() then
		src:play()
	elseif not active and src:isPlaying() then
		src:stop()
		return
	end

	if not active then
		return
	end

	if freeBuffers == 0 then
		underruns = underruns + 1
	end

	if freeBuffers > 0 then
		local soundData = love.sound.newSoundData(config.bufferSize, config.sampleRate, 16, 1)
		for i = 0, config.bufferSize - 1 do
			local sample = engine.createSample()
			soundData:setSample(i, sample)
			-- for oscilloscope
			lastBuffer[i + 1] = sample
		end
		engine.queueSoundData(soundData)
		-- spectrum = fft.analyze(lastBuffer)
	end
end

function engine.getUnderruns()
	return underruns
end

-- function engine.getSpectrum()
-- 	return spectrum
-- end

return engine
