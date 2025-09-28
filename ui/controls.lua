local waveforms = require("utils.waveforms")
local controls = {}
local engine

function controls.init(e)
	engine = e
end

-- mapping keys to waveforms
function controls.keypressed(key)
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

return controls
