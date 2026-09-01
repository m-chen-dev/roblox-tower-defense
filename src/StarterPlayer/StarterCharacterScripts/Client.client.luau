local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

ReplicatedStorage.Game.Start.OnClientEvent:Connect(function()
	local startButton = Players.LocalPlayer.PlayerGui:WaitForChild("Start"):WaitForChild("TextButton")
	startButton.Visible = false
end)

local InitSprint = require(ReplicatedStorage.Character.InitSprint)
InitSprint()
local NotifyScript = require(ReplicatedStorage.GUI.NotifyScript)
NotifyScript()
local InitUpdateHealth = require(ReplicatedStorage.GUI.InitUpdateHealth)
InitUpdateHealth()

local InitCash = require(ReplicatedStorage.Cash.InitCash)
InitCash()
local ClientInitScript = require(ReplicatedStorage.GUI.ClientInitScript)
ClientInitScript()
local player = Players.LocalPlayer
local upgradeGui = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI")
local VisibleRangeFunction = require(ReplicatedStorage.Game.VisibleRangeFunction)

VisibleRangeFunction()

local InitAfkWindow = require(ReplicatedStorage.GUI.InitAfkWindow)
InitAfkWindow()

local InitUpgradeUI = require(ReplicatedStorage.GUI.InitUpgradeUI)
InitUpgradeUI()

local HandleGameStart = require(ReplicatedStorage.GUI.HandleGameStart)
HandleGameStart()

local InitWaveUI = require(ReplicatedStorage.GUI.InitWaveUI)
InitWaveUI()


local function checkVisiblity()
	local isVisible = nil
	task.spawn(function()
		for i, v in upgradeGui:GetChildren() do
			if v.Visible then
				isVisible = true
				continue
			else
				isVisible = false
			end
		end
	end)
	return isVisible
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	if input.KeyCode == Enum.KeyCode.T and checkVisiblity() then
		local player = Players.LocalPlayer
		ReplicatedStorage:WaitForChild("UpgradeRemote"):FireServer()
	elseif input.KeyCode == Enum.KeyCode.X and checkVisiblity() then
		local player = Players.LocalPlayer
		ReplicatedStorage:WaitForChild("SellRemote"):FireServer()		
	end
end)


ReplicatedStorage.GUI.RemoteEvent.OnClientEvent:Connect(function(value)
	local mouse = player:GetMouse()
	
	
	task.spawn(function()
		for i, v in upgradeGui:GetChildren() do
			v.Visible = value or not v.Visible
		end
	end)
	
	mouse.Button1Down:Connect(function()
		if checkVisiblity() then
			task.spawn(function()
				for i, v in upgradeGui:GetChildren() do
					v.Visible = false
				end
				if player:FindFirstChild("Range") then
					player:FindFirstChild("Range").Value.Transparency = 1
					for i, v in player:FindFirstChild("Range").Value:FindFirstChild("Rune"):GetChildren() do
						if not v:IsA("Decal") then continue end
						v.Transparency = 1
					end
				end
			end)
		end
	end)
	
end)

