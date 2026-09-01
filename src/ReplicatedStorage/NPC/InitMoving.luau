local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Path = require(ReplicatedStorage.Game.Path)

local base = workspace.Base

local function tweenPart(humanoid: Humanoid, part: BasePart, goalPart: BasePart,  y : number)
	-- time = distance / speed
	local speed = humanoid.WalkSpeed
	local startPosition = part.Position
	local endPosition = Vector3.new(goalPart.Position.X, y, goalPart.Position.Z)
	local distance = (endPosition - startPosition).Magnitude
	local positionDuration = distance / speed
	local rotationSpeed = 45
	local rotationDuration = distance / rotationSpeed
	local goalCFrame = CFrame.lookAt(startPosition, endPosition)
	goalCFrame = CFrame.new(endPosition) * CFrame.Angles(0, math.atan2(goalCFrame.LookVector.X, goalCFrame.LookVector.Z), 0) * CFrame.Angles(0, math.rad(180), 0)

	local positionInfo = TweenInfo.new(positionDuration, Enum.EasingStyle.Linear)
	local rotationInfo = TweenInfo.new(rotationDuration, Enum.EasingStyle.Linear)
	
	local x, y, z = goalCFrame:ToOrientation()
	local goalOrientation = Vector3.new(math.deg(x), math.deg(y), math.deg(z))
	
	local rotationGoal = {Orientation = goalOrientation}
	local positionGoal = {Position = endPosition}
	
	local rotationTween = TweenService:Create(part, rotationInfo, rotationGoal)
	rotationTween:Play()
	
	local positionTween = TweenService:Create(part, positionInfo, positionGoal)
	positionTween:Play()
	
	return positionTween
	
	 
end


return function(npc : Model, index)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	local path = Path.GetWaypoints()
	local rootPart = npc:FindFirstChild("HumanoidRootPart") :: BasePart
	local neededYPosition = rootPart.Position.Y
	if not rootPart.Anchored then
		rootPart.Anchored = true
	end
	local runAnimation = npc:FindFirstChild("Animator", true):LoadAnimation(npc:FindFirstChild("RunAnim", true)) :: AnimationTrack
	runAnimation:Play()
	
	if index then
		task.spawn(function()
			for i, v in path do
				if i < index then
					continue
				else
					if not humanoid.Health then
						break
					end
					local tween = tweenPart(humanoid, rootPart, v, neededYPosition)
					if not npc:FindFirstChild("MovingToPart") then
						local movingToPart = Instance.new("ObjectValue", npc)
						movingToPart.Name = "MovingToPart"
						movingToPart.Value = v
					else
						local movingToPart = npc:FindFirstChild("MovingToPart") :: ObjectValue
						movingToPart.Name = "MovingToPart"
						movingToPart.Value = v
					end
					tween.Completed:Wait()
					
				end
			end
			if humanoid.Health > 0 then
				base:SetAttribute("Health", base:GetAttribute("Health") - 1)
				npc:Destroy()
			end
		end)
	else
		task.spawn(function()

			for i, v in path do
				local tween = tweenPart(humanoid, rootPart, v, neededYPosition)
				if not humanoid.Health then
					break
				end
				if not npc:FindFirstChild("MovingToPart") then
					local movingToPart = Instance.new("ObjectValue", npc)
					movingToPart.Name = "MovingToPart"
					movingToPart.Value = v
				else
					local movingToPart = npc:FindFirstChild("MovingToPart") :: ObjectValue
					movingToPart.Name = "MovingToPart"
					movingToPart.Value = v
				end
				tween.Completed:Wait()
			end
			if humanoid.Health > 0 then
				base:SetAttribute("Health", base:GetAttribute("Health") - 1)
				npc:Destroy()
			end
		end)
	end
end