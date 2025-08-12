local cardLogic = {}

function cardLogic.playCard(player,target,card)
	for i, c in ipairs(player.hand.cards) do
		if c == card and player.energy >= card.cost then
			table.insert(player.discardPile, player.hand.cards[i])
			table.remove(player.hand.cards, i)
			break
		end
	end
	
	if player.energy >= card.cost then
		if card.targetType == "player" then
			card.effect(player)
		elseif card.targetType == "enemy" then
			card.effect(target)
		elseif card.targetType == "both" then
			card.effect(player, target)
		end
		player.energy = player.energy - card.cost
	end
end

return cardLogic