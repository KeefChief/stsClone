local cards = {
["Strike"] = {
name = "strike",
cost = 1,
description = "Deal 6 damage",
effect = function(target)
	target.hp = target.hp - 6
end,
image = love.graphics.newImage("strike.png")
},
["Defend"] = {
name = "defend",
cost = 1,
description = "Gain 5 block",
effect = function(player)
	player.block = (player.block or 0) + 5
end,
image = love.graphics.newImage("defend.png")
}
}

return cards

