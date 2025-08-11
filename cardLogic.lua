local cardLogic = {}

function cardLogic.playCard(player,target,card)
	for i, c in ipairs(player.hand.cards) do
		if c == card then
			table.remove(player.hand.cards, i)
			break
		end
	end
	if card.targetType == "player" then
		card.effect(player)
	elseif card.targetType == "enemy" then
		card.effect(target)
	elseif card.targetType == "both" then
		card.effect(player, target)
	end
end

return cardLogic