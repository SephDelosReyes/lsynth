local Waveforms = require("utils.waveforms")
local osc = require("audio.osc")
-- local fft = require("audio.fft")
local config = require("config")

local engine = {}
local t = 0
local lastBuffer = {}
local waveform = Waveforms.SINE
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

function engine.update(dt)
	if engine.source:getFreeBufferCount() > 0 then
		local soundData = love.sound.newSoundData(config.bufferSize, config.sampleRate, 16, 1)
		for i = 0, config.bufferSize - 1 do
			local sample = osc[waveform](config.frequency, t, config.sampleRate)
			soundData:setSample(i, sample)
			lastBuffer[i + 1] = sample
			t = t + 1 / config.sampleRate
		end
		engine.source:queue(soundData)
		if not engine.source:isPlaying() then
			engine.source:play()
		end
		-- spectrum = fft.analyze(lastBuffer)
	end
end

function engine.getBuffer()
	return lastBuffer
end

-- function engine.getSpectrum()
-- 	return spectrum
-- end

return engine
