-- ADSR Concept:
-- Attack: E(t) = t / attackTime     (0 <= t <= attackTime)
-- Decay: E(t) = 1 - (1 - sustainLevel) * ((t - attackTime) / decayTime)
-- Sustain: E(t) = sustainLevel
-- Release: E(t) = sustainLevel * (1 - (t - releaseStart) / releaseTime)

local EnvelopeState = require("utils.adsr.envelopestate")
local ADSR = {}
ADSR.__index = ADSR

function ADSR:new(a, d, s, r)
	-- TODO: sensible defaults - store in a config file somewhere
	return setmetatable({
		attack = a or 0.7,
		decay = d or 0.5,
		sustain = s or 0.7,
		release = r or 1,
		level = 0,
		state = EnvelopeState.IDLE,
	}, ADSR)
end

function ADSR:noteOn()
	self.state = EnvelopeState.ATTACK
	self.level = 0 -- reset env back to 0, avoids "ignored" attack
end

function ADSR:noteOff()
	self.state = EnvelopeState.RELEASE
end

function ADSR:isIdle()
	return self.state == EnvelopeState.IDLE
end

function ADSR:process(dt)
	local lvl = self.level
	local a, d, s, r = self.attack, self.decay, self.sustain, self.release

	if self.state == EnvelopeState.ATTACK then
		lvl = lvl + dt / a
		if lvl >= 1 then
			lvl = 1
			self.state = EnvelopeState.DECAY
		end
	elseif self.state == EnvelopeState.DECAY then
		lvl = lvl - dt / d * (1 - s)
		if lvl <= s then
			lvl = s
			self.state = EnvelopeState.SUSTAIN
		end
	elseif self.state == EnvelopeState.SUSTAIN then
		lvl = s
	elseif self.state == EnvelopeState.RELEASE then
		lvl = lvl - dt / r --linear
		if lvl <= 0.0001 then -- small epsilon to ensure a reachable idle state
			lvl = 0
			self.state = EnvelopeState.IDLE
		end
	end

	self.level = lvl
	return lvl
end

return ADSR
