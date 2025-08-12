local enemies = {}

enemies.dealBlock = function(damage, player)
	local damageToBlock = math.min(player.block, damage)
	player.block = player.block - damageToBlock
	damage = damage - damageToBlock
	if damage > 0 then
		player.hp = player.hp - damage
	end
end

enemies ["Goblin"] = {
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
function(player)
	if player.block > 0 then
		enemies.dealBlock(5, player)
	else
		player.hp = player.hp - 5
	end
end
}
}

return enemies