local name = "Humanoid"

-- Clone the robot template once
local roboTemplate = script.Parent:Clone()

-- Function to remove the robot 2.4 seconds after death
local function removeRobot()
	-- Wait for 2.4 seconds before removing the robot
	wait(2.4)

	-- Remove the robot
	if script.Parent then
		script.Parent:Destroy()
	end
end

-- Main loop
while true do
	wait(3)  -- Check interval
	if script.Parent and script.Parent:FindFirstChild("Humanoid") and script.Parent.Humanoid.Health <= 0 then
		removeRobot()
		break  -- Exit the loop after the robot is removed
	end
end