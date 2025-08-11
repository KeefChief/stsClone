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
relics = {}
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
	player.hand = Hand.new()
end

function player.drawCards(amount)
	for i = 1, amount do
		local index = math.random(1, #player.deck)
		local card = player.deck[index]
		local card = table.remove(player.deck, index)
		player.hand:addCard(card)	
	end
end

return player