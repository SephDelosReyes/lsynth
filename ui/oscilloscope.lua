local config = require("config")

local scope = {}

function scope.draw(buffer)
	local w, h = love.graphics.getDimensions()
	love.graphics.setColor(0, 1, 0)
	for i = 1, #buffer - 1 do
		local x1 = (i / #buffer) * (w / 2)
		local y1 = h / 2 + buffer[i] * (h / 3)
		local x2 = ((i + 1) / #buffer) * (w / 2)
		local y2 = h / 2 + buffer[i + 1] * (h / 3)
		love.graphics.line(x1, y1, x2, y2)
	end
	love.graphics.print("Waveform", 10, 10)
end

return scope
