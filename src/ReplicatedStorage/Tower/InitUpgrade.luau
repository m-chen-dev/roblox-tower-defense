local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local VisibleRange = ReplicatedStorage.Game.VisibleRange
local Upgrade = {}

Upgrade.toggleGui = function(player : Player)
	ReplicatedStorage.GUI.RemoteEvent:FireClient(player)
end

Upgrade.upgradeIndexes = {
	[1] = "30",
	[2] = "100",
	[3] = "500"
}

Upgrade.currentUpgradeIndexes = {}

Upgrade.costData = {
	["30"] = {35, 0.8, 5, 5},
	["100"] = {60, 0.75, 10, 10},
	["500"] = {100, 0.5, 20, 20}
}

local function initializeValues(currentUpgradeIndex)
	if currentUpgradeIndex > 3 then
		return 
	end
	local cost = Upgrade.upgradeIndexes[currentUpgradeIndex] 
	local upgradeDamage = Upgrade.costData[cost][1]
	local upgradeRateOfFire = Upgrade.costData[cost][2]
	local upgradeRangeY = Upgrade.costData[cost][3]
	local upgradeRangeZ = Upgrade.costData[cost][4]
	return cost, upgradeDamage, upgradeRateOfFire, upgradeRangeY, upgradeRangeZ
end

local function updateGui(player : Player, cost : number)
	local upgradeGui = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI")
	upgradeGui:WaitForChild("CostUpgrade").Text = "Upgrade: $"..cost
	upgradeGui:WaitForChild("CostSell").Text = "Sell: $"..(cost/2)
end

Upgrade.addToIndex = function(unit : Instance)
	Upgrade.currentUpgradeIndexes[unit] = 1
end
Upgrade.StoredSellConnection = nil
Upgrade.StoredSellConnectionInput = nil
Upgrade.SellRemote = Instance.new("RemoteEvent", ReplicatedStorage)
Upgrade.SellRemote.Name = "SellRemote"


Upgrade.SellFunctionality = function(player : Player, sellText : TextLabel, sellButton : TextButton)
	
	if RunService:IsServer() then
		if Upgrade.StoredSellConnectionInput then
			Upgrade.StoredSellConnectionInput:Disconnect()
			Upgrade.StoredSellConnectionInput = nil
		end
		Upgrade.StoredSellConnectionInput = Upgrade.SellRemote.OnServerEvent:Connect(function(player)
			


			local unit = player:FindFirstChild("SelectedUnit").Value :: Instance
			local sellText = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell")
			sellText.Text = "Sell: $"..unit:GetAttribute("Value")/2

	
			table.remove(Upgrade.currentUpgradeIndexes, table.find(Upgrade.currentUpgradeIndexes, unit))
			unit:Destroy()
			player:SetAttribute("CurrentUnits", player:GetAttribute("CurrentUnits") - 1)
			player:WaitForChild("leaderstats"):WaitForChild("Cash").Value += unit:GetAttribute("Value")/2
			Upgrade.toggleGui(player, false)
		end)
	end

	
	if Upgrade.StoredSellConnection then
		Upgrade.StoredSellConnection:Disconnect()
		Upgrade.StoredSellConnection = nil
	end
	
	
	
	local unit = player:FindFirstChild("SelectedUnit").Value :: Instance

	sellText.Text = "Sell: $"..unit:GetAttribute("Value")/2


	Upgrade.StoredSellConnection = sellButton.MouseButton1Click:Connect(function()
		table.remove(Upgrade.currentUpgradeIndexes, table.find(Upgrade.currentUpgradeIndexes, unit))
		unit:Destroy()
		player:WaitForChild("leaderstats"):WaitForChild("Cash").Value += unit:GetAttribute("Value")/2
		player:SetAttribute("CurrentUnits", player:GetAttribute("CurrentUnits") - 1)
		Upgrade.toggleGui(player, false)
	end)
	
	
end

Upgrade.StoredUpgradeConnection = nil
Upgrade.StoredUpgradeConnectionInput = nil
Upgrade.UpgradeRemote = Instance.new("RemoteEvent", ReplicatedStorage)
Upgrade.UpgradeRemote.Name = "UpgradeRemote"



