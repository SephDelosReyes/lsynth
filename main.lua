local engine = require("audio.engine")
local controls = require("ui.controls")
local oscilloscope = require("ui.oscilloscope")
-- local spectrum = require("ui.spectrum")

function love.load()
	engine.init()
	controls.init(engine)
end

function love.update(dt)
	engine.update(dt)
end

function love.keypressed(key)
	controls.keypressed(key)
end

function love.draw()
	oscilloscope.draw(engine.getBuffer())
	-- spectrum.draw(audio.getSpectrum())
end
