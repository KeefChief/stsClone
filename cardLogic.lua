local cardLogic = {}

function cardLogic.playCard(player, target, card)
    if player.energy < card.cost or card.isDiscarding then
        return
    end

    card.isDiscarding = true
    player.energy = player.energy - card.cost

    table.insert(player.discardPile, card)

    flux.to(card, 0.3, { x = VIRTUAL_WIDTH / 2, y = VIRTUAL_HEIGHT / 2 })
        :ease("quadinout")
        :oncomplete(function()
            flux.to({}, 0.3, {}):oncomplete(function()
                if card.targetType == "player" then
                    card.effect(player)
                elseif card.targetType == "enemy" then
                    card.effect(target, card)
                elseif card.targetType == "both" then
                    card.effect(player, target, card)
                end

                flux.to({}, 0.5, {}):oncomplete(function()
                    flux.to(card, 0.4, { x = VIRTUAL_WIDTH + 200, y = VIRTUAL_HEIGHT + 200 })
                        :ease("quadout")
                        :oncomplete(function()
							card.toRemove = true
                            player.hand:layout()
                        end)
                end)
            end)
        end)
end

return cardLogic