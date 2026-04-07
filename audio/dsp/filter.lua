--- One-pole Low-pass Filter
--[[
Filter Concept:
Implements a simple one-pole low-pass filter with the formula:
  y[n] = y[n−1] + a × (x[n] − y[n−1])
where:
  x[n] = current input sample
  y[n] = current output sample
  a    = smoothing coefficient between 0 and 1

alpha coefficient:
  a    = 1 − e^(−2π * fc / fs)
Parameters:
  fc   = cutoff frequency (Hz)
  fs   = sample rate (Hz)

Characteristics:
  - Gentle 6 dB/oct slope
  - No resonance (Q = 0)
]]
local config = require("config")
local Filter = {}
Filter.__index = Filter
local twoPi = 2 * math.pi
local exp = math.exp

function Filter.new(cutoff)
	local self = setmetatable({}, Filter)
	self.sr = config.sampleRate or 44100
	self:setCutoff(cutoff)
	self._y = 0
	return self
end

--- Set the cutoff frequency
-- @param freq number Cutoff frequency in Hz
function Filter:setCutoff(freq)
	self.cutoff = freq
	self._a = 1 - exp(-twoPi * freq / self.sr)
end

--- Process one input sample
-- @param x number Input sample
-- @return number Filtered output sample
function Filter:process(x)
	self._y = self._y + self._a * (x - self._y)
	return self._y
end

function Filter:reset()
	self._y = 0
end

return Filter
