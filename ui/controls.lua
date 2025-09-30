local controls = {}

local waveforms = require("utils.waveforms")
local engine = nil
local octave = 4 -- starting octave (C4)
local baseFrequency = 440 -- A=440Hz

local midiKeymap = {
	-- White keys (ASDF row)
	a = 60, -- C
	s = 62, -- D
	d = 64, -- E
	f = 65, -- F
	g = 67, -- G
	h = 69, -- A
	j = 71, -- B
	k = 72, -- C (next octave)
	l = 74, -- D
	[";"] = 76, -- E

	-- Black keys (WERT row, above)
	w = 61, -- C#
	e = 63, -- D#
	t = 66, -- F#
	y = 68, -- G#
	u = 70, -- A#
	o = 73, -- C#
	p = 75, -- D#
}

function controls.init(e)
	engine = e
end

local function midiToFreq(n)
	return 440 * 2 ^ ((n - 69) / 12)
end

local function keyToFrequency(key)
	local midi = midiKeymap[key]
	if midi then
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

local function note(key)
	-- TODO: figure out the octave math relative to frequency
	if key == "z" then
		octave = octave - 1
		print("Octave down: " .. octave)
	elseif key == "x" then
		octave = octave + 1
		print("Octave up: " .. octave)
	end
	local freq = keyToFrequency(key)
	if freq then
		print("Note pressed: " .. key .. " (" .. string.format("%.2f Hz", freq) .. ")")
		engine.setFrequency(freq)
	end
end

function controls.keypressed(key)
	waveform(key)
	note(key)
	engine.noteOn()
end

function controls.keyreleased(key)
	engine.noteOff()
end
return controls
