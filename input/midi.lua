local socket = require("socket")

local midi = {}

function midi.init()
	midi.udp = socket.udp()
	midi.udp:setsockname("127.0.0.1", 9001)
	midi.udp:settimeout(0)
end

function midi.update()
	while true do
		local data = midi.udp:receive() -- or exaxt midi spec?

		if not data then
			break
		end

		local message = load("return " .. data)()
		if message.type == nil then
			-- then it is a cc
			print("cc: " .. message.cc .. ", value: " .. message.value)
		else
			-- either note on or off with or velocity
			if message.velocity == nil then
				print("type: " .. message.type .. ", note: " .. message.note)
			else
				print("type: " .. message.type .. ", note: " .. message.note .. ", velocity: " .. message.velocity)
			end
		end
	end
end
return midi
