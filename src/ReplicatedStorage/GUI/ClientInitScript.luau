local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandleTowerSpawn = require(ReplicatedStorage.GUI.HandleTowerSpawn)

return function()
	local initializeClient = script.Parent.InitializeClient
	
	initializeClient.OnClientEvent:Once(function()
		HandleTowerSpawn()		
	end)
end