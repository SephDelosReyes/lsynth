local config = require("config")

local scope = {}

function scope.draw(buffer, wf)
	love.graphics.setBackgroundColor(0.89, 0.86, 0.83, 1)
	local w, h = love.graphics.getDimensions()
	love.graphics.setColor(0.2, 0.2, 0.7, 1)
	for i = 1, #buffer - 1 do
		local x1 = (i / #buffer) * w --(w / 2)
		local y1 = h / 2 + buffer[i] * h -- (h / 3)
		local x2 = ((i + 1) / #buffer) * w -- (w / 2)
		local y2 = h / 2 + buffer[i + 1] * h -- (h / 3)
		love.graphics.line(x1, y1, x2, y2)
	end
	love.graphics.print("Waveform: " .. wf, 10, 10)
end

return scope
