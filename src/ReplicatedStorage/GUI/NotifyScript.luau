local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

return function()
	local notifyForMax = script.Parent.NotifyForMax
	local notifyForInsufficientFunds = script.Parent.NotifyForInsufficientFunds
	
	
	notifyForMax.OnClientEvent:Connect(function()
		local player = Players.LocalPlayer
		local maxUnitsWarning = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("MaxUnits")
		if maxUnitsWarning.Visible then
			return
		end
		maxUnitsWarning.MaxVisibleGraphemes = 0
		maxUnitsWarning.Visible = true
		for i = 1, #maxUnitsWarning.Text do
			maxUnitsWarning.MaxVisibleGraphemes += 1
			task.wait(0.05)
		end
		task.wait(.25)
		local tween = TweenService:Create(maxUnitsWarning, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {TextTransparency = 1})
		tween:Play()
		tween.Completed:Wait()
		maxUnitsWarning.MaxVisibleGraphemes = 0
		maxUnitsWarning.Visible = false
		maxUnitsWarning.TextTransparency = 0
				
	end)
	
	notifyForInsufficientFunds.OnClientEvent:Connect(function()
		local player = Players.LocalPlayer
		local insufficientFundsWarning = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("InsufficientFunds")
		if insufficientFundsWarning.Text ~= "Insufficient Funds!" then
			insufficientFundsWarning.Text = "Insufficient Funds!"
		end
		if insufficientFundsWarning.Visible then
			return
		end
		insufficientFundsWarning.MaxVisibleGraphemes = 0
		insufficientFundsWarning.Visible = true
		for i = 1, #insufficientFundsWarning.Text do
			insufficientFundsWarning.MaxVisibleGraphemes += 1
			task.wait(0.05)
		end
		task.wait(.25)
		local tween = TweenService:Create(insufficientFundsWarning, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {TextTransparency = 1})
		tween:Play()
		tween.Completed:Wait()
		insufficientFundsWarning.MaxVisibleGraphemes = 0
		insufficientFundsWarning.Visible = false
		insufficientFundsWarning.TextTransparency = 0
	end)
	
end