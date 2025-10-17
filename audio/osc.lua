local osc = {}

function osc.sine(phase)
	return math.sin(phase)
end

function osc.square(phase)
	return (math.sin(phase) >= 0) and 1 or -1
end

function osc.saw(phase)
	-- map any phase to [0,1) fraction of cycle
	local frac = (phase / (2 * math.pi)) % 1
	return 2 * frac - 1 -- -1..1
end

function osc.triangle(phase)
	-- map any phase to [0,1) fraction of cycle
	local frac = (phase / (2 * math.pi)) % 1
	if frac < 0.25 then
		return 4 * frac
	elseif frac < 0.75 then
		return 2 - 4 * frac
	else
		return -4 + 4 * frac
	end
end

return osc
