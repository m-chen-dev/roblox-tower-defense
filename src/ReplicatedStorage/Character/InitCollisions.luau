return function(character : Model)
	task.spawn(function()
		for i, v in character:GetChildren() do
			if v:IsA("BasePart") then
				v.CollisionGroup = "Player"
				v:AddTag("Player")
			end
		end
	end)
end