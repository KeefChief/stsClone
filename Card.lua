local cards = require("cards")

local Card = {}
Card.__index = Card

function Card.new(cardName)
	local proto = cards[cardName]
	assert(proto, "invalid card name" .. tostring(cardName))
	
	local instance = {
	name = proto.name,
	cost = proto.cost,
	description = proto.description,
	effect = proto.effect,
	image = proto.image,
	targetType = proto.targetType
	}
	
	setmetatable(instance,Card)
	return instance
end

return Card