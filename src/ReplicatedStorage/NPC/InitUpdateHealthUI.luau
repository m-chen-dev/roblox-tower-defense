local TweenService = game:GetService("TweenService")

return function(npc : Model)
	local humanoid = npc:FindFirstChild("Humanoid") :: Humanoid
	local head = npc:FindFirstChild("Head") :: BasePart
	local healthGUI = head:FindFirstChild("HealthGUI") :: BillboardGui
	local healthText = healthGUI:FindFirstChild("HealthText") :: TextLabel
	local healthMainFrame = healthGUI:FindFirstChild("HealthBar") :: Frame
	local healthBackgroundFrame = healthGUI:FindFirstChild("HealthBackground") :: Frame
	healthText.Text = "Health: " .. humanoid.MaxHealth .. "/" .. humanoid.MaxHealth
	humanoid.HealthChanged:Connect(function(newHealth)
		healthText.Text = "Health: " .. newHealth .. "/" .. humanoid.MaxHealth
		local frameOffsetX = healthMainFrame.Size.X.Offset
		local frameScaleY = healthMainFrame.Size.Y.Scale
		local frameOffsetY = healthMainFrame.Size.Y.Offset
		local goalSize = UDim2.new(newHealth / humanoid.MaxHealth, frameOffsetX, frameScaleY, frameOffsetY)
		TweenService:Create(healthMainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = goalSize}):Play()
	end)
end