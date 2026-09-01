local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InitDamageBase = require(ReplicatedStorage.Game.InitDamageBase)

ReplicatedStorage.Game.Start.OnServerEvent:Connect(function(player)
	ReplicatedStorage.Game.Start:FireAllClients()
	ReplicatedStorage.Game.Initialized.Value = true
end)

local AFKChamberFunction = require(ReplicatedStorage.Game.AFKChamberFunction)
AFKChamberFunction()
local AFKGrant = require(ReplicatedStorage.Cash.AFKGrant)
AFKGrant()

local InitCash = require(ReplicatedStorage.Cash.InitCash)
local InitUpdateHealth = require(ReplicatedStorage.GUI.InitUpdateHealth)
InitCash()
local InitCollisions = require(ReplicatedStorage.Character.InitCollisions)
Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("CurrentUnits", 0)
	player.CharacterAdded:Connect(function(character)
		InitCollisions(character)
		if not character:HasTag("Player") then
			character:AddTag("Player")
		end
	end)
end)

local HandleSpawns = require(ReplicatedStorage.Game.HandleSpawns)
HandleSpawns()


local InitSpawnNPC = require(ReplicatedStorage.NPC.InitSpawnNPC)
local npc = ReplicatedStorage:FindFirstChild("")

InitSpawnNPC(npc)

InitDamageBase()

local units = CollectionService:GetTagged("Unit")
local InitEnd = require(ReplicatedStorage.Game.InitEnd)
local endGameRemote = ReplicatedStorage.Game.End

Players.PlayerAdded:Wait().CharacterAdded:Wait()





endGameRemote.OnServerEvent:Connect(InitEnd)


