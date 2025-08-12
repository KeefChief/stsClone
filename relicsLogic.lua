relicsLogic = {}

function relicsLogic:onDamageEffects(player)
	for i, relic in ipairs(player.relics) do
		if relic.type == "onDamage" then
			relic.effect(player)
		end
	end
end

function relicsLogic:beforeDamageEffects(player, damage)
	for i, relic in ipairs(player.relics) do
		if relic.type == "beforeDamage" then
			damage = relic.effect(player, damage)
		end
	end
	return damage
end

return relicsLogic