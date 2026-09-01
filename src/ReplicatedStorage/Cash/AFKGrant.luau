local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cashEarned = {}


return function()
	local afkPayout = script.Parent.AFKPayout
	local notifyClientPayout = ReplicatedStorage.GUI.NotifyClientForPayout
	
	local function findKeyInTable(givenTable : {}, key : string)
		for i, v in pairs(givenTable) do
			if i == key then
				return true
			end
		end
		return false
	end
	
	afkPayout.OnServerEvent:Connect(function(player)
		
		if player.PlayerGui:WaitForChild("AFK"):WaitForChild("AFKWindow").Visible == true then
			
			
			if not findKeyInTable(cashEarned, player.Name) then
				cashEarned[player.Name] = 30
			else
				local oldValue = cashEarned[player.Name]
				cashEarned[player.Name] = oldValue + 30
			end
			
			player:WaitForChild("leaderstats"):WaitForChild("Cash").Value += 30
			notifyClientPayout:FireClient(player, cashEarned[player.Name])
		end
	end)
end