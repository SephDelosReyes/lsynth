local Filter = require("audio.dsp.filter")
local Voice = {}
Voice.__index = Voice

function Voice.new(wf, adsr)
	return setmetatable({
		active = false,
		freq = 0,
		phase = 0,
		wf = wf,
		env = adsr and adsr:new() or nil, -- per-voice ADSR envelope
		filter = Filter.new(1000), -- per-voice one-pole low pass filter
	}, Voice)
end

function Voice:on(freq, wf)
	self.active = true
	self.freq = freq
	self.phase = math.random() * 2 * math.pi
	self.wf = wf
	if self.env then
		self.env:noteOn()
	end
	self.filter:reset() --avoid pops
end

function Voice:off()
	if self.env then
		self.env:noteOff()
	end
end

function Voice:sample(sr, osc, dt)
	if not self.active then
		return 0
	end
	local s = osc[self.wf](self.freq, self.phase, sr)
	self.phase = self.phase + 1 / sr --TODO: review math to properly bound phase to 2pi RAD
	--apply adsr envelope
	if self.env then
		s = s * self.env:process(dt)
		if self.env:isIdle() then
			self.active = false
		end
	end
	--apply filter
	s = self.filter:process(s)
	return s
end

return Voice
