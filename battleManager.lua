activeEnemies = require("activeEnemies")

battleManager = {}

function battleManager:startBattle()
	enemySet = activeEnemies.newSet()
end

return battleManager