local player = require("player")
local activeEnemies = require("activeEnemies")
local enemies = require("enemies")

local turnManager = {}
turnManager.__index = turnManager

function turnManager:init()
	self.isPlayerTurn = true
	self.isEnemyTurn = false
	self.enemyCooldown = 0
	self.endTurnButtonX = 1100
	self.endTurnButtonY = 600
	self.endTurnButtonWidth = 291
	self.endTurnButtonHeight = 153
	self.endTurnButtonImage = love.graphics.newImage("turnButton.png")
	self.endTurnButtonBaseImage = love.graphics.newImage("turnButton.png")
	self.endTurnButtonHoveredImage = love.graphics.newImage("turnButtonHovered.png")
	self.endTurnButtonClickedImage = love.graphics.newImage("turnButtonClicked.png")
	self.endTurnButtonImage:setFilter("nearest", "nearest")
	self.endTurnButtonBaseImage:setFilter("nearest", "nearest")
	self.endTurnButtonHoveredImage:setFilter("nearest", "nearest")
	self.endTurnButtonClickedImage:setFilter("nearest", "nearest")
end

function turnManager:draw()
	if self.isPlayerTurn then
		love.graphics.draw(self.endTurnButtonImage, self.endTurnButtonX, self.endTurnButtonY, 0, 0.5, 0.5)
	end
end

function turnManager:mousepressed(x, y, button)
	if self.isPlayerTurn and button == 1 then
		if self:isMouseOverButton(x, y) then
			self.buttonPressed = true
		end
	end
end

function turnManager:mousereleased(x, y, button)
	if self.isPlayerTurn and button == 1 then
		if self.buttonPressed and self:isMouseOverButton(x, y) then
			self:endPlayerTurn()
		end
	end
	self.buttonPressed = false
end

function turnManager:isMouseOverButton(x, y)
	local scaledWidth = self.endTurnButtonWidth * 0.5
	local scaledHeight = self.endTurnButtonHeight * 0.5
	return x >= self.endTurnButtonX and x <= self.endTurnButtonX + scaledWidth and
	       y >= self.endTurnButtonY and y <= self.endTurnButtonY + scaledHeight
end

function turnManager:update()
	local mx, my = love.mouse.getPosition()
	mx, my = (mx - offsetX) / scale, (my - offsetY) / scale
	if self.buttonPressed then
		self.endTurnButtonImage = self.endTurnButtonClickedImage
	elseif self:isMouseOverButton(mx,my) then
		self.endTurnButtonImage = self.endTurnButtonHoveredImage
	else
		self.endTurnButtonImage = self.endTurnButtonBaseImage
	end
end

function turnManager:endPlayerTurn()
	for i = 1, #player.hand.cards do
		table.insert(player.discardPile,player.hand.cards[i])
	end
		
	for i = #player.hand.cards, 1, -1 do
		player.hand.cards[i] = nil
	end

	self.isPlayerTurn = false
	self:startEnemyTurn()
end

function turnManager:startEnemyTurn()
	self.timer = 0.7
	self.index = 1
	self.isEnemyTurn = true
end

function turnManager:handleEnemyTurn(dt)
	local delay = 0.7
	if self.isEnemyTurn then
		self.timer = self.timer - dt
		if self.timer <= 0 then
			local enemy = enemySet.currentEnemies[self.index]
			if enemy then
				local attack = enemy.nextAttack
				enemy.nextAttack.func(player, enemies)
				enemy.isAttacking = true
				enemy.attackAnim = {
				elapsed = 0,
				forwardDuration = 0.05,
				backwardDuration = 0.2,
				startX = enemy.x,
				endX = enemy.x - 50,
				phase = "forward"
				}
				
				self.index = self.index + 1
				self.timer = delay
			else
				self.isEnemyTurn = false
				self:startPlayerTurn()
			end
		end
	end	
end

function turnManager:startPlayerTurn()
	for i, enemy in ipairs(enemySet.currentEnemies) do
		if enemy.attackType == "random" then
			enemy.nextAttack = enemy.randomAttackList[math.random(1, #enemy.randomAttackList)]
		end
	end
	self.isPlayerTurn = true
	player.block = 0
	player.energy = player.maxEnergy
	player.drawCards(5)
end

return turnManager