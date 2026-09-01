local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local base = workspace.Base 
	
	base.Touched:Connect(function(hit)
		local npc = hit.Parent
		if npc and npc:HasTag("NPC") and not npc:HasTag("Clone") then
			base:SetAttribute("Health", base:GetAttribute("Health") - 1)
			npc:Destroy()
			ReplicatedStorage.CurrentEnemies.Value -= 1
		end
	end)
end