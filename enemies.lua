local enemies = {
["Goblin"] = {
name = "Goblin",
baseImage = love.graphics.newImage("enemy.png"),
outlinedImage = love.graphics.newImage("enemyOut.png"),
image = baseImage,
maxHp = 20,
hp = 20,
enemyW = 82,
enemyH = 161,
attackType = "random",
randomAttackList = {
{name = "slash", func = function(player)
	player:takeDamage(5)
end
}
}
}
}

return enemies