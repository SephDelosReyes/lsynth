local engine = require("audio.engine")
local controls = require("ui.controls")
local oscilloscope = require("ui.oscilloscope")
-- local spectrum = require("ui.spectrum")

function love.load()
	love.window.setTitle("l(ua)synth")
	engine.init()
	controls.init(engine)
end

function love.update(dt)
	engine.update(dt)
end

function love.keypressed(key)
	controls.keypressed(key)
end

function love.keyreleased(key)
	controls.keyreleased(key)
end

function love.draw()
	oscilloscope.draw(engine.getBuffer(), engine.getWaveformName())
	--love.graphics.print("Underruns: " .. engine.getUnderruns(), 10, 30)
	-- spectrum.draw(audio.getSpectrum())
end
