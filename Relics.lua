local Relics = {
	["tungsten bar"] =  {
	name = "Tungsten Bar",
	effect = function(player, damage)
		return math.max(damage -1, 0)
	end,
	type = "beforeDamage"
}
}

return Relics