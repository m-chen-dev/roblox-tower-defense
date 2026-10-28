local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(npc : Model, name : string)
	if name and name:lower():match("clone") or name == "clone" then
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		humanoid.Died:Connect(function()
			task.wait(0.35)
			npc:Destroy()
		end)
		return
	end
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	humanoid.Died:Connect(function()
		task.wait(0.35)
		npc:Destroy()
	end)
	npc.Destroying:Connect(function()
		ReplicatedStorage.CurrentEnemies.Value = math.max(0, ReplicatedStorage.CurrentEnemies.Value - 1)
	end)
end