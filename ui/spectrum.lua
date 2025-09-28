local spectrum = {}

function spectrum.draw(data)
	local w, h = love.graphics.getDimensions()
	love.graphics.setColor(0, 0.7, 1)
	for i = 1, #data do
		local barHeight = math.log(1 + data[i]) * 20
		local x = (i / #data) * (w / 2) + w / 2
		love.graphics.line(x, h, x, h - barHeight)
	end
	love.graphics.print("Spectrum", w / 2 + 10, 10)
end

return spectrum
