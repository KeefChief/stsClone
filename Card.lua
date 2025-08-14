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
	targetType = proto.targetType,
	isDiscarding = false,
	baseDamage = proto.baseDamage,
	damage = proto.damage,
	strengthScale = proto.strengthScale,
	getDescription = proto.getDescription
	}
	
	setmetatable(instance,Card)
	return instance
end


function Card:draw(x, y, scale, rot, card)
    local energyImage = love.graphics.newImage("energyCost.png") 
    local cardW, cardH = 160, 240
    local margin = - 5
    local iconBaseSize = 128
    local iconLocalScale = 0.35        
    local iconW = iconBaseSize * iconLocalScale
    local iconH = iconBaseSize * iconLocalScale

    love.graphics.push()
    love.graphics.translate(x, y) 
    love.graphics.rotate(card.rot)
    love.graphics.scale(scale, scale)

    love.graphics.draw(self.image, -cardW/2, -cardH/2)

    local iconX = -cardW/2 + margin
    local iconY = -cardH/2 + margin

    love.graphics.draw(energyImage, iconX, iconY, 0, iconLocalScale, iconLocalScale)

    love.graphics.setFont(bigFont)
    love.graphics.printf(
        self.cost,
        iconX,                                  
        iconY + iconH/2 - bigFont:getHeight()/2,
        iconW,                                   
        "center"
    )

    love.graphics.setFont(defaultFont)
    love.graphics.printf(self.name, -cardW/2, -5, cardW, "center")
    love.graphics.printf(self.getDescription(card), -cardW/2 + 8, 15, cardW - 16, "center")

    love.graphics.pop()
end

return Card