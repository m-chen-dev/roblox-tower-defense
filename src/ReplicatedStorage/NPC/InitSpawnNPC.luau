local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local InitMoving = require(ReplicatedStorage.NPC.InitMoving)
local InitDeath = require(ReplicatedStorage.NPC.InitDeath)
local InitMutation = require(ReplicatedStorage.NPC.InitMutation)
local InitBosses = require(ReplicatedStorage.NPC.InitBosses)
local Waves = ReplicatedStorage.Waves:GetChildren()
local InitUpdateHealthUI = require(ReplicatedStorage.NPC.InitUpdateHealthUI)
local GameInfo = require(ReplicatedStorage.Game.GameInfo)
local GrantCash = require(ReplicatedStorage.Cash.GrantCash)

return function(NPC : Model)
	-- spawn a certain number of enemies of a certain type according to the waves folder
	local initialized = ReplicatedStorage.Game.Initialized
	local WaveData = require(ReplicatedStorage.Waves.WaveData)
	local function deployEnemies()
		task.spawn(function()
			for i, v in NPC:GetChildren() do
				if v:IsA("BasePart") then
					v.CollisionGroup = "NPC"
				end
			end
		end)
		while initialized.Value == false do
			task.wait()
		end
		ReplicatedStorage.GUI.InitializeClient:FireAllClients()
		for i = 6, 0, -1 do
			GameInfo.Intermission = true
			local updateCountdown = ReplicatedStorage.GUI.UpdateCountdown
			updateCountdown:FireAllClients(i)
			task.wait(1)
		end
		GameInfo.Intermission = false
		local currentWave = ReplicatedStorage.CurrentWave
		local maxHealth = ReplicatedStorage.MaxHealth
		local currentEnemies = ReplicatedStorage.CurrentEnemies
		while currentWave.Value < #WaveData do
			for waveIndex : number, waveInformation : {} in ipairs(WaveData) do
				task.spawn(function()
					for _, numberOfUnits : number in pairs(waveInformation) do
						currentEnemies.Value += numberOfUnits
					end
				end)
				
				for unitName : string, numberOfUnits : number in pairs(waveInformation) do
					
					for i = 1, numberOfUnits do
						InitMutation(NPC:Clone(), unitName:lower())
						task.wait(0.5)
					end
				end
				while currentEnemies.Value ~= 0 do
					task.wait()
				end
				maxHealth.Value += 5
				GrantCash()
				currentWave.Value += 1
				currentEnemies.Value = 0
				NPC:SetAttribute("Value", NPC:GetAttribute("Value") * 1.2)
				
				for i = 5, 0, -1 do
					GameInfo.Intermission = true
					local updateCountdown = ReplicatedStorage.GUI.UpdateCountdown
					updateCountdown:FireAllClients(i)
					task.wait(1)
				end
				GameInfo.Intermission = false
			end 
			
		end
	end

	task.spawn(function()
		deployEnemies()
	end)
	
end

