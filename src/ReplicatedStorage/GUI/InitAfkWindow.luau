local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local afkWindow = playerGui:WaitForChild("AFK"):WaitForChild("AFKWindow")

local function handleLeaveAFKChamber()
	local leaveButton = afkWindow:WaitForChild("Leave")
	
	leaveButton.MouseButton1Click:Connect(function()
		if player:GetAttribute("AFK") then
			ReplicatedStorage.Game.DisableAFKChamber:FireServer()
			afkWindow:WaitForChild("CashAwarded").Text = "Cash Awarded: 0"
		end
	end)
end

local function handleAFKTextAnimation()
	local text = afkWindow:WaitForChild("AFKText")
	text.MaxVisibleGraphemes = 3
	
	task.spawn(function()
		while task.wait() do
			if player:GetAttribute("AFK") then
				task.wait(0.25)
				for i = 3, #text.Text, 1 do
					text.MaxVisibleGraphemes += 1
					task.wait(0.25)
				end
				task.wait(0.1)
				text.MaxVisibleGraphemes = 3
			end
		end
	end)
end

local function handleAFKTimeUpdate()
	local timer = afkWindow:WaitForChild("AFKTime")

	local afkTime = 0
	local loopThread = nil
	task.spawn(function()
		while task.wait() do
			if player:GetAttribute("AFK") then
				while task.wait(1) do
					if player:GetAttribute("AFK") then
						afkTime += 1
						timer.Text = "You have been AFK for: " .. afkTime .. " seconds"
					else
						afkTime = 0
						timer.Text = "You have been AFK for: " .. afkTime .. " seconds"
					end
				end
			end
		end
	end)
end

local function updateCashEarnedText()
	local notifyForAFKPayout = ReplicatedStorage.GUI.NotifyClientForPayout
	local cashEarned = afkWindow:WaitForChild("CashAwarded")
	
	notifyForAFKPayout.OnClientEvent:Connect(function(cash)
		if player:GetAttribute("AFK") then
			cashEarned.Text = "Cash Awarded: " .. cash
		end
	end)
end

local function updatePayoutNotifierText()
	local notifier = afkWindow:WaitForChild("PayoutNotifier")
	local afkPayout = ReplicatedStorage.Cash.AFKPayout

	task.spawn(function()
		while task.wait() do
			if player:GetAttribute("AFK") then
				for i = 5, 1, -1 do
					notifier.Text = "Next Payout In: " .. i .. " seconds"
					task.wait(1)
				end
				afkPayout:FireServer()
			end
		end
	end)
end

return function()
	handleLeaveAFKChamber()
	handleAFKTextAnimation()
	handleAFKTimeUpdate()
	updateCashEarnedText()
	updatePayoutNotifierText()
end