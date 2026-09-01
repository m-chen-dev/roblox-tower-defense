local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

return function()
	
	Players.PlayerAdded:Connect(function(player)
		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"
		local cash = Instance.new("IntValue", leaderstats)
		cash.Value = 10
		cash.Name = "Cash"
	end)
	if RunService:IsClient() then
		local player = Players.LocalPlayer
		local cashGui = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Cash")
		cashGui.Text = "Cash: $"..10
		player:WaitForChild("leaderstats"):WaitForChild("Cash").Changed:Connect(function(value)
			cashGui.Text = "Cash: $"..value
		end)
	end
end