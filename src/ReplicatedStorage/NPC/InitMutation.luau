
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InitDeath = require(ReplicatedStorage.NPC.InitDeath)
local InitMoving = require(ReplicatedStorage.NPC.InitMoving)
local InitBosses = require(ReplicatedStorage.NPC.InitBosses)
local InitUpdateHealthUI = require(ReplicatedStorage.NPC.InitUpdateHealthUI)


local function initValue(npc : Model)
	npc:SetAttribute("Value", npc:GetAttribute("Value") * 2)
end

return function(npc : Model, mutation : string)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")

	if mutation:lower() == "speedy" then
		local spawnLocation = workspace.EnemySpawning.SpawnLocation
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		local walkSpeed = ReplicatedStorage.MaxWalkspeed.Value
		local health = ReplicatedStorage.MaxHealth.Value
		humanoid.MaxHealth = health * #Players:GetPlayers()
		humanoid.Health = humanoid.MaxHealth
		
		InitUpdateHealthUI(npc)
		ReplicatedStorage.MaxWalkspeed.Changed:Connect(function(value)
			walkSpeed = value 
		end)

		ReplicatedStorage.MaxHealth.Changed:Connect(function(value)
			health = value * #Players:GetPlayers()
		end)
		
		initValue(npc)

		npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)

		npc.Parent = workspace.Enemies
		InitMoving(npc)
		InitDeath(npc)
		humanoid.WalkSpeed = ReplicatedStorage.MaxWalkspeed.Value * 2
		npc:FindFirstChild("Head"):FindFirstChild("BillboardGui"):FindFirstChild("Speedy").Visible = true
	
	elseif mutation:lower() == "tank" then
		local spawnLocation = workspace.EnemySpawning.SpawnLocation
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		local walkSpeed = ReplicatedStorage.MaxWalkspeed.Value
		local health = ReplicatedStorage.MaxHealth.Value
		humanoid.WalkSpeed = walkSpeed
		
		InitUpdateHealthUI(npc)
		ReplicatedStorage.MaxWalkspeed.Changed:Connect(function(value)
			walkSpeed = value 
		end)

		ReplicatedStorage.MaxHealth.Changed:Connect(function(value)
			health = value * #Players:GetPlayers()
		end)


		initValue(npc)


		npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)

		npc.Parent = workspace.Enemies
		InitMoving(npc)
		InitDeath(npc)
		humanoid.MaxHealth = health * 2 * #Players:GetPlayers()
		humanoid.Health = humanoid.MaxHealth
		npc:FindFirstChild("Head"):FindFirstChild("BillboardGui"):FindFirstChild("Tank").Visible = true
	elseif mutation:lower() == "clone" then
		local spawnLocation = workspace.EnemySpawning.SpawnLocation
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		local walkSpeed = ReplicatedStorage.MaxWalkspeed.Value
		local health = ReplicatedStorage.MaxHealth.Value
		humanoid.MaxHealth = health * #Players:GetPlayers()
		humanoid.Health = humanoid.MaxHealth
		humanoid.WalkSpeed = walkSpeed
		
		InitUpdateHealthUI(npc)
		ReplicatedStorage.MaxWalkspeed.Changed:Connect(function(value)
			walkSpeed = value
		end)

		ReplicatedStorage.MaxHealth.Changed:Connect(function(value)
			health = value * #Players:GetPlayers()
		end)


		initValue(npc)


		npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)

		npc.Parent = workspace.Enemies
		InitMoving(npc)
		InitDeath(npc, "clone")
		npc:FindFirstChild("Head"):FindFirstChild("BillboardGui"):FindFirstChild("Clone").Visible = true
		
		local oldWalkSpeed = humanoid.WalkSpeed
		local oldMaxHealth = humanoid.MaxHealth
		
		humanoid.Died:Connect(function()
			local pivot = npc:GetPivot()
			local clone = ReplicatedStorage:FindFirstChild("NPCModel"):Clone()
			local movingToPart = npc:FindFirstChild("MovingToPart") :: ObjectValue
			local path = workspace.Path:GetChildren()
			local cloneHumanoid = clone:FindFirstChildOfClass("Humanoid")
			cloneHumanoid.MaxHealth = oldMaxHealth
			cloneHumanoid.Health = oldMaxHealth
			cloneHumanoid.WalkSpeed = oldWalkSpeed
			InitUpdateHealthUI(clone)
			clone:FindFirstChild("Head"):FindFirstChild("BillboardGui"):FindFirstChild("Normal").Visible = true
			if not clone:HasTag("NPC") then
				clone:AddTag("NPC")
			end
			if not clone:HasTag("Clone") then
				clone:AddTag("Clone")
			end
			task.spawn(function()
				for i, v in clone:GetChildren() do
					if v:IsA("BasePart") then
						v.CollisionGroup = "NPC"
					end
				end
			end)
			clone:PivotTo(pivot)

			task.wait(1)
			clone.Parent = workspace.Enemies
			InitDeath(clone)
			InitMoving(clone, table.find(path, movingToPart.Value))
		end)
	elseif mutation:lower() == "none" or mutation:lower() == "normal" then
		local spawnLocation = workspace.EnemySpawning.SpawnLocation
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		local walkSpeed = ReplicatedStorage.MaxWalkspeed.Value
		local health = ReplicatedStorage.MaxHealth.Value
		humanoid.MaxHealth = health * #Players:GetPlayers()
		humanoid.Health = humanoid.MaxHealth
		humanoid.WalkSpeed = walkSpeed
		
		InitUpdateHealthUI(npc)
		ReplicatedStorage.MaxWalkspeed.Changed:Connect(function(value)
			walkSpeed = value
		end)

		ReplicatedStorage.MaxHealth.Changed:Connect(function(value)
			health = value * #Players:GetPlayers()
		end)




		npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)

		npc.Parent = workspace.Enemies
		InitMoving(npc)
		InitDeath(npc)
		npc:FindFirstChild("Head"):FindFirstChild("BillboardGui"):FindFirstChild("Normal").Visible = true
		
		return
	elseif mutation:lower() == "miniboss" then
		InitBosses.miniBoss()
	elseif mutation:lower() == "boss" then
		InitBosses.bigBoss()
	end
end
