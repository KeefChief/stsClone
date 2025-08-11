local player = require("player")
local Hand = require("handDraw")
local enemies = require("enemies")
local Enemy = require("Enemy")
local activeEnemies = require("activeEnemies")

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

scale = 1

offsetX = 0
offsetY = 0

enemySet = nil

local background = love.graphics.newImage("background.png")

function love.load()
	math.randomseed(os.time())
	math.random()
	enemySet = activeEnemies.newSet()
	love.window.setMode(1920,1080)
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
	local screenW, screenH = love.graphics.getDimensions()
	local scaleX = screenW / VIRTUAL_WIDTH
	local scaleY = screenH / VIRTUAL_HEIGHT
	scale = math.min(scaleX, scaleY)
	
	offsetX = (screenW - VIRTUAL_WIDTH * scale) / 2
	offsetY = (screenH - VIRTUAL_HEIGHT * scale) / 2
	
	love.graphics.push()
	love.graphics.translate(offsetX,offsetY)
	love.graphics.scale(scale, scale)
	
	love.graphics.print(#player.deck)
	love.graphics.print(#player.hand.cards, 0, 12)
	love.graphics.draw(background)
	love.graphics.draw(player.image,player.x, player.y)
	enemySet:draw()
	enemySet:isMouseOver()
	player.hand:draw()
	player.draw()
	
	love.graphics.pop()
end

local function getVirtualCoords(x, y)
    return (x - offsetX) / scale, (y + offsetY)/ scale
end

function love.mousepressed(x, y, button)
    local vx, vy = getVirtualCoords(x, y)
    player.hand:mousepressed(vx, vy, button)
end

function love.mousereleased(x, y, button)
    local vx, vy = getVirtualCoords(x, y)
    player.hand:mousereleased(vx, vy, button)
end