local enemies = require("enemies")

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemyName)
	local proto = enemies[enemyName]
	local instance = {
	name = proto.name,
	baseImage = proto.baseImage,
	outlinedImage = proto.outlinedImage,
	image = proto.baseImage,
	maxHp = proto.maxHp,
	hp = proto.hp,
	x = 0,
	y = 0,
	enemyW = proto.enemyW,
	enemyH = proto.enemyH
	}
	
	setmetatable(instance, Enemy)
	return instance
end

return Enemy