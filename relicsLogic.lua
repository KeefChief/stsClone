relicsLogic = {}

function relicsLogic:draw(player)
	for i, relic in ipairs(player.relics) do
		local startX = 10
		local startY = 10
		local spacing = 10
		local count = i - 1
		local scale = 0.25
		love.graphics.draw(relic.image, startX + (spacing + 128 * scale) * count, startY, 0, scale, scale)
	end
end

function relicsLogic:onDamageEffects(player)
	for i, relic in ipairs(player.relics) do
		if relic.effects.onDamage then
			relic.effects.onDamage(player)
		end
	end
end

function relicsLogic:beforeDamageEffects(player, damage)
	for i, relic in ipairs(player.relics) do
		if relic.effects.beforeDamage then
			damage = relic.effects.beforeDamage(player, damage)
		end
	end
	return damage
end

function relicsLogic:onStartOfTurnEffects(player)
	for i, relic in ipairs(player.relics) do
		if relic.effects.onStartOfTurn then
			relic.effects.onStartOfTurn(player)
		end
	end
end

function relicsLogic:onDraw(player)
	for i, relic in ipairs(player.relics) do
		if relic.effects.onDraw then
			relic.effects.onDraw(player)
		end
	end
end

return relicsLogic