local player = require("player")
local Hand = require("handDraw")
local enemies = require("enemies")
local Enemy = require("Enemy")
local activeEnemies = require("activeEnemies")
local turnManager = require("turnManager")
local battleManager = require("battleManager")

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

_G.scale = 1
_G.offsetX = 0
_G.offsetY = 0
enemySet = nil

local background = love.graphics.newImage("background.png")

function love.load()
	math.randomseed(os.time())
	math.random()
	battleManager:startBattle()
	love.window.setMode(1400,720)
	print("Game Loaded!")
	player.init()
	print(#player.deck)
	enemySet:addEnemy(Enemy.new("Goblin"), 950, 170)
	enemySet:addEnemy(Enemy.new("Goblin"), 950, 320)
	bigFont = love.graphics.newFont(24)
	defaultFont = love.graphics.getFont()
	turnManager:init()
	turnManager:startPlayerTurn()
end

function love.update(dt)
	player.hand:layout()
	player.hand:update(dt)
	enemySet:update(dt)
	enemySet:isMouseOver()
	turnManager:update()
	turnManager:handleEnemyTurn(dt)
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
	
	love.graphics.draw(background)
	love.graphics.draw(player.image,player.x, player.y)
	enemySet:draw()
	player.hand:draw()
	player.draw()
	turnManager:draw()
	love.graphics.print(#player.deck)
	love.graphics.print(#player.discardPile,0, 24)
	love.graphics.print(#player.hand.cards, 0, 12)
	
	love.graphics.pop()
end

function getVirtualCoords(x, y)
    return (x - offsetX) / scale, (y - offsetY)/ scale
end

function love.mousepressed(x, y, button)
    local vx, vy = getVirtualCoords(x, y)
    player.hand:mousepressed(vx, vy, button)
	turnManager:mousepressed(vx,vy,button)
end

function love.mousereleased(x, y, button)
    local vx, vy = getVirtualCoords(x, y)
    player.hand:mousereleased(vx, vy, button)
	turnManager:mousereleased(vx,vy,button)
end

function lerp(a, b, t)
  return a + (b - a) * t
end