local enemies = require("enemies")
local Enemy = require("Enemy")

local activeEnemies = {}
activeEnemies.__index = activeEnemies

function activeEnemies.newSet()
	return setmetatable({
	currentEnemies = {},
	x,
	y}, activeEnemies)
end

function activeEnemies:addEnemy(enemy, x, y)
	table.insert(self.currentEnemies, enemy)
	enemy.x = x
	enemy.y = y
end

function activeEnemies:draw()
	for _, enemy in ipairs(self.currentEnemies) do
		local healthBarX =  enemy.x + enemy.enemyW / 2 - enemy.maxHp * 1.5
		love.graphics.draw(enemy.image, enemy.x, enemy.y)
		love.graphics.setColor(0.2,0,0,1)
		love.graphics.rectangle("fill", healthBarX, enemy.y, enemy.maxHp * 3, 13)
		love.graphics.setColor(1,0.2,0.2,1)
		love.graphics.rectangle("fill", healthBarX, enemy.y, enemy.hp * 3, 13)
		love.graphics.setColor(1,1,0.2,1)
		love.graphics.printf(enemy.hp .. "/" .. enemy.maxHp, healthBarX, enemy.y - 1, enemy.maxHp * 3, "center")
		love.graphics.setColor(1,1,1,1)
	end
end

function activeEnemies:isMouseOver()
local x, y = love.mouse.getPosition()
x, y = x / scale + offsetX, y / scale + offsetY
	for i = #self.currentEnemies, 1, -1 do
		local enemy = self.currentEnemies[i]
		if x >= enemy.x and x <= enemy.x + enemy.enemyW 
		and y >= enemy.y and y <= enemy.y + enemy.enemyH then
			enemy.image = enemy.outlinedImage
			break
		else
			enemy.image = enemy.baseImage
		end
	end
end

return activeEnemies