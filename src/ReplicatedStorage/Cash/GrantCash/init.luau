local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local currentWave = ReplicatedStorage.CurrentWave
	local cashPerWave = require(script.CashPerWave)
	for i, player in Players:GetPlayers() do
		if currentWave.Value >= 1 and currentWave.Value <= #cashPerWave then
			player:WaitForChild("leaderstats"):WaitForChild("Cash").Value += cashPerWave[currentWave.Value]
		end
	end
end