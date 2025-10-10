local controls = {}

local waveforms = require("utils.waveforms")
local engine = nil
local octave = 4 -- starting octave (C4)
local baseFrequency = 440 -- A=440Hz

local octaveKeys = {
	z = -1,
	x = 1,
}
local midiKeymap = {
	-- White keys (ASDF row)
	a = 0, -- C
	s = 2, -- D
	d = 4, -- E
	f = 5, -- F
	g = 7, -- G
	h = 9, -- A
	j = 11, -- B
	k = 12, -- C (next octave)
	l = 14, -- D
	[";"] = 16, -- E

	-- Black keys (WERT row, above)
	w = 1, -- C#
	e = 3, -- D#
	t = 6, -- F#
	y = 8, -- G#
	u = 10, -- A#
	o = 13, -- C#
	p = 15, -- D#
}

function controls.init(e)
	engine = e
end

local function midiToFreq(n)
	return baseFrequency * 2 ^ ((n - 69) / 12)
end

local function keyToFrequency(key)
	local semitone = midiKeymap[key]
	if semitone then
		local midi = 12 * octave + semitone
		print("midi: " .. midi)
		return midiToFreq(midi)
	end
	return nil
end

local function waveform(key)
	if key == "1" then
		print("Switched to sine")
		engine.setWaveform(waveforms.SINE)
	elseif key == "2" then
		print("Switched to square")
		engine.setWaveform(waveforms.SQUARE)
	elseif key == "3" then
		print("Switched to saw")
		engine.setWaveform(waveforms.SAW)
	elseif key == "4" then
		print("Switched to triangle")
		engine.setWaveform(waveforms.TRIANGLE)
	end
end

local function changeOctave(key)
	local shift = octaveKeys[key]
	if shift then
		octave = octave + shift
		print("Octave " .. (shift > 0 and "up" or "down") .. ": " .. octave)
	end
end

local function notePressed(key)
	if changeOctave(key) then
		return
	end
	local freq = keyToFrequency(key)
	if freq then
		print("Note pressed: " .. key .. " (" .. string.format("%.2f Hz", freq) .. ")")
		engine.noteOn(freq)
	end
end

function controls.keypressed(key)
	waveform(key)
	notePressed(key)
end

function controls.keyreleased(key)
	local freq = keyToFrequency(key)
	if freq then
		engine.noteOff(freq)
	end
end
return controls
