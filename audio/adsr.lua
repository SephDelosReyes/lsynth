-- ADSR - Attack, Decay, Sustain, Release
local adsr = {}

-- Attack: E(t) = t / attackTime     (0 <= t <= attackTime)
-- Decay: E(t) = 1 - (1 - sustainLevel) * ((t - attackTime) / decayTime)
-- Sustain: E(t) = sustainLevel
-- Release: E(t) = sustainLevel * (1 - (t - releaseStart) / releaseTime)

-- Default ADSR settings (seconds and sustain level)
adsr.attack = 0.1 -- 100ms to reach peak
adsr.decay = 0.2 -- 200ms to reach sustain level
adsr.sustain = 0.7 -- sustain level (0.0 to 1.0)
adsr.release = 0.3 -- 300ms to fade out

-- Envelope state
local noteOnTime = nil
local noteOffTime = nil
local isReleased = false

--- Call when a note is pressed
function adsr.noteOn(currentTime)
	noteOnTime = currentTime
	noteOffTime = nil
	isReleased = false
end

--- Call when a note is released
function adsr.noteOff(currentTime)
	noteOffTime = currentTime
	isReleased = true
end

--- Compute envelope value at time `currentTime`
function adsr.getAmplitude(currentTime)
	if not noteOnTime then
		return 0
	end

	local t = currentTime - noteOnTime

	if not isReleased then
		-- Attack
		if t < adsr.attack then
			return t / adsr.attack
		end
		-- Decay
		if t < adsr.attack + adsr.decay then
			local decayT = t - adsr.attack
			local decayProgress = decayT / adsr.decay
			return 1 - (1 - adsr.sustain) * decayProgress
		end
		-- Sustain
		return adsr.sustain
	else
		-- Release
		local releaseT = currentTime - noteOffTime
		if releaseT < adsr.release then
			-- fade from sustain level down to 0
			return adsr.sustain * (1 - releaseT / adsr.release)
		else
			return 0
		end
	end
end

return adsr
