--- ADSR Envelope Generator
--[[
ADSR Concept:
Implements a linear Attack–Decay–Sustain–Release (ADSR) amplitude envelope.

Mathematical model:
    Attack:  E(t) = t / attackTime                  (0 ≤ t ≤ attackTime)
    Decay:   E(t) = 1 − (1 − sustainLevel) × ((t − attackTime) / decayTime)
    Sustain: E(t) = sustainLevel
    Release: E(t) = sustainLevel × (1 − (t − releaseStart) / releaseTime)

States:
    • ATTACK  – envelope rising from 0 → 1
    • DECAY   – envelope falling from 1 → sustainLevel
    • SUSTAIN – steady amplitude at sustainLevel
    • RELEASE – envelope returning to 0
    • IDLE    – inactive / silent

Characteristics:
    • Linear transitions (can be swapped for exponential later)
    • Per-voice instance (each note has its own envelope)
    • Level returned from `process(dt)` multiplies oscillator amplitude
]]
local EnvelopeState = require("utils.adsr.envelopestate")
local ADSR = {}
ADSR.__index = ADSR

--- Create a new ADSR envelope
-- @param a number Attack time in seconds
-- @param d number Decay time in seconds
-- @param s number Sustain level (0–1)
-- @param r number Release time in seconds
-- @return ADSR Envelope instance
function ADSR:new(a, d, s, r)
	return setmetatable({
		attack = a or 0.7,
		decay = d or 0.5,
		sustain = s or 0.7,
		release = r or 1.0,
		level = 0.0,
		state = EnvelopeState.IDLE,
	}, ADSR)
end

--- Trigger the envelope (note-on)
function ADSR:noteOn()
	self.state = EnvelopeState.ATTACK
	self.level = 0.0 -- reset envelope to 0 to avoid skipped attack
end

--- Begin release phase (note-off)
function ADSR:noteOff()
	self.state = EnvelopeState.RELEASE
end

--- Check if envelope is idle
-- @return boolean True if envelope has finished release
function ADSR:isIdle()
	return self.state == EnvelopeState.IDLE
end

--- Process envelope for one sample/frame
-- @param dt number Time step in seconds (1 / sampleRate)
-- @return number Current envelope level (0–1)
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
		lvl = lvl - dt / r
		if lvl <= 0.0001 then -- epsilon ensures envelope reaches idle
			lvl = 0
			self.state = EnvelopeState.IDLE
		end
	end

	self.level = lvl
	return lvl
end

return ADSR
