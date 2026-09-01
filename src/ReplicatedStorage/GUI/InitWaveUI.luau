local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local updateCountdown = ReplicatedStorage.GUI.UpdateCountdown
local currentWave = ReplicatedStorage.CurrentWave
local player = Players.LocalPlayer
local mainGui = player.PlayerGui:WaitForChild("ScreenGui")
local waveNotifier = mainGui:WaitForChild("Notifier")
local waveNumber = mainGui:WaitForChild("Wave")

local function handleUpdateWaveNotifier()
	waveNotifier.Visible = false
	
	updateCountdown.OnClientEvent:Connect(function(secondsRemaining : number)
		waveNotifier.Visible = true
		waveNotifier.Text = "Wave starts in " .. secondsRemaining .. " seconds"
		task.delay(6, function()
			waveNotifier.Visible = false
		end)
	end)
end

local function handleUpdateWaveNumber()
	waveNumber.Text = "Wave: " .. currentWave.Value

	currentWave.Changed:Connect(function(newValue)
		waveNumber.Text = "Wave: " .. newValue
	end)
end

return function()
	handleUpdateWaveNotifier()
	handleUpdateWaveNumber()
end