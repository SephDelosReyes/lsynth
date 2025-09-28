local osc = {}

function osc.sine(freq, t, sr)
	return math.sin(2 * math.pi * freq * t)
end

function osc.square(freq, t, sr)
	return (math.sin(2 * math.pi * freq * t) >= 0) and 1 or -1
end

function osc.saw(freq, t, sr)
	return 2 * (t * freq - math.floor(0.5 + t * freq))
end

function osc.triangle(freq, t, sr)
	return math.abs(4 * (t * freq - math.floor(0.5 + t * freq))) * 2 - 1
end

return osc
