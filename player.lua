local cards = require("cards")
local Hand = require("handDraw")
local Card = require("Card")

local player = {
maxHp = 0,
hp = 0,
gold = 0,
energy = 0,
maxEnergy = 0,
block = 0,
deck = {},
hand = nil,
discardPile = {},
relics = {},
image = love.graphics.newImage("player.png"),
shieldImage = love.graphics.newImage("shield.png"),
x = 150,
y = 140
}

function player.init()
	player.hp = 50
	player.maxHp = 50
	player.energy = 3
	player.maxEnergy = 3
	player.block = 0
	for i = 1,5 do 
		table.insert(player.deck, Card.new("Strike"))
	end
	for i = 1,6 do 
		table.insert(player.deck, Card.new("Defend"))
	end
	for i = 1,2 do 
		table.insert(player.deck, Card.new("Defensive Strike"))
	end
	player.hand = Hand.new(player)
end

function player.drawCards(amount)
	for i = 1, amount do
		local index = math.random(1, #player.deck)
		local card = player.deck[index]
		local card = table.remove(player.deck, index)
		player.hand:addCard(card)	
	end
end

function player.draw()
	local healthBarH = 13
	local healthBarW = player.maxHp * 2
	local pH = player.image:getHeight()
	love.graphics.setColor(1,0.2,0.2,1)
	love.graphics.rectangle("fill", player.x + 21 , player.y + pH, player.hp * 2, healthBarH)
	love.graphics.setColor(1,1,1,1)
	love.graphics.printf(player.hp .. "/" .. player.maxHp, player.x + 21, player.y + pH - 1, healthBarW, "center")
	love.graphics.draw(player.shieldImage,player.x + 15, player.y + pH - 8, 0, 0.12, 0.12)
	love.graphics.printf(player.block,player.x + 15, player.y + pH - 2,29,"center")
end

return player