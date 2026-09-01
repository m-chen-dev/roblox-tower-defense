local Players = game:GetService("Players")

return function()
	script.Parent.VisibleRange.OnClientEvent:Connect(function()
		local range = Players.LocalPlayer:FindFirstChild("Range") :: ObjectValue
		range.Value.Transparency = 0
		for i, v in range.Value:FindFirstChild("Rune"):GetChildren() do
			if not v:IsA("Decal") then continue end

			v.Transparency = 0
		end
	end)
end