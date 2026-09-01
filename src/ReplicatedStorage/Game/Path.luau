local Path = {}

local pathWaypoints = workspace.Path:GetChildren()
table.sort(pathWaypoints, function(waypoint1 : Part, waypoint2 : Part)
	return tonumber(waypoint1.Name) < tonumber(waypoint2.Name)
end)

function Path.GetWaypoints() : {Part}
	return pathWaypoints
end

return Path