local Relics = {
["tungsten bar"] =  {
name = "Tungsten Bar",
image = love.graphics.newImage("tungstenBar.png"),
effects = {
beforeDamage = 
function(player, damage)
	return math.max(damage -1, 0)
end},
},
["snecko eye"] = {
name = "Snecko Eye",
image = love.graphics.newImage("sneckoEye.png"),
effects = {
onStartOfTurn = 
function(player)
	player.drawCards(2)
end,
onDraw = 
function(player)
	for i, card in ipairs(player.hand.cards) do
		card.cost = math.random(0, 3)
	end
end
}
}
}

return Relics