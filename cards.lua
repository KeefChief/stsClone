local cards = {
["Strike"] = {
name = "strike",
cost = 1,
description = "Deal %d damage",
baseDamage = 6,
damage = 6,
strengthScale = 1,
effect = function(target, card)
	target.hp = target.hp - card.damage
end,
getDescription = function(card)
	return string.format(card.description, card.damage)
end,
image = love.graphics.newImage("strike.png"),
targetType = "enemy"
},
["Defend"] = {
name = "defend",
cost = 1,
description = "Gain 5 block",
effect = function(player)
	player.block = (player.block or 0) + 5
end,
getDescription = function(card)
	return string.format(card.description)
end,
image = love.graphics.newImage("defend.png"),
targetType = "player"
},
["Defensive Strike"] = {
name = "defensive strike",
cost = 2,
description = "Deal %d damage and gain 5 block",
baseDamage = 5,
damage = 5,
effect = function(player, target, card)
	target.hp = target.hp - card.damage
	player.block = (player.block or 0) + 5
end,
getDescription = function(card)
	return string.format(card.description, card.damage)
end,
image = love.graphics.newImage("defensiveStrike.png"),
targetType = "both"
}
}

return cards

