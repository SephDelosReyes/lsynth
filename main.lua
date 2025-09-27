local sampleRate = 44100
local freq = 440 --A4
local phase = 0
local playing = false
local lastBuffer = {}
local source = love.audio.newQueueableSource(sampleRate, 16, 1)

local function sine()
	local phaseIncrement = (2 * math.pi * freq * (phase / sampleRate))
	return math.sin(phaseIncrement)
end

local function pushBuffer()
	if not playing then
		--push silence when not playing
		local silence = love.sound.newSoundData(1024, sampleRate, 16, 1)
		source:queue(silence)
		return
	end

	local soundData = love.sound.newSoundData(1024, sampleRate, 16, 1)
	for i = 0, soundData:getSampleCount() - 1 do
		local sample = sine()
		soundData:setSample(i, sample * 0.2) --scale volume
		phase = phase + 1
		lastBuffer[i + 1] = sample -- keep a copy for oscilloscope, and 1-indexed lua things btw.
	end
	source:queue(soundData)
end

function love.load() end

function love.keypressed(key)
	if key == "a" then
		freq = 440 --a4
		playing = true
		if not source:isPlaying() then
			source:play()
		end
	end
end

function love.keyreleased(key)
	if key == "a" then
		playing = false
	end
end

function love.update(dt)
	if source:getFreeBufferCount() > 0 then
		pushBuffer()
	end
end

function love.draw()
	love.graphics.print(playing and "Note ON" or "Note OFF", 10, 10)
	local midY = 200
	local scaleX = 800 / #lastBuffer
	local scaleY = 100

	for i = 1, #lastBuffer - 1 do
		local x1 = (i - 1) * scaleX
		local y1 = midY - lastBuffer[i] * scaleY
		local x2 = i * scaleX
		local y2 = midY - lastBuffer[i + 1] * scaleY
		love.graphics.line(x1, y1, x2, y2)
	end
end
