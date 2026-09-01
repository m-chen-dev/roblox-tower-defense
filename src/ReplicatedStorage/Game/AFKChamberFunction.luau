local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

return function()
	local afkChamber = workspace.AFKChamber
	local disableAFKChamber = script.Parent.DisableAFKChamber
	local recordedTexts = {}
	local coolDown = {}
	local serverSideAFKWindow = StarterGui.AFK.AFKWindow
	
	for i, v in serverSideAFKWindow:GetDescendants() do
		if v:IsA("TextLabel") then
			recordedTexts[v.Name] = v.Text
		end
	end
	
	local function findKeyInTable(givenTable : {}, key : string)
		for i, v in pairs(givenTable) do
			if i == key then
				return true
			end
		end
		return false
	end
	
	afkChamber.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			local afkWindow = player.PlayerGui:WaitForChild("AFK"):WaitForChild("AFKWindow")
			if afkWindow.Visible == true then
				return
			end

			afkWindow.Visible = true
			player:SetAttribute("AFK", true)
		end
	end)

	
	disableAFKChamber.OnServerEvent:Connect(function(player)
		local afkWindow = player.PlayerGui:WaitForChild("AFK"):WaitForChild("AFKWindow")
		if afkWindow.Visible == true then
			
			afkWindow.Visible = false
			player:SetAttribute("AFK", false)
			for i, v in afkWindow:GetDescendants() do
				if v:IsA("TextLabel") and findKeyInTable(recordedTexts, v.Name) then
					v.Text = recordedTexts[v.Name]
				end
				
			end
		end
	end)
end