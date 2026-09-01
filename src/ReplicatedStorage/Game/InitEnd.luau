local ServerScriptService = game:GetService("ServerScriptService")

return function()
	local base = workspace.Base
	
	base:SetAttribute("Health", nil)

	ServerScriptService.Server.Enabled = false

	for i, v in workspace.Enemies:GetChildren() do
		v:Destroy()
	end
	
end