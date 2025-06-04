local camera = game:GetService("Workspace").CurrentCamera
local userInputService = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = game:GetService("Players").LocalPlayer

-- Variables that will be re-initialized upon respawn
local character, hrp, humanoid

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10^6
bodyGyro.P = 10^6

local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(1, 1, 1) * 10^6
bodyVel.P = 10^4

local isFlying = false
local movement = {forward = 0, backward = 0, right = 0, left = 0}

-- Function to update references after respawn
local function updateCharacterReferences()
	character = player.Character or player.CharacterAdded:Wait()
	hrp = character:WaitForChild("HumanoidRootPart")
	humanoid = character:FindFirstChildOfClass("Humanoid")
end

-- Set up the character references initially
updateCharacterReferences()

-- Reconnect the references on respawn
player.CharacterAdded:Connect(function()
	updateCharacterReferences()
	setFlying(false) -- Disable flying when respawning to avoid errors
end)

local function setFlying(flying)
	isFlying = flying
	bodyGyro.Parent = isFlying and hrp or nil
	bodyVel.Parent = isFlying and hrp or nil
	bodyGyro.CFrame = hrp.CFrame
	bodyVel.Velocity = Vector3.new()

	-- Set Humanoid PlatformStand to prevent falling animation
	humanoid.PlatformStand = isFlying
end

local function onUpdate(dt)
	if isFlying then
		local cf = camera.CFrame
		local direction = cf.RightVector * (movement.right - movement.left) + cf.LookVector * (movement.forward - movement.backward)
		if direction:Dot(direction) > 0 then
			direction = direction.Unit
		end
		bodyGyro.CFrame = cf
		bodyVel.Velocity = direction * humanoid.WalkSpeed * 3
	end
end

local function movementBind(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		movement[actionName] = 1
	elseif inputState == Enum.UserInputState.End then
		movement[actionName] = 0
	end
	return Enum.ContextActionResult.Pass
end

-- Listen for FlyEvent to toggle flying
replicatedStorage.Fly.OnClientEvent:Connect(function(enable)
	setFlying(enable) -- Enable or disable flying based on the command
end)

contextActionService:BindAction("forward", movementBind, false, Enum.PlayerActions.CharacterForward)
contextActionService:BindAction("backward", movementBind, false, Enum.PlayerActions.CharacterBackward)
contextActionService:BindAction("left", movementBind, false, Enum.PlayerActions.CharacterLeft)
contextActionService:BindAction("right", movementBind, false, Enum.PlayerActions.CharacterRight)

runService.RenderStepped:Connect(onUpdate)