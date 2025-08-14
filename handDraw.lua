local cardLogic = require("cardLogic")
local activeEnemies = require("activeEnemies")

local Hand = {}
Hand.__index = Hand


local cardW = 160
local cardH = 240
local normalCardW = 160
local normalCardH = 240
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
	targetOffsets = {},
	playingCard = false
	}, Hand)
end

function Hand:layout()
    local handCount = #self.cards
    local maxCurve = 20
    local centerIndex = (handCount + 1) / 2
    local denominator = centerIndex - 1
    local curveStrength = denominator ~= 0 and maxCurve / (denominator * denominator) or 0
    local spacing = maxSpacing - handCount * 4
    local screenW = VIRTUAL_WIDTH
    local screenH = VIRTUAL_HEIGHT
    local totalWidth = (handCount - 1) * spacing + cardW * 0.7 / 2
    local startX = (screenW - totalWidth) / 2
	

    for i, card in ipairs(self.cards) do
		if not card.isDiscarding then
			local distanceFromCenter = i - centerIndex
			local curve = (distanceFromCenter ^ 2) * curveStrength
			local baseY = screenH - cardH * 0.7 / 2
			card.targetX = startX + (i - 1) * spacing
			card.targetY = baseY + curve
		end
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
	card.rot = 0
end

function Hand:update(dt)
	for i = #self.cards, 1, -1 do
		if self.cards[i].toRemove then
			table.remove(self.cards, i)
		end
	end
	
	local mouseX, mouseY = getVirtualCoords(love.mouse.getPosition())
	local hoveredIndex = nil
	
	if not self.draggingCard then
		for i = #self.cards, 1, -1 do
			local card = self.cards[i]
			local halfW = cardW / 2
			local halfH = cardH / 2
			if mouseX >= card.x - halfW * 0.7 and mouseX <= card.x + halfW * 0.7
			and mouseY >= card.y - halfH * 0.7 and mouseY <= card.y + halfH * 0.7 and not card .isDiscarding then
				hoveredIndex = i 
				break
			end
		end
	end
	
	self.hoveredIndex = hoveredIndex
	if hoveredIndex then
        for i, card in ipairs(self.cards) do
            if i == hoveredIndex then
                card.targetY = card.targetY + hoverOffset
            end
        end
    else
        self:layout()
    end
	
	for i, card in ipairs(self.cards) do
		if not card.isDiscarding then
			if self.draggingCard == i then
				card.targetX = mouseX - self.dragOffsetX
				card.targetY = mouseY - self.dragOffsetY
			end
			-- Always interpolate card position toward target
			card.x = card.x + (card.targetX - card.x) * lerpSpeed * dt
			card.y = card.y + (card.targetY - card.y) * lerpSpeed * dt
		end
	end
end

function Hand:draw()
	for i,card in ipairs(self.cards) do	
		if i ~= self.hoveredIndex then
			card:draw(card.x, card.y, 0.7, 0, card)
		end
    end
	
	if self.hoveredIndex then
		local card = self.cards[self.hoveredIndex]
		card:draw(card.x, card.y, 1, 0, card)
	end
end

function Hand:mousepressed(x, y, button)
    if button == 1 then -- Left click
        for i = #self.cards, 1, -1 do
            local card = self.cards[i]
			local halfW = cardW / 2
			local halfH = cardH / 2
				if x >= card.x - halfW * 0.7 and x <= card.x + halfW * 0.7
				and y >= card.y - halfH * 0.7 and y <= card.y + halfH * 0.7 then
				hoveredIndex = i 
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
		if not self.playingCard and not card.isDiscarding then
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
		end
		lerpSpeed = 10
        self.draggingCard = nil
		self:layout()
    end
end

function Hand:applyBuffs(player)
	for i, card in ipairs(self.cards) do
		if card.damage then
			if card.strengthScale then
				card.damage = card.baseDamage + player.strength * card.strengthScale
			else
				card.damage = card.baseDamage + player.strength
			end
		end
	end
end

return Hand