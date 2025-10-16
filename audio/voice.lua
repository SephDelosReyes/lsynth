local Voice = {}
Voice.__index = Voice

function Voice.new(wf)
	return setmetatable({
		active = false,
		freq = 0,
		phase = 0,
		wf = wf,
		env = nil, --TODO: fix in ADSR feature
	}, Voice)
end

function Voice:on(freq, wf)
	self.active = true
	self.freq = freq
	self.phase = math.random() * 2 * math.pi -- try out randomized phase
	self.wv = wf
end

function Voice:off()
	self.active = false
end

function Voice:sample(sr, osc)
	if not self.active then
		return 0
	end
	local s = osc[self.wf](self.freq, self.phase, sr)
	self.phase = (self.phase + 1 / sr) % (2 * math.pi)
	return s
end

return Voice
