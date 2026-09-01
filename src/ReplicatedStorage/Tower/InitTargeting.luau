local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GameInfo = require(ReplicatedStorage.Game.GameInfo)

local shouldRun = {}
return function(unit : Instance)
	local function getKeyAssociatedWithValue(t : {}, value : any): any
		for i, v in pairs(t) do
			if value == v then
				return i
			end
		end
	end
	
	local function getValuesFromTable(t : {}) : {}
		local rT = {}
		for i, v in pairs(t) do
			table.insert(rT, v)
		end
		return rT
	end
	
	unit.Destroying:Connect(function()
		table.remove(shouldRun, table.find(shouldRun, unit))
	end)
	local range : BasePart = unit:FindFirstChild("Range") 
	if not table.find(shouldRun, unit) then
		table.insert(shouldRun, unit)
		
		local function getTarget(target) : Model
			local primaryPart = nil
			
			task.spawn(function()
				local distances = {}
					
				for i, v in workspace:GetPartsInPart(range) do
					if v.Parent:IsA("Model") and v.Parent:HasTag("NPC") and not table.find(distances, v.Parent) then
						local humanoid : Humanoid = v.Parent:WaitForChild("Humanoid")
						if humanoid.Health <= 0 then continue end
						distances[v.Parent] = math.round((v.Parent.PrimaryPart.Position - unit.Position).Magnitude)
					end
				end
				
				
				local success, leastDistance = pcall(function()
					local leastDistance = math.min(table.unpack(getValuesFromTable(distances)))
					return leastDistance
				end)
				
				if success and leastDistance then
					local model = getKeyAssociatedWithValue(distances, leastDistance) :: Model
					primaryPart =  model.PrimaryPart
				else
					primaryPart = nil
				end
				
						
			end)
			
			return primaryPart
		end


		local function shoot()
			if not table.find(shouldRun, unit) then
				return
			end
			local bullet = Instance.new("Part", workspace.Bullets)
			bullet.Anchored = false
			bullet.Shape = Enum.PartType.Ball
			bullet.CanCollide = false
			bullet.Size = Vector3.one * 0.75
			bullet.Material = Enum.Material.Neon
			bullet.Position = unit:FindFirstChildOfClass("Attachment").WorldPosition
			bullet.Color = Color3.new(1, 0, 0)
			local hasGiven = false
			local hasDamaged = false

			bullet.Touched:Connect(function(hit)
				if not table.find(shouldRun, unit) then
					return
				end
				if hit.Parent and hit.Parent:HasTag("NPC") then
					if not hasDamaged then
						hasDamaged = not hasDamaged
						hit.Parent:FindFirstChildOfClass("Humanoid"):TakeDamage(unit:FindFirstChild("Damage").Value)
						if hit.Parent:FindFirstChildOfClass("Humanoid").Health <= 0 and not hasGiven then
							hasGiven = not hasGiven
							unit:FindFirstChild("Owner").Value:WaitForChild("leaderstats"):WaitForChild("Cash").Value += hit.Parent:GetAttribute("Value")
						end
						task.wait(0.05)
						hasDamaged = not hasDamaged
					end

					bullet:Destroy()
				end
			end)

			Debris:AddItem(bullet, 5)
			return bullet
		end

		local function fireAtTarget(bullet : BasePart, target : BasePart)
			if not table.find(shouldRun, unit) then
				return
			end
			pcall(function()
				local currentOrientation = bullet.Orientation
				local attachment0 = Instance.new("Attachment", bullet)
				local attachment1 = Instance.new("Attachment", target)
				local alignOrientation = Instance.new("AlignOrientation", bullet)
				alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
				alignOrientation.Attachment0 = attachment0
				local lineForce = Instance.new("LineForce", bullet)
				lineForce.Attachment0 = attachment0
				lineForce.Attachment1 = attachment1
				lineForce.MaxForce = 1000
				lineForce.Magnitude = 250
				
				--local rocketPropulsion = Instance.new("RocketPropulsion", bullet)
				--rocketPropulsion.Target = target
				--rocketPropulsion.MaxTorque = Vector3.new(1000, 1000, 1000)
				--rocketPropulsion.MaxSpeed = 65
				--rocketPropulsion.MaxThrust = 65
				--rocketPropulsion.CartoonFactor = 1
				--rocketPropulsion.TargetRadius = 0.5
				--rocketPropulsion.TurnD = 1000
				--rocketPropulsion.TurnP = 1000
				--rocketPropulsion.ThrustD = 10000
				--rocketPropulsion.ThrustP = 1000

				--rocketPropulsion:Fire()


				--rocketPropulsion.ReachedTarget:Connect(function()
				--	rocketPropulsion:Abort()
				--end)
			end)
		end

		task.spawn(function()
			while task.wait(unit:FindFirstChild("RateOfFire").Value) do
				if not table.find(shouldRun, unit) then
					return
				end
				if GameInfo.Intermission then
					continue
				end
				local target = getTarget()
				if target == nil then
					continue
				end
				local bullet = shoot()
				fireAtTarget(bullet, target)
			end
		end)
	end
	
end