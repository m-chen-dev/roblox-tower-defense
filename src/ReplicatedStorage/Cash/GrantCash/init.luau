local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local currentWave = ReplicatedStorage.CurrentWave
	local cashPerWave = require(script.CashPerWave)
	for i, player in Players:GetPlayers() do
		player:WaitForChild("leaderstats"):WaitForChild("Cash").Value += cashPerWave[currentWave.Value]
	end
end