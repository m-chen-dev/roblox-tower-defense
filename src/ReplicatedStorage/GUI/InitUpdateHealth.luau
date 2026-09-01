local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local player = Players.LocalPlayer
	
	local base = workspace:WaitForChild("Base")
	local textLabel = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Health")
	local lost = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("Lost")
	local endGameRemote = ReplicatedStorage.Game.End
	
	local connection
	connection = base:GetAttributeChangedSignal("Health"):Connect(function()
		if base:GetAttribute("Health") == 0 then
			connection:Disconnect()
			
			textLabel.Text = "Health: " .. base:GetAttribute("Health") .. "/5"
			
			lost.Visible = true
		
		
			endGameRemote:FireServer()	
			
		else
			textLabel.Text = "Health: " .. base:GetAttribute("Health") .. "/5"
		end
	end)
end