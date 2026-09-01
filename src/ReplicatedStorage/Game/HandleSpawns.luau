local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local InitTargeting = require(ReplicatedStorage.Tower.InitTargeting)
local InitUpgrade = require(ReplicatedStorage.Tower.InitUpgrade)


return function()
	local spawnPartRemote = script.Parent.SpawnPart
	spawnPartRemote.OnServerEvent:Connect(function(player, position : Vector3, size : Vector3, rotation : Vector3, transparency : number, material : Enum.Material)
		if player:GetAttribute("CurrentUnits") == 5 then
			ReplicatedStorage.GUI.NotifyForMax:FireClient(player)
			return
		end
		if player:WaitForChild("leaderstats"):WaitForChild("Cash").Value >= 10 then
			player:SetAttribute("CurrentUnits", player:GetAttribute("CurrentUnits") + 1)
			local new = script.Parent.Unit:Clone()
			local range = script.Parent.Range:Clone()
			range.Parent = new
			new.Parent = workspace
			new.Position = position
			range.Position = Vector3.new(new.Position.X, 0.5, new.Position.Z)
			range.Transparency = 1
			for i, v in range:FindFirstChild("Rune"):GetChildren() do
				if not v:IsA("Decal") then continue end
				v.Transparency = 1
			end
			TweenService:Create(range:FindFirstChild("Rune"), TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Orientation = range:FindFirstChild("Rune").Orientation + Vector3.new(0, 360, 0)}):Play()
			range:FindFirstChild("Rune").Position = range.Position
			new.CollisionGroup = "NPC"
			local owner = Instance.new("ObjectValue", new)
			owner.Value = player
			owner.Name = "Owner"
			local damage = ReplicatedStorage.Tower.Damage:Clone()
			local rateOfFire = ReplicatedStorage.Tower.RateOfFire:Clone()
			damage.Parent = new
			rateOfFire.Parent = new
			InitTargeting(new)
			local clickDetector = Instance.new("ClickDetector", new)
			clickDetector.CursorIcon = "rbxassetid://14663777836"
			clickDetector.MaxActivationDistance = 1000
			InitUpgrade.addToIndex(new)
			InitUpgrade.ActivateFunctionality(new, clickDetector)
			player:WaitForChild("leaderstats"):WaitForChild("Cash").Value -= 10
		else
			ReplicatedStorage.GUI.NotifyForInsufficientFunds:FireClient(player)
		end
	end)
end