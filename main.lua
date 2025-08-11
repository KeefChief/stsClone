local player = require("player")
local Hand = require("handDraw")
local enemies = require("enemies")
local Enemy = require("Enemy")
local activeEnemies = require("activeEnemies")

enemySet = nil

local background = love.graphics.newImage("background.png")

function love.load()
	math.randomseed(os.time())
	math.random()
	enemySet = activeEnemies.newSet()
	love.window.setMode(1280,720)
	print("Game Loaded!")
	player.init()
	print(#player.deck)
	player.drawCards(5)
	local testEnemy = Enemy.new("Goblin")
	enemySet:addEnemy(testEnemy, 950, 170)
end

function love.update(dt)
	player.hand:layout()
	player.hand:update(dt)
end

function love.draw()
	love.graphics.print(#player.deck)
	love.graphics.print(#player.hand.cards, 0, 12)
	love.graphics.draw(background)
	love.graphics.draw(player.image,player.x, player.y)
	enemySet:draw()
	enemySet:isMouseOver()
	player.hand:draw()
	player.draw()
end

function love.mousepressed(x, y, button)
    player.hand:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    player.hand:mousereleased(x, y, button)
end