Upgrade.UpgradeFunctionality = function(player : Player,  upgradeText : TextLabel, upgradeButton : TextButton)
	
	if Upgrade.StoredUpgradeConnection then
		Upgrade.StoredUpgradeConnection:Disconnect()
		Upgrade.StoredUpgradeConnection = nil
	end

	if RunService:IsServer() then
		if Upgrade.StoredUpgradeConnectionInput then
			Upgrade.StoredUpgradeConnectionInput:Disconnect()
			Upgrade.StoredUpgradeConnectionInput = nil
		end
		Upgrade.StoredUpgradeConnectionInput = Upgrade.UpgradeRemote.OnServerEvent:Connect(function(player)
			if Upgrade.StoredUpgradeConnection then
				Upgrade.StoredUpgradeConnection:Disconnect()
				Upgrade.StoredUpgradeConnection = nil
			end




			local unit = player:FindFirstChild("SelectedUnit").Value :: Instance
			local cash = player:WaitForChild("leaderstats"):WaitForChild("Cash") :: IntValue
			local upgradeText = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostUpgrade")


			local unitDamage = unit:FindFirstChild("Damage") :: IntValue
			local unitRateOfFire = unit:FindFirstChild("RateOfFire") :: IntValue
			local currentUpgradeIndex = Upgrade.currentUpgradeIndexes[unit]
			local cost, upgradeDamage, upgradeRateOfFire, upgradeRangeY, upgradeRangeZ = initializeValues(currentUpgradeIndex)
			if not cost then
				upgradeText.Text = "Max"
				player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text  = "Sell: $"..unit:GetAttribute("Value")
				return
			end
			upgradeText.Text = "Upgrade: $"..cost or "Max"



			if cash.Value >= tonumber(cost) then
				cash.Value -= tonumber(cost)
				unit:FindFirstChildOfClass("BillboardGui").Enabled = true
				unitDamage.Value = upgradeDamage
				unitRateOfFire.Value = upgradeRateOfFire
				local range = unit:FindFirstChild("Range") :: BasePart
				range.Size += Vector3.new(0, upgradeRangeY, upgradeRangeZ)
				local rune = range:FindFirstChild("Rune") :: BasePart
				local oldSizeX = rune.Size.X
				rune.Size = Vector3.new(oldSizeX, range.Size.Y, range.Size.Z)
				Upgrade.currentUpgradeIndexes[unit] += 1
				local cost = initializeValues(Upgrade.currentUpgradeIndexes[unit])
				if not cost then
					upgradeText.Text = "Max"
					player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text  = "Sell: $"..unit:GetAttribute("Value")
					return
				end
				upgradeText.Text = "Upgrade: $"..cost or "Max"
				unit:SetAttribute("Value", tonumber(cost)/ 2 )
				player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text = "Sell: $"..unit:GetAttribute("Value")/2
			end
		end)
	end
	
	
	local unit = player:FindFirstChild("SelectedUnit").Value :: Instance
	local cash = player:WaitForChild("leaderstats"):WaitForChild("Cash") :: IntValue



	local unitDamage = unit:FindFirstChild("Damage") :: IntValue
	local unitRateOfFire = unit:FindFirstChild("RateOfFire") :: IntValue
	local currentUpgradeIndex = Upgrade.currentUpgradeIndexes[unit]
	local cost, upgradeDamage, upgradeRateOfFire, upgradeRangeY, upgradeRangeZ = initializeValues(currentUpgradeIndex)
	if not cost then
		upgradeText.Text = "Max"
		player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text  = "Sell: $"..unit:GetAttribute("Value")
		return
	end
	upgradeText.Text = "Upgrade: $"..cost or "Max"



	Upgrade.StoredUpgradeConnection = upgradeButton.MouseButton1Click:Connect(function()
		if cash.Value >= tonumber(cost) then
			cash.Value -= tonumber(cost)
			unitDamage.Value = upgradeDamage
			unitRateOfFire.Value = upgradeRateOfFire
			local range = unit:FindFirstChild("Range") :: BasePart
			range.Size += Vector3.new(0, upgradeRangeY, upgradeRangeZ)
			local rune = range:FindFirstChild("Rune") :: BasePart
			local oldSizeX = rune.Size.X
			rune.Size = Vector3.new(oldSizeX, range.Size.Y, range.Size.Z)
			unit:FindFirstChildOfClass("BillboardGui").Enabled = true
			Upgrade.currentUpgradeIndexes[unit] += 1
			local cost = initializeValues(Upgrade.currentUpgradeIndexes[unit])
			if not cost then
				upgradeText.Text = "Max"
				player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text  = "Sell: $"..unit:GetAttribute("Value")
				return
			end
			upgradeText.Text = "Upgrade: $"..cost or "Max"
			unit:SetAttribute("Value", tonumber(cost)/ 2 )
			player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI"):WaitForChild("CostSell").Text = "Sell: $"..unit:GetAttribute("Value")/2
		end

	end)
	
	
	
	
	
	
end

Upgrade.ActivateFunctionality = function(unit : Instance, clickDetector : ClickDetector)
	
	clickDetector.MouseClick:Connect(function(player)
		if unit:FindFirstChild("Owner").Value ~= player then
			return
		end
		if not player:FindFirstChild("SelectedUnit") then
			local SelectedUnit = Instance.new("ObjectValue", player)
			SelectedUnit.Value = unit
			SelectedUnit.Name = "SelectedUnit"
		end
		if not player:FindFirstChild("Range") then
			local Range = Instance.new("ObjectValue", player)
			Range.Value = unit:FindFirstChild("Range")
			Range.Name = "Range"
		end
		local SelectedUnit = player:FindFirstChild("SelectedUnit") :: ObjectValue
		SelectedUnit.Value = unit
		
		local range = player:FindFirstChild("Range") :: ObjectValue
		range.Value = unit:FindFirstChild("Range")
		VisibleRange:FireClient(player)

		Upgrade.toggleGui(player)
		local upgradeGui = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("UpgradeGUI")
		local upgradeText = upgradeGui:WaitForChild("CostUpgrade")
		local sellText = upgradeGui:WaitForChild("CostSell")
		local upgradeButton = upgradeGui:WaitForChild("UpgradeButton")
		local sellButton = upgradeGui:WaitForChild("SellButton")
		Upgrade.UpgradeFunctionality(player, upgradeText, upgradeButton)
		Upgrade.SellFunctionality(player, sellText, sellButton)
	end)
	
end

return Upgrade