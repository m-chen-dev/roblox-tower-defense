local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local gui = playerGui:WaitForChild("ScreenGui")


return function()
	local targetPart = gui:WaitForChild("ViewportFrame"):WaitForChild("Part")
	local textButton = gui:WaitForChild("TextButton")
	local warningLabel = gui:WaitForChild("Warning")
	
	local mouse = player:GetMouse()
	local spawnPartRemote = ReplicatedStorage.Game.SpawnPart
	local isMoving = false
	local viewPart
	local range = gui:WaitForChild("ViewportFrame"):WaitForChild("Range")
	local viewRange

	local function warning(isPlaying)
		warningLabel.MaxVisibleGraphemes = 0
		warningLabel.Visible = true
		task.spawn(function()
			if not isPlaying then
				isPlaying = not isPlaying
				for i = 1, #warningLabel.Text do
					warningLabel.MaxVisibleGraphemes = i
					task.wait(0.025)
				end
				local tween = TweenService:Create(
					warningLabel,
					TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
					{
						TextTransparency = 1
					}
				)
				tween:Play()
				tween.Completed:Wait()
				warningLabel.Visible = false
				warningLabel.TextTransparency = 0
				isPlaying = not isPlaying
			end

		end)
		return false
	end

	local function castOverlapCheck(part : BasePart, oldColor : Color3) : boolean
		if #workspace:GetPartsInPart(part) == 0 then
			part.Color = oldColor
			return true
		end
		part.Color = Color3.new(1, 0, 0)
		return false
	end

	textButton.MouseButton1Click:Connect(function()
		local mouseConnection
		local isPlaying = false
		local canPlace = true
		if isMoving == false and not viewPart then
			isMoving = true
			viewPart = targetPart:Clone()
			viewRange = range:Clone()
			viewRange.Parent = workspace
			local rune = viewRange:FindFirstChild("Rune") :: BasePart
			TweenService:Create(rune, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Orientation = rune.Orientation + Vector3.new(0, 360, 0) }):Play()
			local oldColor = viewPart.Color
			viewPart.Parent = workspace
			viewPart.CanCollide = false
			viewPart.Transparency = 0.5
			local connection
			connection = RunService.Stepped:Connect(function(elapsedTime, deltaTime)
				if viewPart then
					local origin = viewPart.Position
					local direction = viewPart.CFrame.UpVector * -500
					local rayCastResult = workspace:Raycast(origin, direction)
					if viewPart and rayCastResult.Instance and #rayCastResult.Instance:GetTags() ~= 0 then
						viewPart.Color = Color3.new(1, 0, 0)
					elseif viewPart and rayCastResult.Instance then
						castOverlapCheck(viewPart, oldColor)
					end
					viewPart.Position = Vector3.new( mouse.Hit.Position.X,  viewPart.Size.Y / 2, mouse.Hit.Position.Z)
					viewRange.Position = Vector3.new( viewPart.Position.X, 0.5, viewPart.Position.Z )
					rune.Position = viewRange.Position
				end
				
			end)
			
			mouseConnection = mouse.Button1Down:Connect(function()
				if connection.Connected and viewPart then
					if connection.Connected and viewPart and canPlace then
						local origin = viewPart.Position 
						local direction = viewPart.CFrame.UpVector * -500
						local rayCastResult = workspace:Raycast(origin, direction)

						if rayCastResult.Instance and #rayCastResult.Instance:GetTags() ~= 0 then
							isPlaying = warning(isPlaying)
							return
						elseif viewPart and rayCastResult.Instance then
							canPlace = castOverlapCheck(viewPart, oldColor)
					
						end
						if not canPlace then
							isPlaying = warning(isPlaying)
							return
						end
						local goalPosition = Vector3.new(mouse.Hit.Position.X, viewPart.Size.Y / 2, mouse.Hit.Position.Z)
						local goalSize = viewPart.Size
						local goalRotation = viewPart.Rotation
						local goalTransparency = 0
						local goalMaterial = viewPart.Material
						spawnPartRemote:FireServer(goalPosition, goalSize, goalRotation, goalTransparency, goalMaterial)
						viewPart:Destroy()
						viewPart = nil
						isMoving = false
						viewRange:Destroy()
						viewRange = nil
						mouseConnection:Disconnect()
						connection:Disconnect()
					end
				end
			end)
		elseif viewPart and isMoving == true then
			isMoving = false
			viewPart:Destroy()
			viewPart = nil
			viewRange:Destroy()
			viewRange = nil
			if mouseConnection then
				mouseConnection:Disconnect()
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		local mouseConnection
		local isPlaying = false
		local canPlace = true
		if gpe then
			return
		end
		if input.KeyCode == Enum.KeyCode.X and viewPart and isMoving == true and viewRange then
			isMoving = false
			canPlace = true
			viewPart:Destroy()
			viewRange:Destroy()
			viewPart = nil
			viewRange = nil
			if mouseConnection then
				mouseConnection:Disconnect()
			end
		elseif input.KeyCode == Enum.KeyCode.One and not viewPart and isMoving == false and not viewRange then
			isMoving = true
			viewPart = targetPart:Clone()
			viewRange = range:Clone()
			viewRange.Parent = workspace
			local rune = viewRange:FindFirstChild("Rune") :: BasePart
			TweenService:Create(rune, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Orientation = rune.Orientation + Vector3.new(0, 360, 0) }):Play()

			local oldColor = viewPart.Color
			viewPart.Parent = workspace
			viewPart.CanCollide = false
			viewPart.Transparency = 0.5

			local connection
			connection = RunService.Stepped:Connect(function(elapsedTime, deltaTime)
				
				if viewPart then
					local origin = viewPart.Position
					local direction = viewPart.CFrame.UpVector * -500
					local rayCastResult = workspace:Raycast(origin, direction)
					if viewPart and rayCastResult.Instance and #rayCastResult.Instance:GetTags() ~= 0 then
						viewPart.Color = Color3.new(1, 0, 0)
					elseif viewPart and rayCastResult.Instance then
						castOverlapCheck(viewPart, oldColor)
					end
					viewPart.Position = Vector3.new( mouse.Hit.Position.X,  viewPart.Size.Y / 2, mouse.Hit.Position.Z)
					viewRange.Position = Vector3.new( viewPart.Position.X, 0.5, viewPart.Position.Z )
					rune.Position = viewRange.Position
				end
			end)
			mouseConnection = mouse.Button1Down:Connect(function()
				if connection.Connected and viewPart and canPlace then
					local origin = viewPart.Position 
					local direction = viewPart.CFrame.UpVector * -500
					local rayCastResult = workspace:Raycast(origin, direction)
					
					if rayCastResult.Instance and #rayCastResult.Instance:GetTags() ~= 0 then
						isPlaying = warning(isPlaying)
						return
					elseif viewPart and rayCastResult.Instance then
						canPlace = castOverlapCheck(viewPart, oldColor)
					end
					if not canPlace then
						warning(false)
						return
					end
					local goalPosition = Vector3.new(mouse.Hit.Position.X, viewPart.Size.Y / 2, mouse.Hit.Position.Z)
					local goalSize = viewPart.Size
					local goalRotation = viewPart.Rotation
					local goalTransparency = 0
					local goalMaterial = viewPart.Material
					spawnPartRemote:FireServer(goalPosition, goalSize, goalRotation, goalTransparency, goalMaterial)
					viewPart:Destroy()
					viewPart = nil
					viewRange:Destroy()
					viewRange = nil
					isMoving = false
					mouseConnection:Disconnect()
					connection:Disconnect()
				end
			end)
		end
	end)
end