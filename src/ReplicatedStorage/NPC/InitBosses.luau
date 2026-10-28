local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

local InitMoving = require(ReplicatedStorage.NPC.InitMoving)
local InitDeath = require(ReplicatedStorage.NPC.InitDeath)
local InitUpdateHealthUI = require(ReplicatedStorage.NPC.InitUpdateHealthUI)


local function initValue(npc : Model, bossType : "boss" | "miniboss")
	local function bossValue()
		npc:SetAttribute("Value", npc:GetAttribute("Value") * 4)
	end
	local function miniBossValue()
		npc:SetAttribute("Value", npc:GetAttribute("Value") * 3)
	end
	local mappings = {boss = bossValue, miniboss = miniBossValue}
	mappings[bossType]()
end

function module.miniBoss()
	local npc = ReplicatedStorage:FindFirstChild("NPCModel"):Clone()
	initValue(npc, "miniboss")
	task.spawn(function()
		for i, v in npc:GetChildren() do
			if v:IsA("BasePart") then
				v.CollisionGroup = "NPC"
			end
		end
	end)
	local humanoid = npc.Humanoid
	local miniBossGui = npc.Head.BillboardGui.MiniBoss
	miniBossGui.Visible = true
	humanoid.MaxHealth = ReplicatedStorage.MaxHealth.Value * 2 * #Players:GetPlayers()
	humanoid.WalkSpeed = ReplicatedStorage.MaxWalkspeed.Value // 1.5
	local hasGrantedHealth = false
	if not hasGrantedHealth then
		hasGrantedHealth = not hasGrantedHealth
		humanoid.Health = humanoid.MaxHealth
	end
	InitUpdateHealthUI(npc)
	npc.Parent = workspace.Enemies
	
	local spawnLocation = workspace.EnemySpawning.SpawnLocation
	npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)
	InitDeath(npc)
	InitMoving(npc)
end

function module.bigBoss()
	local npc = ReplicatedStorage:FindFirstChild("NPCModel"):Clone()
	initValue(npc, "boss")
	task.spawn(function()
		for i, v in npc:GetChildren() do
			if v:IsA("BasePart") then
				v.CollisionGroup = "NPC"
			end
		end
	end)
	local humanoid = npc.Humanoid
	local bigBossGUI = npc.Head.BillboardGui.BigBoss

	bigBossGUI.Visible = true
	humanoid.MaxHealth = ReplicatedStorage.MaxHealth.Value * 3 * #Players:GetPlayers()
	humanoid.WalkSpeed = ReplicatedStorage.MaxWalkspeed.Value // 2
	local hasGrantedHealth = false
	if not hasGrantedHealth then
		hasGrantedHealth = not hasGrantedHealth
		humanoid.Health = humanoid.MaxHealth
	end
	InitUpdateHealthUI(npc)
	npc.Parent = workspace.Enemies
	local spawnLocation = workspace.EnemySpawning.SpawnLocation
	npc:PivotTo(spawnLocation.CFrame + Vector3.yAxis * spawnLocation.Size.Y * npc:FindFirstChild("Right Leg").Size.Y)
	InitDeath(npc)
	InitMoving(npc)
end

return module
