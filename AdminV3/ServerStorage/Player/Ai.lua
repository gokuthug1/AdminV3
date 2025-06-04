local NPC = game.Workspace["Player"]
local pathfinding_service = game:GetService("PathfindingService")

-- Function to get a random position within a certain range
local function getRandomPosition()
	local xOffset = math.random(-50, 50) -- Adjust the range as needed
	local zOffset = math.random(-50, 50)
	return NPC.HumanoidRootPart.Position + Vector3.new(xOffset, 0, zOffset)
end

while true do
	local randomPosition = getRandomPosition()
	local path = pathfinding_service:CreatePath()

	path:ComputeAsync(NPC.HumanoidRootPart.Position, randomPosition)
	local waypoints = path:GetWaypoints()

	for _, waypoint in pairs(waypoints) do  
		NPC.Humanoid:MoveTo(waypoint.Position)

		while true do
			local distance = (NPC.PrimaryPart.Position - waypoint.Position).Magnitude
			if distance < 5 then
				break -- Move to the next waypoint when close enough
			end
			wait() -- Wait for a short time before checking the distance again
		end
	end

	-- Wait a bit before choosing the next random position
	wait(math.random(2, 5)) -- Random wait time between 2 and 5 seconds
end