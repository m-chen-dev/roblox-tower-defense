local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = player.PlayerGui:WaitForChild("ScreenGui")
local upgradeGui = gui:WaitForChild("UpgradeGUI")

local function handleCloseClick()
	local close = upgradeGui:WaitForChild("Close")

	close.MouseButton1Click:Connect(function()
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
	end)
end



return function()
	handleCloseClick()
end