-- ADSR - Attack, Decay, Sustain, Release
local adsr = {}

function adsr.init() end

-- Attack: E(t) = t / attackTime     (0 <= t <= attackTime)
-- Decay: E(t) = 1 - (1 - sustainLevel) * ((t - attackTime) / decayTime)
-- Sustain: E(t) = sustainLevel
-- Release: E(t) = sustainLevel * (1 - (t - releaseStart) / releaseTime)

return adsr
