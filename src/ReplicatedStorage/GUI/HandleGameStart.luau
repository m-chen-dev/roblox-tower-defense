local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startEvent = ReplicatedStorage.Game.Start
local startButton = Players.LocalPlayer.PlayerGui:WaitForChild("Start"):WaitForChild("TextButton")

return function()
	startButton.MouseButton1Click:Connect(function()
		startEvent:FireServer()
	end)
end