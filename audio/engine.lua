local Waveforms = require("utils.waveforms")
local osc = require("audio.osc")
local config = require("config")
-- local adsr = require("audio.adsr")
-- local filter = require("audio.filter")
-- local fft = require("audio.fft")

local engine = {}
local t = 0 -- TODO: phase should be per oscillator, tackle in polyphony
local lastBuffer = {}
local waveform = Waveforms.SINE
local playing = false -- TODO: needs a cleaner state elsewhere maybe
-- local spectrum = {}

function engine.init()
	engine.source = love.audio.newQueueableSource(config.sampleRate, 16, 1)
end

function engine.setWaveform(w)
	if osc[w] == nil then
		error("Unsupported waveform: " .. tostring(w))
	end
	waveform = w
end

function engine.setFrequency(f)
	config.frequency = f
end

function engine.createSample()
	-- local oscRaw = osc[waveform](config.frequency, t, config.sampleRate)
	-- local adsrShaped = adsr.apply(oscRaw, t, noteState)
	-- local filtered = filter.apply(adsrShaped)
	return osc[waveform](config.frequency, t, config.sampleRate)
end

function engine.noteOff()
	playing = false
end

function engine.noteOn()
	playing = true
	if not engine.source:isPlaying() then
		engine.source:play()
	end
end

function engine.queueSoundData(sd)
	engine.source:queue(sd)
end

function engine.getBuffer()
	return lastBuffer
end

function engine.update(dt)
	if engine.source:getFreeBufferCount() > 0 then
		-- TODO: still has a bug with overlapping keypress and release. Fix in Polyphony
		if not playing then
			local silence = love.sound.newSoundData(config.bufferSize, config.sampleRate, 16, 1)
			engine.queueSoundData(silence)
			return
		end
		local soundData = love.sound.newSoundData(config.bufferSize, config.sampleRate, 16, 1)
		for i = 0, config.bufferSize - 1 do
			local sample = engine.createSample()
			soundData:setSample(i, sample)
			lastBuffer[i + 1] = sample
			t = t + 1 / config.sampleRate
		end
		engine.queueSoundData(soundData)
		-- spectrum = fft.analyze(lastBuffer)
	end
end

-- function engine.getSpectrum()
-- 	return spectrum
-- end

return engine
