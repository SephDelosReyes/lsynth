local Filter = require("audio.dsp.filter")
local Waveforms = require("utils.waveforms")
local Voice = {}
local config = require("config")
Voice.__index = Voice
local twoPi = 2 * math.pi

function Voice.new(wf, adsr)
	return setmetatable({
		active = false,
		freq = 0,
		phase = 0,
		wf = wf,
		env = adsr and adsr:new() or nil, -- per-voice ADSR envelope
		filter = Filter.new(config.FILTER_CUTOFF), -- per-voice one-pole low pass filter
		--filter = Filter.new(2000), -- per-voice one-pole low pass filter
	}, Voice)
end

function Voice:on(freq, wf)
	self.active = true
	self.freq = freq
	self.phase = wf == Waveforms.SINE and 0 or math.random() * twoPi
	self.wf = wf
	self.fadeSamples = 32
	if self.env then
		self.env:noteOn()
	end
	--self.filter:reset() --avoid pops
end

function Voice:off()
	if self.env then
		self.env:noteOff()
	end
end

function Voice:sample(sr, osc, dt)
	if not self.active then --TODO maybe not needed if sample creation is only with active voices
		return 0
	end
	local s = osc[self.wf](self.phase)
	self.phase = self.phase + (twoPi * self.freq / sr)
	-- TODO revisit later
	-- if self.phase > 1e6 then
	-- 	-- occasional wrapping to 2pi
	-- 	self.phase = self.phase % twoPi
	-- end
	-- -- tiny startup fade to remove click
	-- if self.fadeSamples and self.fadeSamples > 0 then
	-- 	local fade = (32 - self.fadeSamples) / 32
	-- 	s = s * fade
	-- 	self.fadeSamples = self.fadeSamples - 1
	-- end
	--apply adsr envelope
	if self.env then
		s = s * self.env:process(dt)
		if self.env:isIdle() and math.abs(self.filter._y) < 0.0001 then
			self.active = false
		end
	end
	--apply filter
	--TODO is it possible to apply filter only when params change?
	s = self.filter:process(s)
	return s
end

return Voice
