local cards = {
["Strike"] = {
name = "strike",
cost = 1,
description = "Deal 6 damage",
effect = function(target)
	target.hp = target.hp - 6
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
image = love.graphics.newImage("defend.png"),
targetType = "player"
},
["Defensive Strike"] = {
name = "defensive strike",
cost = 2,
description = "Deal 5 damage and gain 5 block",
effect = function(player, target)
	target.hp = target.hp - 5
	player.block = (player.block or 0) + 5
end,
image = love.graphics.newImage("defensiveStrike.png"),
targetType = "both"
}
}

return cards

