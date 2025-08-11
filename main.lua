local player = require("player")
local Hand = require("handDraw")
local enemies = require("enemies")


function love.load()
	love.window.setMode(1280,800)
	print("Game Loaded!")
	player.init()
	print(#player.deck)
	player.drawCards(5)
end

function love.update(dt)
	player.hand:layout()
	player.hand:update(dt)
end

function love.draw()
	love.graphics.print(#player.deck)
	love.graphics.print(#player.hand.cards, 0, 12)
	love.graphics.draw(enemies["Goblin"].image,1000, 250)
	player.hand:draw()
end

function love.mousepressed(x, y, button)
    player.hand:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    player.hand:mousereleased(x, y, button)
end