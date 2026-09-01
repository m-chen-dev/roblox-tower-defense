local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

return function()
	local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local oldWalkspeed = humanoid.WalkSpeed	
	local goalWalkspeed = 32
	
	UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftAlt then
			humanoid.WalkSpeed = goalWalkspeed
		end
	end)
	UserInputService.InputEnded:Connect(function(input, gpe)
		if gpe then
			return
		end
		if input.KeyCode == Enum.KeyCode.LeftAlt then
			humanoid.WalkSpeed = oldWalkspeed
		end
	end)
end