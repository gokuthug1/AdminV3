-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// CONFIGURATION //--
-- Adjust these values to customize the flight behavior.
local CONFIG = {
	-- The multiplier applied to the character's WalkSpeed to determine flight speed.
	FlySpeedMultiplier = 3,

	-- Keybinds for vertical movement.
	UpKey = Enum.KeyCode.Space,
	DownKey = Enum.KeyCode.LeftShift,

	-- Physics properties for the BodyGyro (controls rotation).
	Gyro = {
		P = 100000,
		MaxTorque = Vector3.new(400000, 400000, 400000)
	},

	-- Physics properties for the BodyVelocity (controls movement).
	Velocity = {
		P = 5000,
		MaxForce = Vector3.new(1, 1, 1) * 40000
	},

	-- Name of the RemoteEvent in ReplicatedStorage used to toggle flight.
	RemoteEventName = "fly"
}

--// LOCAL VARIABLES //--
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- This connection will be managed to prevent leaks on respawn.
local renderSteppedConnection: RBXScriptConnection

-- State variables
local isFlying = false
local movementInput = {
	forward = 0,
	backward = 0,
	left = 0,
	right = 0,
	up = 0,
	down = 0
}

--// INSTANCES //--
-- Create BodyMovers once to be reused.
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = CONFIG.Gyro.P
bodyGyro.MaxTorque = CONFIG.Gyro.MaxTorque
bodyGyro.Name = "FlightGyro"

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.P = CONFIG.Velocity.P
bodyVelocity.MaxForce = CONFIG.Velocity.MaxForce
bodyVelocity.Name = "FlightVelocity"

--// FUNCTIONS //--

--- Toggles the flight state and enables/disables associated physics and humanoid properties.
-- @param character The player's character model.
-- @param enabled boolean - Whether to enable or disable flying.
local function setFlying(character: Model, enabled: boolean)
	isFlying = enabled

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not (humanoid and rootPart) then return end

	if enabled then
		-- Enable Flying
		bodyGyro.Parent = rootPart
		bodyVelocity.Parent = rootPart
		bodyGyro.CFrame = rootPart.CFrame
		bodyVelocity.Velocity = Vector3.new()
		humanoid.PlatformStand = true
	else
		-- Disable Flying
		bodyGyro.Parent = nil
		bodyVelocity.Parent = nil
		humanoid.PlatformStand = false
	end
end

--- The main update loop that runs every frame during flight.
-- It calculates movement direction based on camera and input, then applies it.
local function onRenderStepped(dt: number)
	if not isFlying then return end

	local character = localPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not (humanoid and rootPart and camera) then return end

	-- Calculate horizontal and vertical movement vectors
	local horizontalMove = (movementInput.right - movementInput.left)
	local verticalMove = (movementInput.forward - movementInput.backward)
	local yMove = (movementInput.up - movementInput.down)

	-- Get direction relative to the camera's orientation
	local cameraDirection = camera.CFrame.RightVector * horizontalMove + camera.CFrame.LookVector * verticalMove

	-- Combine horizontal/forward movement with vertical (up/down) movement
	local finalDirection = Vector3.new(cameraDirection.X, yMove, cameraDirection.Z)

	-- Normalize the direction vector only if there is input to avoid NaN errors
	if finalDirection.Magnitude > 0 then
		finalDirection = finalDirection.Unit
	end

	-- Apply forces
	bodyGyro.CFrame = camera.CFrame
	bodyVelocity.Velocity = finalDirection * humanoid.WalkSpeed * CONFIG.FlySpeedMultiplier
end

--- Bound to ContextActionService to handle movement input changes.
local function handleMovement(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject)
	local value = (inputState == Enum.UserInputState.Begin) and 1 or 0

	if movementInput[actionName] ~= nil then
		movementInput[actionName] = value
	end

	return Enum.ContextActionResult.Pass
end


--- Sets up all necessary connections and states for a new character.
-- This function is called once initially and every time the player respawns.
local function onCharacterAdded(character: Model)
	-- Disconnect the old update loop if it exists
	if renderSteppedConnection then
		renderSteppedConnection:Disconnect()
		renderSteppedConnection = nil
	end

	-- Ensure flight is disabled on spawn to prevent weird physics states.
	setFlying(character, false)

	-- Connect the update loop to RunService for the new character.
	renderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
end


--// INITIALIZATION & CONNECTIONS //--

-- Wait for the RemoteEvent to exist before connecting to it.
local flyEvent = ReplicatedStorage:WaitForChild(CONFIG.RemoteEventName)
flyEvent.OnClientEvent:Connect(function(enable: boolean)
	if localPlayer.Character then
		setFlying(localPlayer.Character, enable)
	end
end)

-- The third argument, 'createTouchButton', tells the service to create an on-screen button for mobile devices.
local createTouchButton = true

-- Bind all movement actions
ContextActionService:BindAction("forward", handleMovement, false, Enum.PlayerActions.CharacterForward)
ContextActionService:BindAction("backward", handleMovement, false, Enum.PlayerActions.CharacterBackward)
ContextActionService:BindAction("left", handleMovement, false, Enum.PlayerActions.CharacterLeft)
ContextActionService:BindAction("right", handleMovement, false, Enum.PlayerActions.CharacterRight)
ContextActionService:BindAction("up", handleMovement, createTouchButton, CONFIG.UpKey)
ContextActionService:BindAction("down", handleMovement, createTouchButton, CONFIG.DownKey)

-- (Optional) Customize the mobile button appearance and position
ContextActionService:SetImage("up", "rbxassetid://YOUR_UP_ARROW_IMAGE_ID")
ContextActionService:SetImage("down", "rbxassetid://YOUR_DOWN_ARROW_IMAGE_ID")
ContextActionService:SetPosition("up", UDim2.new(1, -70, 1, -150))
ContextActionService:SetPosition("down", UDim2.new(1, -70, 1, -80))

-- Set up for the initial character if it already exists
if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end

-- Connect the setup function to run every time a new character is added
localPlayer.CharacterAdded:Connect(onCharacterAdded)
