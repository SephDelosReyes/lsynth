local Waveforms = require("utils.waveforms")
local Voice = require("audio.voice")
local osc = require("audio.osc")
local config = require("config")
-- local adsr = require("audio.adsr")
-- local filter = require("audio.filter")
-- local fft = require("audio.fft")

local engine = {}
local lastBuffer = {}
local underruns = 0
-- local spectrum = {}

local MAX_VOICES = 5
local voices = {} -- manage voice pool in engine
local waveform = Waveforms.SINE

-- Initialize love2d queueable source and voice pool
function engine.init()
	engine.source = love.audio.newQueueableSource(config.sampleRate, 16, 1)
	for i = 1, MAX_VOICES do
		voices[i] = Voice.new(waveform)
	end
end

-- Required by waveform switcher in controls.lua
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

function engine.noteOff(freq)
	for _, v in ipairs(voices) do
		-- find and switch off the voice with exact frequency
		if v.active and v.freq == freq then
			v:off()
		end
	end
end

function engine.noteOn(freq)
	local v = getVoice(freq)
	v:on(freq, waveform)
end

-- Required by oscilloscope.lua
function engine.getBuffer()
	return lastBuffer
end

local function normalize(s, activeCount)
	if activeCount == 0 then
		return 0
	end
	local gain = 1 / math.sqrt(activeCount)
	return s * gain * 0.2
end

local function createSample(activeCount)
	local s = 0
	for _, v in ipairs(voices) do
		if v.active then
			s = s + v:sample(config.sampleRate, osc)
		end
	end
	if activeCount > 0 then
		s = normalize(s, activeCount)
	end
	return s
end

local function handlePlaybackState(src, active)
	if active and not src:isPlaying() then
		src:play()
	elseif not active and src:isPlaying() then
		src:stop()
	end
end

local function fillBuffer(soundData, bufferSize, activeCount)
	for i = 0, bufferSize - 1 do
		local sample = createSample(activeCount)
		soundData:setSample(i, sample)
		lastBuffer[i + 1] = sample
	end
end

local function queueSoundData(sd)
	engine.source:queue(sd)
end

local function processFreeBuffers(freeBuffers, activeCount)
	if freeBuffers == 0 then
		underruns = underruns + 1
		return
	end
	if freeBuffers > 0 then
		local soundData = love.sound.newSoundData(config.bufferSize, config.sampleRate, 16, 1)
		fillBuffer(soundData, config.bufferSize, activeCount)
		queueSoundData(soundData)
	end
end

function engine.update(dt)
	local src = engine.source
	local freeBuffers = src:getFreeBufferCount()
	local activeCount = activeVoiceCount()
	local active = activeCount > 0
	handlePlaybackState(src, active)
	-- stop early if inactive (save CPU)
	if not active then
		return
	end
	processFreeBuffers(freeBuffers, activeCount)
end

function engine.getUnderruns()
	return underruns
end

-- function engine.getSpectrum()
-- 	return spectrum
-- end

return engine
