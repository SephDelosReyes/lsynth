local waveforms = require("utils.waveforms")
local controls = {}

-- mapping keys to waveforms
function controls.keypressed(key)
	if key == "1" then
		print("Switched to sine")
		_G.engine.setWaveform(waveforms.SINE)
	elseif key == "2" then
		print("Switched to square")
		_G.engine.setWaveform(waveforms.SQUARE)
	elseif key == "3" then
		print("Switched to saw")
		_G.engine.setWaveform(waveforms.SAW)
	elseif key == "4" then
		print("Switched to triangle")
		_G.engine.setWaveform(waveforms.TRIANGLE)
	end
end

return controls
