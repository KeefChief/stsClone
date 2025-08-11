local cardLogic = require("cardLogic")
local activeEnemies = require("activeEnemies")

local Hand = {}
Hand.__index = Hand


local cardW = 112
local cardH = 168
local hoverOffset = -30
local lerpSpeed = 10
local maxSpacing = 100

local draggedCardIndex = nil
local dragOffsetX = 0
local dragOffsetY = 0

function Hand.new(player)
	return setmetatable({
	cards = {},
	player = player,
	x,
	y,
	targetX,
	targetY,
	yOffsets = {},
	targetOffsets = {}
	}, Hand)
end

function Hand:layout()
	local handCount = #self.cards
	local curveStrength = 5
	local centerIndex = (handCount + 1) / 2
    local spacing = maxSpacing - handCount * 4
    local screenW = VIRTUAL_WIDTH
    local screenH = VIRTUAL_HEIGHT
    local totalWidth = (handCount - 1) * spacing + cardW
    local startX = (screenW - totalWidth) / 2

    for i, card in ipairs(self.cards) do
		local distanceFromCenter = i - centerIndex
		local curve = (distanceFromCenter ^ 2) * curveStrength
		local baseY = screenH - cardH
        card.targetX = startX + (i - 1) * spacing
        card.targetY = baseY + curve
	end
end

function Hand:addCard(card)
	table.insert(self.cards,card)
	self.yOffsets[#self.cards] = 0
	self.targetOffsets[#self.cards] = 0
	card.x = -cardW
	card.y = VIRTUAL_HEIGHT - cardH
	card.targetX = 0
	card.targetY = 0
end

function Hand:update(dt)
	local mouseX, mouseY = love.mouse.getPosition()
	mouseX, mouseY = mouseX / scale, mouseY / scale
	local hoveredIndex = nil
	
	if not self.draggingCard then
		for i, card in ipairs(self.cards) do				
			if mouseX >= card.x and mouseX <= card.x + cardW and mouseY >= card.y and mouseY <= card.y + cardH then
			hoveredIndex = i 
				break
			end
		end
	end
	
	for i, card in ipairs(self.cards) do
		if self.draggingCard == i then
			card.targetX = mouseX - self.dragOffsetX
			card.targetY = mouseY - self.dragOffsetY
		else
			if i == hoveredIndex then
				card.targetY = card.targetY + hoverOffset
			else
				self:layout()
			end
		end
	card.x = card.x + (card.targetX - card.x) * lerpSpeed * dt
	card.y = card.y + (card.targetY - card.y) * lerpSpeed * dt
	end
end

function Hand:draw()
	for _,card in ipairs(self.cards) do	
		love.graphics.draw(card.image, card.x, card.y,0,0.7,0.7)
		love.graphics.printf(card.name, card.x, card.y + cardH / 2 - 6, cardW, "center")		
    end
end

function Hand:mousepressed(x, y, button)
    if button == 1 then -- Left click
        for i = #self.cards, 1, -1 do
            local card = self.cards[i]
            if x >= card.x and x <= card.x + cardW and y >= card.y and y <= card.y + cardH then
				lerpSpeed = 20
                self.draggingCard = i
                self.dragOffsetX = x - card.x
                self.dragOffsetY = y - card.y
                break
            end
        end
    end
end

function Hand:mousereleased(x, y, button)
    if button == 1 and self.draggingCard then
		local card = self.cards[self.draggingCard]
		if card.targetType == "player" and y < 500 then
			cardLogic.playCard(self.player, nil, card) 
		elseif card.targetType == "enemy" or  card. targetType == "both" then
			for i = #enemySet.currentEnemies, 1, -1 do
				local enemy = enemySet.currentEnemies[i]
				if x >= enemy.x and x <= enemy.x + enemy.enemyW 
				and y >= enemy.y and y <= enemy.y + enemy.enemyH then
					cardLogic.playCard(self.player, enemy, card)
					break
				end
			end
		end
		lerpSpeed = 10
        self.draggingCard = nil
		self:layout()
    end
end

return Hand