-- Define player ranks
local playerRanks = {
	["gokuthug0"] = "Creator",
	["LJXBOXGMAER"] = "Owner",
	["Iluvfnfppl"] = "Owner",
	["32x977"] = "Owner",
	["banconnnoob"] = "Owner",
	["altdrago250"] = "Owner"
	-- Add more players and their ranks here
}

-- Define command ranks
local commandRanks = {
	["rank"] = "Owner",
	["kill"] = "Mod",
	["unrank"] = "Owner",
	["jump"] = "VIP",
	["speed"] = "VIP",
	["to"] = "Mod",
	["freeze"] = "Mod",
	["unfreeze"] = "Mod",
	["invisible"] = "Mod",
	["visible"] = "Mod",
	["heal"] = "Admin",
	["god"] = "Admin",
	["ungod"] = "Admin",
	["bring"] = "Admin",
	["sit"] = "VIP",
	["sword"] = "VIP",
	["explode"] = "Admin",
	["loopkill"] = "Head admin",
	["unloopkill"] = "Head admin",
	["btools"] = "Admin",
	["fling"] = "Admin",
	["ff"] = "Admin",
	["unff"] = "Admin",
	["hff"] = "Admin",
	["kick"] = "Admin",
	["damage"] = "Admin",
	["clone"] = "Admin",
	["jail"] = "Admin",
	["unjail"] = "Admin",
	["rpg"] = "Admin",
	["rejoin"] = "Player",
	["tptool"] = "Admin",
	["re"] = "Mod",
	["loadmap"] = "Head admin",
	["fly"] = "Admin",
	["unfly"] = "Admin",
	["char"] = "Admin",
	["gear"] = "Admin",
	["talk"] = "Admin",
	["erain"] = "Admin",
	["ls"] = "Admin",
	["light"] = "Admin",
	["gflip"] = "Admin",
	["noclip"] = "Admin",
	["clip"] = "Admin",
	["spike"] = "Admin",
	["ban"] = "Owner",
	["pm"] = "Mod",
	["color"] = "Mod",
	["size"] = "Admin",
	["aura"] = "Admin",
	["tkill"] = "Head admin",
	["gravity"] = "Admin",
	["flip"] = "Admin",
	["rocket"] = "Head admin",
	["kaura"] = "Head admin",
	["cmds"] = "VIP",
	["warp"] = "Creator",
	["rlist"] = "Player",
	["logs"] = "Mod",
	["crl"] = "Player",
	["smoke"] = "VIP",
	["fire"] = "VIP",
	["shutdown"] = "Owner",
	["thin"] = "VIP",
	["fat"] = "VIP",
	["width"] = "VIP",
	["height"] = "VIP",
	["unban"] = "Owner",
	["unfire"] = "VIP",
	["unfat"] = "VIP",
	["unthin"] = "VIP",
	["unwidth"] = "VIP",
	["unheight"] = "VIP",
	["unsmoke"] = "VIP",
	["unaura"] = "Admin",
	["mute"] = "Head admin",
	["unmute"] = "Head admin",
	["chatcolor"] = "Admin",
	["health"] = "Mod",
	["title"] = "Admin",
	["untitle"] = "Admin",
	["spin"] = "Mod",
	["unspin"] = "Mod",
	["float"] = "VIP",
	["flashbang"] = "Admin",
	["npc"] = "Mod",
	["trap"] = "Admin",
	["blackhole"] = "Admin",
	["laydown"] = "Player",
	["unlight"] = "Admin",
	["unspike"] = "Admin",
	["m"] = "Creator",
	["team"] = "Admin",
	["notify"] = "Admin",
	["blind"] = "Admin",
	["unblind"] = "Admin",
	["test"] = "Creator",
}

-- Define rank hierarchy
local rankHierarchy = {
	["Player"] = 1,
	["VIP"] = 2,
	["Mod"] = 3,
	["Admin"] = 4,
	["Head admin"] = 5,
	["Owner"] = 6,
	["Creator"] = 8,
}

-- Ban list
local bannedPlayers = {}

-- Log list
local commandLogs = {}
-- Function to log commands
local function logCommand(player, command)
	table.insert(commandLogs, {
		playerName = player.Name,
		command = command,
		timestamp = os.date("%X") -- Log the current time in HH:MM:SS format
	})
end

-- Define colors
local colorTable = {
	red = Color3.fromRGB(255, 0, 0),
	green = Color3.fromRGB(0, 255, 0),
	blue = Color3.fromRGB(0, 0, 255),
	yellow = Color3.fromRGB(255, 255, 0),
	white = Color3.fromRGB(255, 255, 255),
	black = Color3.fromRGB(0, 0, 0),
	orange = Color3.fromRGB(255, 165, 0),
	purple = Color3.fromRGB(128, 0, 128),
	pink = Color3.fromRGB(255, 192, 203),
	brown = Color3.fromRGB(165, 42, 42),
	cyan = Color3.fromRGB(0, 255, 255),
	magenta = Color3.fromRGB(255, 0, 255),
	gray = Color3.fromRGB(128, 128, 128),
	lgray = Color3.fromRGB(211, 211, 211),
	dgray = Color3.fromRGB(169, 169, 169),
	lblue = Color3.fromRGB(173, 216, 230),
	lgreen = Color3.fromRGB(144, 238, 144),
	lyellow = Color3.fromRGB(255, 255, 224),
	lpink = Color3.fromRGB(255, 182, 193),
	dred = Color3.fromRGB(139, 0, 0),
	dgreen = Color3.fromRGB(0, 100, 0),
	dblue = Color3.fromRGB(0, 0, 139),
	dyellow = Color3.fromRGB(255, 215, 0),
	dpurple = Color3.fromRGB(75, 0, 130),
	dorange = Color3.fromRGB(255, 140, 0),
	dcyan = Color3.fromRGB(0, 139, 139),
	dmagenta = Color3.fromRGB(139, 0, 139),
	dpink = Color3.fromRGB(255, 105, 180),
	gold = Color3.fromRGB(255, 215, 0),
	silver = Color3.fromRGB(192, 192, 192),
	bronze = Color3.fromRGB(205, 127, 50),
	teal = Color3.fromRGB(0, 128, 128),
	indigo = Color3.fromRGB(75, 0, 130),
	violet = Color3.fromRGB(238, 130, 238),
	lavender = Color3.fromRGB(230, 230, 250),
	coral = Color3.fromRGB(255, 127, 80),
	salmon = Color3.fromRGB(250, 128, 114),
	plum = Color3.fromRGB(221, 160, 221),
	olive = Color3.fromRGB(128, 128, 0),
	khaki = Color3.fromRGB(240, 230, 140),
	mint = Color3.fromRGB(189, 252, 201),
	peach = Color3.fromRGB(255, 218, 185),
	chartreuse = Color3.fromRGB(127, 255, 0),
	sienna = Color3.fromRGB(160, 82, 45),
	rose = Color3.fromRGB(255, 0, 127),
	navy = Color3.fromRGB(0, 0, 128),
	taupe = Color3.fromRGB(72, 60, 50),
	periwinkle = Color3.fromRGB(204, 204, 255),
	azure = Color3.fromRGB(0, 127, 255),
	emerald = Color3.fromRGB(80, 200, 120),
	rust = Color3.fromRGB(183, 65, 14),
	mauve = Color3.fromRGB(224, 176, 255),
	apricot = Color3.fromRGB(251, 206, 177),
	amethyst = Color3.fromRGB(153, 102, 204),
	mintcream = Color3.fromRGB(245, 255, 250),
	antiqueWhite = Color3.fromRGB(250, 235, 215),
	beige = Color3.fromRGB(245, 245, 220),
	bisque = Color3.fromRGB(255, 228, 196),
	blanchedAlmond = Color3.fromRGB(255, 235, 205),
	cornflowerBlue = Color3.fromRGB(100, 149, 237),
	darkOliveGreen = Color3.fromRGB(85, 107, 47),
	aliceBlue = Color3.fromRGB(240, 248, 255),
	ivory = Color3.fromRGB(255, 255, 240),
	honeydew = Color3.fromRGB(240, 255, 240),
	lavenderBlush = Color3.fromRGB(255, 240, 245),
	lightCyan = Color3.fromRGB(224, 255, 255),
	lightGoldenrodYellow = Color3.fromRGB(250, 250, 210),
	lightPink = Color3.fromRGB(255, 182, 193),
	lightSalmon = Color3.fromRGB(255, 160, 122),
	lightSkyBlue = Color3.fromRGB(135, 206, 250),
	lightSlateGray = Color3.fromRGB(119, 136, 153),
	lightSteelBlue = Color3.fromRGB(176, 196, 222),
	mediumAquaMarine = Color3.fromRGB(102, 205, 170),
	mediumBlue = Color3.fromRGB(0, 0, 205),
	mediumOrchid = Color3.fromRGB(186, 85, 211),
	mediumPurple = Color3.fromRGB(147, 112, 219),
	mediumSeaGreen = Color3.fromRGB(60, 179, 113),
	mediumSlateBlue = Color3.fromRGB(123, 104, 238),
	mediumSpringGreen = Color3.fromRGB(0, 250, 154),
	mediumTurquoise = Color3.fromRGB(72, 209, 204),
	mediumVioletRed = Color3.fromRGB(199, 21, 133),
	midnightBlue = Color3.fromRGB(25, 25, 112),
	moccasin = Color3.fromRGB(255, 228, 181),
	oldLace = Color3.fromRGB(253, 245, 230),
	paleGoldenrod = Color3.fromRGB(252, 253, 150),
	paleGreen = Color3.fromRGB(152, 251, 152),
	paleTurquoise = Color3.fromRGB(175, 238, 238),
	paleVioletRed = Color3.fromRGB(219, 112, 147),
	papayaWhip = Color3.fromRGB(255, 239, 213),
	peachPuff = Color3.fromRGB(255, 218, 185),
	seashell = Color3.fromRGB(255, 245, 238),
	skyBlue = Color3.fromRGB(135, 206, 235),
	slateBlue = Color3.fromRGB(106, 90, 205),
	slateGray = Color3.fromRGB(112, 128, 144),
	snow = Color3.fromRGB(255, 250, 250),
	springGreen = Color3.fromRGB(0, 255, 127),
	steelBlue = Color3.fromRGB(70, 130, 180),
	tan = Color3.fromRGB(210, 180, 140),
	thistle = Color3.fromRGB(216, 191, 216),
	tomato = Color3.fromRGB(255, 99, 71),
	transparent = Color3.fromRGB(0, 0, 0), -- Fully transparent
	wheat = Color3.fromRGB(245, 222, 179),
	yellowGreen = Color3.fromRGB(154, 205, 50),
	chart = Color3.fromRGB(127, 255, 0),
	dodgerBlue = Color3.fromRGB(30, 144, 255),
	firebrick = Color3.fromRGB(178, 34, 34),
	fg = Color3.fromRGB(34, 139, 34),
	gb = Color3.fromRGB(220, 220, 220),
	hotPink = Color3.fromRGB(255, 105, 180),
	lgrd = Color3.fromRGB(250, 250, 210),
	lsg = Color3.fromRGB(32, 178, 170),
	msb = Color3.fromRGB(123, 104, 238),
	pg = Color3.fromRGB(252, 253, 150),
	sal = Color3.fromRGB(250, 128, 114),
	dt = Color3.fromRGB(0, 206, 209),
	darkViolet = Color3.fromRGB(148, 0, 211),
	deepPink = Color3.fromRGB(255, 20, 147),
	deepSkyBlue = Color3.fromRGB(0, 191, 255),
	dimGray = Color3.fromRGB(105, 105, 105),
	doBlue = Color3.fromRGB(30, 144, 255),
	darkOrange = Color3.fromRGB(255, 140, 0),
	darkRed = Color3.fromRGB(139, 0, 0),
	darkSeaGreen = Color3.fromRGB(143, 188, 143),
	darkSlateBlue = Color3.fromRGB(72, 61, 139),
	darkSlateGray = Color3.fromRGB(47, 79, 79),
	dv = Color3.fromRGB(148, 0, 211),
	dsb = Color3.fromRGB(0, 191, 255),
	digray= Color3.fromRGB(105, 105, 105),
	dodgerblue = Color3.fromRGB(30, 144, 255),
}

-- Define command functions
local commands = {}

-- Function to get the rank of a player
local function getRank(player)
	return playerRanks[player.Name] or "Player" -- Default to "Player" if no rank assigned
end

-- Function to compare ranks
local function canExecute(playerRank, requiredRank)
	local playerRankIndex = rankHierarchy[playerRank]
	local requiredRankIndex = rankHierarchy[requiredRank]
	return playerRankIndex and requiredRankIndex and playerRankIndex >= requiredRankIndex
end

-- Function to check if the player is an admin (for command execution)
local function isAdmin(player)
	return rankHierarchy[getRank(player)] >= rankHierarchy["Player"]
end

-- Function to get players by name or keyword
local function getPlayerByName(name, executingPlayer)
	if not name or name == "" then
		return {executingPlayer}
	elseif name == "me" then
		return {executingPlayer}
	elseif name == "all" then
		return game.Players:GetPlayers()
	elseif name == "others" then
		local others = {}
		for _, player in ipairs(game.Players:GetPlayers()) do
			if player ~= executingPlayer then
				table.insert(others, player)
			end
		end
		return others
	elseif name == "random" then
		local players = game.Players:GetPlayers()
		if #players > 0 then
			return {players[math.random(#players)]}
		else
			return {}  -- Return an empty table if no players are available
		end
	else
		for _, player in ipairs(game.Players:GetPlayers()) do
			if player.Name:lower():sub(1, #name) == name:lower() then
				return {player}
			end
		end
	end
	return {}
end

-- Rank command
commands["rank"] = function(executingPlayer, targetPlayer, newRank)
	if targetPlayer and newRank and rankHierarchy[newRank] and playerRanks[targetPlayer.Name] ~= "Creator" then
		playerRanks[targetPlayer.Name] = newRank
	end
end

-- Unrank command
commands["unrank"] = function(executingPlayer, targetPlayer)
	if targetPlayer and playerRanks[targetPlayer.Name] ~= "Creator" then
		playerRanks[targetPlayer.Name] = "Player"
	end
end

-- Kick command
commands["kick"] = function(player, targetPlayer)
	if targetPlayer and playerRanks[targetPlayer.Name] ~= "Creator" then
		targetPlayer:Kick("")
	end
end

-- Kill command
commands["kill"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end
end

-- Bring command
commands["bring"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and player.Character then
		targetPlayer.Character:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
	end
end

-- Freeze command
commands["freeze"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		for _, part in pairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = true
			end
		end
	end
end

-- Unfreeze command
commands["unfreeze"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		for _, part in pairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = false
			end
		end
	end
end

-- To command
commands["to"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and player.Character then
		player.Character:SetPrimaryPartCFrame(targetPlayer.Character.PrimaryPart.CFrame)
	end
end

-- Speed command
commands["speed"] = function(player, targetPlayer, speedValue)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local speed = tonumber(speedValue)
			if speed then
				humanoid.WalkSpeed = speed
			end
		end
	end
end

-- Invisible command
commands["invisible"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local character = targetPlayer.Character
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Transparency = 1
				if part.Name == "HumanoidRootPart" then
					part.CanCollide = false
				end
			elseif part:IsA("Decal") or part:IsA("ParticleEmitter") or part:IsA("Trail") then
				part.Transparency = 1
			end
		end
	end
end

-- Visible command
commands["visible"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local character = targetPlayer.Character
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				if part.Name == "HumanoidRootPart" then
					part.Transparency = 1
					part.CanCollide = false
				else
					part.Transparency = 0
				end
			elseif part:IsA("Decal") or part:IsA("ParticleEmitter") or part:IsA("Trail") then
				part.Transparency = 0
			end
		end
	end
end

-- God command
commands["god"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = math.huge
			humanoid.Health = humanoid.MaxHealth
		end
	end
end

-- Jump command
commands["jump"] = function(player, targetPlayer)
	if targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
			humanoid.Jump = true
		end
	end
end

-- Sit command
commands["sit"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		humanoid.Sit = true
	end
end

-- Ungod command
commands["ungod"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		humanoid.MaxHealth = 100
		humanoid.Health = humanoid.MaxHealth
		humanoid:SetAttribute("Invincible", false)

		if humanoid:FindFirstChild("TouchedConnection") then
			humanoid.Touched:Connect(function() end)
		end
	end
end

-- Btools command
commands["btools"] = function(player, targetPlayer)
	local toolId = 110758019519622
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		local InsertService = game:GetService("InsertService")
		local btools = InsertService:LoadAsset(toolId):FindFirstChildOfClass("Tool")
		if btools then
			local btoolsClone = btools:Clone()
			btoolsClone.Parent = targetPlayer.Backpack
		end
	end
end

-- Sword command
commands["sword"] = function(player, targetPlayer)
	local toolId = 47433
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		local InsertService = game:GetService("InsertService")
		local sword = InsertService:LoadAsset(toolId):FindFirstChildOfClass("Tool")
		if sword then
			local swordClone = sword:Clone()
			swordClone.Parent = targetPlayer.Backpack
		end
	end
end

-- Forcefield command
commands["ff"] = function(player, targetPlayer)
	if targetPlayer.Character and not targetPlayer.Character:FindFirstChildOfClass("ForceField") then
		local forceField = Instance.new("ForceField")
		forceField.Parent = targetPlayer.Character
	end
end

-- Unforcefield command
commands["unff"] = function(player, targetPlayer)
	if targetPlayer.Character then
		local forceField = targetPlayer.Character:FindFirstChildOfClass("ForceField")
		if forceField then
			forceField:Destroy()
		end
	end
end

-- Explode command
commands["explode"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local humanoidRootPart = targetPlayer.Character.HumanoidRootPart
		local explosion = Instance.new("Explosion")
		explosion.Position = humanoidRootPart.Position
		explosion.BlastRadius = 10
		explosion.BlastPressure = 5000
		explosion.Parent = game.Workspace
		targetPlayer.Character:BreakJoints()
	end
end

-- Fling command
commands["fling"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local humanoidRootPart = targetPlayer.Character.HumanoidRootPart
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(
			math.random(-500, 500),
			math.random(500, 1000),
			math.random(-500, 500)
		)
		bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
		bodyVelocity.Parent = humanoidRootPart
		wait(0.1)
		bodyVelocity:Destroy()
	end
end

-- Loopkill command
commands["loopkill"] = function(player, targetPlayer)
	if targetPlayer:GetAttribute("LoopKillActive") then
		return -- If already loop killing, don't start another coroutine
	end
	targetPlayer:SetAttribute("LoopKillActive", true)

	-- Start a coroutine to loop kill the target player
	coroutine.wrap(function()
		while targetPlayer:GetAttribute("LoopKillActive") do
			if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
				targetPlayer.Character.Humanoid.Health = 0
			end
			wait(0.8) -- Loop every 1 second
		end
	end)()
end

-- Unloopkill command
commands["unloopkill"] = function(player, targetPlayer)
	if targetPlayer:GetAttribute("LoopKillActive") then
		targetPlayer:SetAttribute("LoopKillActive", false) -- Stop the loop kill
	end
end

-- Damage command
commands["damage"] = function(player, targetPlayer, damageAmount)
	local damage = tonumber(damageAmount)
	if not damage or damage <= 0 then
		return
	end

	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
		local humanoid = targetPlayer.Character.Humanoid
		humanoid:TakeDamage(damage)
	end
end

-- Clone command
commands["clone"] = function(player, targetPlayer)
	-- Ensure the target player has a character
	if targetPlayer and targetPlayer.Character then
		-- Function to clone the character
		local function cloneCharacter(character)
			character.Archivable = true
			local clone = character:Clone()
			character.Archivable = false
			return clone
		end

		-- Clone the target player's character
		local charClone = cloneCharacter(targetPlayer.Character)
		charClone.Parent = game.Workspace
		charClone.Name = targetPlayer.Name .. "_Clone"
	end
end

-- Jail command
commands["jail"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local cellSize = Vector3.new(10, 10, 10)
	local cellPosition = targetPlayer.Character.HumanoidRootPart.Position

	local jailFolder = game.Workspace:FindFirstChild("JailFolder")
	if not jailFolder then
		jailFolder = Instance.new("Folder")
		jailFolder.Name = "JailFolder"
		jailFolder.Parent = game.Workspace
	end

	local function createCellPart(size, position, name, color)
		local part = Instance.new("Part")
		part.Size = size
		part.Position = position
		part.Anchored = true
		part.BrickColor = BrickColor.new(color)
		part.Name = name
		part.Parent = jailFolder
		return part
	end

	-- Create the jail cell parts
	createCellPart(Vector3.new(cellSize.X, cellSize.Y, 1), cellPosition + Vector3.new(0, 0, -cellSize.Z / 2 - 0.5), "FrontWall_" .. targetPlayer.Name, "Bright red")
	createCellPart(Vector3.new(cellSize.X, cellSize.Y, 1), cellPosition + Vector3.new(0, 0, cellSize.Z / 2 + 0.5), "BackWall_" .. targetPlayer.Name, "Bright red")
	createCellPart(Vector3.new(1, cellSize.Y, cellSize.Z), cellPosition + Vector3.new(-cellSize.X / 2 - 0.5, 0, 0), "LeftWall_" .. targetPlayer.Name, "Bright red")
	createCellPart(Vector3.new(1, cellSize.Y, cellSize.Z), cellPosition + Vector3.new(cellSize.X / 2 + 0.5, 0, 0), "RightWall_" .. targetPlayer.Name, "Bright red")
	createCellPart(Vector3.new(cellSize.X, 1, cellSize.Z), cellPosition + Vector3.new(0, -cellSize.Y / 2 - 0.5, 0), "Floor_" .. targetPlayer.Name, "Bright red")
	createCellPart(Vector3.new(cellSize.X, 1, cellSize.Z), cellPosition + Vector3.new(0, cellSize.Y / 2 + 0.5, 0), "Ceiling_" .. targetPlayer.Name, "Bright red")

	-- Create a spawn location in the center of the cell
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Position = cellPosition
	spawnLocation.Size = Vector3.new(1, 1, 1)
	spawnLocation.Anchored = true
	spawnLocation.CanCollide = false
	spawnLocation.Transparency = 1
	spawnLocation.Parent = jailFolder
	spawnLocation.Name = "JailSpawn_" .. targetPlayer.Name

	-- Move the target player to the center of the jail cell
	targetPlayer.Character:SetPrimaryPartCFrame(CFrame.new(cellPosition))
end

-- Unjail command
commands["unjail"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character then
		return
	end

	-- Find the JailFolder
	local jailFolder = game.Workspace:FindFirstChild("JailFolder")
	if jailFolder then
		-- Remove all parts related to the jailed player
		for _, part in ipairs(jailFolder:GetChildren()) do
			if part.Name:find(targetPlayer.Name) then
				part:Destroy()
			end
		end

		-- Remove the JailFolder if empty
		if #jailFolder:GetChildren() == 0 then
			jailFolder:Destroy()
		end
	end

	local spawnLocation = game.Workspace:FindFirstChild("SpawnLocation")
	if spawnLocation then
		targetPlayer.Character:SetPrimaryPartCFrame(spawnLocation.CFrame)
	end
end

-- Char command
commands["char"] = function(player, targetPlayer, newUsername)
	local function getHumanoidDescriptionFromUserName(username)
		local success, userId = pcall(function()
			return game.Players:GetUserIdFromNameAsync(username)
		end)
		if success then
			return game.Players:GetHumanoidDescriptionFromUserId(userId)
		else
			return nil
		end
	end

	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid and newUsername then
			local humanoidDescription = getHumanoidDescriptionFromUserName(newUsername)
			if humanoidDescription then
				humanoid:ApplyDescription(humanoidDescription)
			end
		end
	end
end

-- Rejoin commannd
commands["rejoin"] = function(player)
	if player and player:IsA("Player") then
		local success, message = pcall(function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, player)
		end)

		-- Handle the failure case without using warn or print
		if not success then
			-- Optionally, you can log errors elsewhere or use other means to notify if needed
		end
	end
end

-- Talk command
commands["talk"] = function(player, targetPlayer, message)
	if targetPlayer and message then
		-- Ensure the message is a string and not empty
		if type(message) == "string" and message ~= "" then
			-- Use a RemoteEvent to make the player say the message
			local chatService = game:GetService("Chat")
			chatService:Chat(targetPlayer.Character.HumanoidRootPart, message, Enum.ChatColor.White)
		end
	end
end

-- Gear command
commands["gear"] = function(player, targetPlayer, gearId)
	local gearID = tonumber(gearId)
	-- Give gear to each target player
	if targetPlayer then
		pcall(function()
			local gear = game:GetService("InsertService"):LoadAsset(gearID)
			if gear then
				local tool = gear:FindFirstChildOfClass("Tool") or gear:FindFirstChildOfClass("HopperBin")
				if tool then
					tool.Parent = targetPlayer.Backpack
				end
			end
		end)
	end
end

-- RPG command
commands["rpg"] = function(player, targetPlayer)
	local toolId = 47637
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		local InsertService = game:GetService("InsertService")
		local rpg = InsertService:LoadAsset(toolId):FindFirstChildOfClass("Tool")
		if rpg then
			local btoolsClone = rpg:Clone()
			btoolsClone.Parent = targetPlayer.Backpack
		end
	end
end

-- Tptool command
commands["tptool"] = function(player, targetPlayer)
	local toolId = 47637
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		local InsertService = game:GetService("InsertService")
		local tp = InsertService:LoadAsset(toolId):FindFirstChildOfClass("Tool")
		if tp then
			local btoolsClone = tp:Clone()
			btoolsClone.Parent = targetPlayer.Backpack
		end
	end
end

-- Re command
commands["re"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local currentPosition = targetPlayer.Character.HumanoidRootPart.Position

		-- Function to respawn the player
		local function RespawnPlayer(player)
			player:LoadCharacter() -- Load a new character

			-- Wait for the new character to be fully loaded
			local newCharacter = player.Character or player.CharacterAdded:Wait()

			-- Move the new character to the saved position
			newCharacter:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(currentPosition)
		end

		-- Respawn the player and move them back to the saved position
		RespawnPlayer(targetPlayer)
	end
end

-- Ls command
commands["ls"] = function(player, targetPlayer)
	local character = targetPlayer.Character
	if character and character:FindFirstChild("Humanoid") then
		-- Create a lightning strike effect
		local lightning = Instance.new("Part")
		lightning.Size = Vector3.new(0.2, 10, 0.2) -- Thin and tall to simulate lightning
		lightning.Position = character.PrimaryPart.Position + Vector3.new(0, 5, 0) -- Position above the player
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.BrickColor = BrickColor.new("Bright yellow")
		lightning.Material = Enum.Material.Neon
		lightning.Parent = workspace

		-- Create an effect when the lightning strikes
		game.Debris:AddItem(lightning, 0.5) -- Remove the lightning part after 0.5 seconds

		-- Damage the target player
		targetPlayer.Character.Humanoid:TakeDamage(50) -- Deal 50 damage
	end
end

-- Erain command
commands["erain"] = function(player, target, message)
	for i = 1, 10 do
		local barrel = Instance.new("Part")
		barrel.Size = Vector3.new(2, 2, 2)
		barrel.BrickColor = BrickColor.Red()
		barrel.Position = Vector3.new(math.random(-50, 50), 100, math.random(-50, 50))
		barrel.Anchored = false
		barrel.CanCollide = true
		barrel.Parent = game.Workspace

		-- Add explosion effect when it lands
		barrel.Touched:Connect(function(hit)
			if hit and hit.Parent:FindFirstChild("Humanoid") then
				hit.Parent.Humanoid:TakeDamage(50) -- Damage to players
			end
			local explosion = Instance.new("Explosion")
			explosion.Position = barrel.Position
			explosion.BlastRadius = 10
			explosion.BlastPressure = 5000
			explosion.Parent = game.Workspace
			barrel:Destroy() -- Destroy the barrel after it explodes
		end)

		wait(0.5) -- Interval between barrels
	end
end

-- Gflip commannd
commands["gflip"] = function(player, targetPlayer)
	if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		-- Flip the character upside down
		targetPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.pi, 0, 0)

		local bodyForce = Instance.new("BodyVelocity")
		bodyForce.Velocity = Vector3.new(0, 50, 0) -- Adjust strength of upward force
		bodyForce.MaxForce = Vector3.new(0, math.huge, 0)
		bodyForce.Parent = targetPlayer.Character.HumanoidRootPart

		wait(3) -- Duration of flipped gravity
		bodyForce:Destroy()

		-- Reset the character's orientation
		targetPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(-math.pi, 0, 0)
	end
end

-- Noclip command
commands["noclip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		-- Iterate through all parts of the target player's character
		for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false -- Allow the player to pass through walls
			end
		end
	end
end

-- Clip command
commands["clip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		-- Iterate through all parts of the target player's character
		for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true -- Prevent the player from passing through walls
			end
		end
	end
end

-- Heal command
commands["heal"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
		targetPlayer.Character.Humanoid.Health = 100 -- Set the target player's health to 100
	end
end

-- Light command
commands["light"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		-- Remove old light if it exists
		local oldLight = targetPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("PointLight")
		if oldLight then oldLight:Destroy() end

		local light = Instance.new("PointLight")
		light.Parent = targetPlayer.Character.HumanoidRootPart
		light.Range = 10 -- Adjust the range of the light as needed
		light.Brightness = 4 -- Adjust the brightness of the light as needed
	end
end

-- Unlight command
commands["unlight"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local light = targetPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("PointLight")
		if light then
			light:Destroy()
		end
	end
end

-- Fly command
commands["fly"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character then
		return -- Exit if no valid target player is found
	end

	-- Ensure the Fly RemoteEvent exists in ReplicatedStorage
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local flyEvent = replicatedStorage:FindFirstChild("fly")

	if flyEvent then
		-- Fire the remote event to the target player's client to enable flying
		flyEvent:FireClient(targetPlayer, true) -- `true` to enable flying
	end
end

-- Unfly command
commands["unfly"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character then
		return -- Exit if no valid target player is found
	end

	-- Ensure the Fly RemoteEvent exists in ReplicatedStorage
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local flyEvent = replicatedStorage:FindFirstChild("fly")

	if flyEvent then
		-- Fire the remote event to the target player's client to disable flying
		flyEvent:FireClient(targetPlayer, false) -- `false` to disable flying
	end
end
-- Spike command
commands["spike"] = function(player, targetPlayer)
	local workspace = game:GetService("Workspace")
	local debris = game:GetService("Debris")

	-- Function to kill the player
	local function killPlayer(character)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end

	-- Function to create spikes around the player
	local function createSpikesAroundPlayer(targetPlayer)
		local character = targetPlayer.Character
		if not character then return end

		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local numSpikes = 20 -- Number of spikes (increased for airtight effect)
		local radius = 10 -- Distance from the player
		local spikeHeight = 15 -- Height of the spikes

		for i = 1, numSpikes do
			local angle = (i / numSpikes) * math.pi * 2
			local spikePosition = hrp.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)

			-- Create a triangular spike
			local spike = Instance.new("WedgePart")
			spike.Size = Vector3.new(1, spikeHeight, 5) -- Width and height for sharp effect
			spike.Position = Vector3.new(spikePosition.X, hrp.Position.Y, spikePosition.Z) -- Ensure spike base is on the ground level
			spike.Anchored = true
			spike.BrickColor = BrickColor.new("Bright red")
			spike.Material = Enum.Material.Metal
			spike.Name = "Spike"

			-- Rotate the spike to face the player
			spike.CFrame = CFrame.new(spike.Position, hrp.Position) * CFrame.Angles(0, math.rad(90), 0)

			-- Spike Touched Event: Kill the player and destroy spikes
			spike.Touched:Connect(function(hit)
				local character = hit.Parent
				if character and character:FindFirstChildOfClass("Humanoid") then
					killPlayer(character)

					-- Remove all spikes after a short delay to prevent immediate respawning issues
					for _, obj in pairs(workspace:GetChildren()) do
						if obj.Name == "Spike" then
							debris:AddItem(obj, 0) -- Destroy immediately
						end
					end
				end
			end)

			spike.Parent = workspace
		end
	end

	createSpikesAroundPlayer(targetPlayer)
end

-- Unspike Command
commands["unspike"] = function(player, target, message)
	local workspace = game:GetService("Workspace")
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Spike" and obj:IsA("WedgePart") then
			obj:Destroy()
		end
	end
end

-- Hide Forcefield command
commands["hff"] = function(player, targetPlayer)
	if targetPlayer.Character then
		-- Find the ForceField in the target player's character
		local forceField = targetPlayer.Character:FindFirstChildOfClass("ForceField")
		if forceField then
			forceField.Visible = false -- Hide the forcefield
		end
	end
end

-- Ban command
commands["ban"] = function(player, targetPlayer)
	if targetPlayer and playerRanks[targetPlayer.Name] ~= "Creator" then
		bannedPlayers[targetPlayer.Name] = true
		targetPlayer:Kick("You have been banned from this server.")
	end
end

-- Team Command
commands["team"] = function(player, targetPlayer, teamName)
	if not targetPlayer or not teamName or teamName == "" then return end

	local TeamsService = game:GetService("Teams")
	local targetTeam = TeamsService:FindFirstChild(teamName)

	if not targetTeam then
		-- Create the team if it doesn't exist
		targetTeam = Instance.new("Team")
		targetTeam.Name = teamName
		targetTeam.TeamColor = BrickColor.Random()
		targetTeam.Parent = TeamsService
	end

	targetPlayer.Team = targetTeam
	targetPlayer:LoadCharacter() -- Respawn player to apply team changes
end

-- M Command
commands["m"] = function(player, target, messageText)
	if not messageText or messageText == "" then return end

	for _, p in ipairs(game.Players:GetPlayers()) do
		local playerGui = p:FindFirstChild("PlayerGui")
		if playerGui then
			-- Create GUI
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "ServerMessageGui"
			screenGui.ResetOnSpawn = false
			screenGui.Parent = playerGui

			local frame = Instance.new("Frame")
			frame.Parent = screenGui
			frame.Size = UDim2.new(1, 0, 0, 50)
			frame.Position = UDim2.new(0, 0, -0.1, 0) -- Start above screen
			frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			frame.BackgroundTransparency = 0.2
			frame.BorderSizePixel = 0

			local textLabel = Instance.new("TextLabel")
			textLabel.Parent = frame
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Font = Enum.Font.SourceSansBold
			textLabel.Text = messageText
			textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			textLabel.TextSize = 24

			-- Animate
			local TweenService = game:GetService("TweenService")
			local tweenInfoIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tweenIn = TweenService:Create(frame, tweenInfoIn, {Position = UDim2.new(0, 0, 0, 0)})

			-- CHANGED: The last number is the delay, now set to 8 seconds.
			local tweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 8) 
			local tweenOut = TweenService:Create(frame, tweenInfoOut, {Position = UDim2.new(0, 0, -0.1, 0)})

			tweenIn:Play()
			tweenIn.Completed:Connect(function()
				tweenOut:Play()
				tweenOut.Completed:Connect(function()
					screenGui:Destroy()
				end)
			end)
		end
	end
end

-- Check if the player is banned upon joining
game.Players.PlayerAdded:Connect(function(player)
	-- If the player is in the banned list, kick them
	if bannedPlayers[player.Name] then
		player:Kick("You are banned from this server.")
		return
	end

	-- Pm command
	commands["pm"] = function(player, targetPlayer, message)
		-- Check if targetPlayer is valid
		if targetPlayer and targetPlayer.Character then
			-- Create the ScreenGui for the message pop-up
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "PrivateMessageGui"
			screenGui.ResetOnSpawn = false

			-- Create the Frame for the pop-up message
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 300, 0, 120) -- Set size of the pop-up
			frame.Position = UDim2.new(1, -10, 1, -130) -- Position at the bottom right of the screen
			frame.AnchorPoint = Vector2.new(1, 1) -- Anchor to the bottom right corner
			frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
			frame.BorderSizePixel = 0
			frame.Parent = screenGui

			-- Create the TextLabel for the sender's name
			local senderLabel = Instance.new("TextLabel")
			senderLabel.Size = UDim2.new(1, -20, 0, 20) -- Size within the frame
			senderLabel.Position = UDim2.new(0, 10, 0, 5) -- Position at the top of the frame
			senderLabel.Text = "Message from: " .. player.Name -- Display sender's name
			senderLabel.TextColor3 = Color3.new(1, 1, 1) -- White text color
			senderLabel.BackgroundTransparency = 1 -- Transparent background
			senderLabel.TextWrapped = true -- Wrap the text if too long
			senderLabel.Font = Enum.Font.SourceSansBold -- Font style
			senderLabel.TextSize = 18 -- Font size
			senderLabel.Parent = frame

			-- Create the TextLabel for the message
			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, -20, 1, -40) -- Size within the frame
			textLabel.Position = UDim2.new(0, 10, 0, 30) -- Add padding below the sender label
			textLabel.Text = message -- Set the message text
			textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text color
			textLabel.BackgroundTransparency = 1 -- Transparent background
			textLabel.TextWrapped = true -- Wrap the text if too long
			textLabel.Font = Enum.Font.SourceSans -- Font style
			textLabel.TextSize = 20 -- Font size
			textLabel.Parent = frame

			-- Create the close button
			local closeButton = Instance.new("TextButton")
			closeButton.Size = UDim2.new(1, -20, 0, 30) -- Button size
			closeButton.Position = UDim2.new(0, 10, 1, -30) -- Position within the frame
			closeButton.Text = "Close" -- Button text
			closeButton.TextColor3 = Color3.new(1, 1, 1) -- White text color
			closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark grey button color
			closeButton.BorderSizePixel = 0
			closeButton.Font = Enum.Font.SourceSansBold -- Font style
			closeButton.TextSize = 18 -- Font size
			closeButton.Parent = frame

			-- Add the functionality to close the pop-up
			closeButton.MouseButton1Click:Connect(function()
				screenGui:Destroy()
			end)

			-- Parent the ScreenGui to the target player's PlayerGui
			screenGui.Parent = targetPlayer:FindFirstChildOfClass("PlayerGui")

			-- Use TweenService to animate the pop-up sliding in
			local TweenService = game:GetService("TweenService")
			local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local goalPosition = UDim2.new(1, -10, 1, -130) -- Final position at the bottom-right corner

			local tween = TweenService:Create(frame, tweenInfo, {Position = goalPosition})
			tween:Play()

			-- Optionally, hide the pop-up after a delay
			delay(10, function()
				if screenGui.Parent then
					screenGui:Destroy()
				end
			end)
		end
	end

	-- Color command
	commands["color"] = function(player, targetPlayer, colorName)
		-- Get the Color3 value from the color table
		local color = colorTable[colorName:lower()]

		-- Check if the color is valid
		if color then
			-- Apply color to the player's character parts
			local character = targetPlayer.Character
			if character then
				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") then
						part.BrickColor = BrickColor.new(color)
					end
				end
			end
		end
	end

	-- Size command
	commands["size"] = function(player, targetPlayer, sizeFactor)
		-- Convert the sizeFactor to a number
		local size = tonumber(sizeFactor)

		-- Check if the sizeFactor is a valid number
		if size then
			-- Ensure the size is within a reasonable range
			if size <= 0 then
				return
			end

			-- Get the target player's character and humanoid
			local character = targetPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				-- Find the scaling properties
				local BDS = humanoid:FindFirstChild('BodyDepthScale')
				local BWS = humanoid:FindFirstChild('BodyWidthScale')
				local BHS = humanoid:FindFirstChild('BodyHeightScale')
				local HS = humanoid:FindFirstChild('HeadScale')

				-- Debug information
				if BDS and BWS and BHS and HS then
					-- Set the size directly
					BDS.Value = size
					BWS.Value = size
					BHS.Value = size
					HS.Value = size
				end
			end
		end
	end

	-- Aura command
	commands["aura"] = function(player, targetPlayer, colorName)
		-- Function to get the color from the color table
		local function getColor(name)
			return colorTable[name:lower()] or colorTable["white"]  -- Default to white if color not found
		end

		-- Ensure the target player has a character
		if targetPlayer and targetPlayer.Character then
			local character = targetPlayer.Character

			-- Remove any existing highlights
			for _, obj in ipairs(character:GetChildren()) do
				if obj:IsA("Highlight") then
					obj:Destroy()
				end
			end

			-- Create and configure the highlight
			local highlight = Instance.new("Highlight")
			highlight.Name = "AuraHighlight"
			highlight.Adornee = character
			highlight.FillColor = getColor(colorName)
			highlight.OutlineColor = getColor(colorName)
			highlight.OutlineTransparency = 0
			highlight.FillTransparency = 0.5
			highlight.Parent = character
		end
	end

	-- Tkill command
	commands["tkill"] = function(player, targetPlayer, timeInSeconds)
		-- Ensure targetPlayer is valid and has a character
		if targetPlayer and targetPlayer.Character then
			-- Convert the input time to a number
			local delayTime = tonumber(timeInSeconds)

			if delayTime and delayTime > 0 then
				-- Start a delayed function to kill the target player
				delay(delayTime, function()
					-- Check if targetPlayer and its character are still valid
					if targetPlayer and targetPlayer.Character then
						local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid.Health = 0 -- Kill the player
						end
					end
				end)
			end
		end
	end

	-- Rocket command
	commands["rocket"] = function(player, targetPlayer)
		local heightThreshold = 100  -- Customizable height threshold for explosion

		if targetPlayer and targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			local primaryPart = targetPlayer.Character.PrimaryPart

			if humanoid and primaryPart then
				humanoid:ChangeState(Enum.HumanoidStateType.Physics)  -- Set state to Physics to allow custom forces
				local bodyVelocity = Instance.new("BodyVelocity")
				bodyVelocity.Velocity = Vector3.new(0, 100, 0)  -- Launch upward
				bodyVelocity.MaxForce = Vector3.new(0, 5000, 0)  -- Apply force only in the Y direction
				bodyVelocity.Parent = primaryPart

				local function checkHeight()
					while primaryPart.Position.Y < heightThreshold do
						wait(0.1)  -- Check every 0.1 seconds
					end

					-- Trigger explosion
					local explosion = Instance.new("Explosion")
					explosion.Position = primaryPart.Position
					explosion.BlastRadius = 10
					explosion.BlastPressure = 5000
					explosion.Parent = workspace

					-- Clean up
					bodyVelocity:Destroy()
				end

				-- Start checking height in a separate thread
				coroutine.wrap(checkHeight)()
			end
		end
	end

	-- Gravity command
	commands["gravity"] = function(player, targetPlayer, gravity)
		if targetPlayer and targetPlayer.Character then
			local gravityValue = tonumber(gravity) or 196.2
			game.Workspace.Gravity = gravityValue
		end
	end

	-- Kaura command
	commands["kaura"] = function(player, targetPlayer)
		-- Function to create a kill aura sphere
		local function createAura(character)
			local primaryPart = character.PrimaryPart
			local aura = Instance.new("Part")
			aura.Size = Vector3.new(10, 10, 10)  -- Size of the aura
			aura.Anchored = true
			aura.CanCollide = false
			aura.BrickColor = BrickColor.new("Bright red")  -- Distinct color for visibility
			aura.Material = Enum.Material.SmoothPlastic  -- Smooth surface
			aura.Transparency = 0.5
			aura.Position = primaryPart.Position
			aura.Parent = game.Workspace
			aura.Name = "Kill Aura"
			aura.Locked = true

			-- Create a BodyGyro to keep the aura at the player's position
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.Parent = aura
			bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
			bodyGyro.CFrame = primaryPart.CFrame

			-- Create a touch detection function
			local function onTouch(otherPart)
				local parent = otherPart.Parent
				local humanoid = parent and parent:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid.Parent ~= character then
					humanoid.Health = 0  -- Set health to 0 to "kill" the player or NPC
				end
			end

			aura.Touched:Connect(onTouch)

			-- Adjust aura's position to follow the player
			local function followPlayer()
				while aura and aura.Parent and character and character.PrimaryPart do
					aura.Position = character.PrimaryPart.Position
					wait(0.1)
				end
			end

			coroutine.wrap(followPlayer)()
			return aura
		end

		-- Ensure the target player has a character
		local character = player.Character
		if character then
			-- Create the aura
			local aura = createAura(character)

			-- Destroy the aura when the player's character dies
			local function onCharacterRemoving()
				if aura and aura.Parent then
					aura:Destroy()
				end
			end

			player.CharacterRemoving:Connect(onCharacterRemoving)
		end
	end

	-- Flip command
	commands["flip"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer.Character then
			local character = targetPlayer.Character
			local primaryPart = character.PrimaryPart

			if primaryPart then
				primaryPart.CFrame = primaryPart.CFrame * CFrame.Angles(math.pi, 0, 0)
			end
		end
	end

	-- Warp command
	commands["warp"] = function(player, targetPlayer, dimensionName)
		local dimensions = {
			["test"] = CFrame.new(100, 10, 100),
			["ohio"] = CFrame.new(-1000, -1000, -1000)
		}

		local destination = dimensions[dimensionName]
		if targetPlayer and targetPlayer.Character and destination then
			local character = targetPlayer.Character
			local originalPosition = character.PrimaryPart.Position

			-- Create a flashy effect
			local effect = Instance.new("Part")
			effect.Size = Vector3.new(10, 10, 10)
			effect.Position = originalPosition
			effect.BrickColor = BrickColor.new("Bright purple")
			effect.Anchored = true
			effect.CanCollide = false
			effect.Transparency = 0.5
			effect.Material = Enum.Material.Neon
			effect.Name = "WarpEffect"
			effect.Locked = true
			effect.Parent = workspace

			-- Warp and remove effect
			delay(1, function()
				character:SetPrimaryPartCFrame(destination)
				effect:Destroy()
			end)
		end
	end

	-- Loadmap command
	commands["loadmap"] = function(player, target, message)
		-- Check for existing Baseplate and Spawn and remove them if they exist
		local existingBaseplate = workspace:FindFirstChild("Baseplate")
		local existingSpawn = workspace:FindFirstChild("Spawn")

		if existingBaseplate then
			existingBaseplate:Destroy() -- Remove the existing Baseplate
		end

		if existingSpawn then
			existingSpawn:Destroy() -- Remove the existing Spawn
		end

		-- Create a new Baseplate
		local baseplate = Instance.new("Part")
		baseplate.Size = Vector3.new(512, 16, 512) -- Size of the Baseplate
		baseplate.Anchored = true -- Make the Baseplate anchored
		baseplate.Locked = true -- Lock the Baseplate
		baseplate.Position = Vector3.new(0, 0, 0) -- Position at the center of the game
		baseplate.BrickColor = BrickColor.new("Dark stone grey") -- Set base color to Dark stone grey
		baseplate.Name = "Baseplate" -- Name the Baseplate

		-- Set the surface type to Smooth
		baseplate.TopSurface = Enum.SurfaceType.Studs
		baseplate.BottomSurface = Enum.SurfaceType.Studs

		-- Parent the Baseplate to the Workspace
		baseplate.Parent = workspace

		-- Create the Spawn point
		local spawnPoint = Instance.new("SpawnLocation")
		spawnPoint.Size = Vector3.new(5, 1, 5) -- Size of the Spawn point
		spawnPoint.Position = baseplate.Position + Vector3.new(0, 1, 0) -- Centered above the Baseplate
		spawnPoint.Anchored = true -- Make the Spawn point anchored
		spawnPoint.Locked = true -- Lock the Spawn point
		spawnPoint.CanCollide = false -- No collision
		spawnPoint.Transparency = 1 -- Make it invisible
		spawnPoint.Name = "Spawn"
		spawnPoint.Material = Enum.Material.Plastic -- Set material to Plastic

		-- Parent the Spawn point to the Baseplate
		spawnPoint.Parent = baseplate
	end

	-- Ranklist command
	commands["rlist"] = function(player)
		-- Check if the GUI already exists
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui and playerGui:FindFirstChild("RankListGui") then
			return -- If it exists, return and do not create another one
		end

		-- Create the GUI elements
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "RankListGui"

		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local ExitButton = Instance.new("TextButton")
		local TitleBar = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")

		-- Parent to PlayerGui and configure
		ScreenGui.Parent = playerGui
		ScreenGui.ResetOnSpawn = false -- Ensure GUI stays after death
		Frame.Parent = ScreenGui
		Frame.Size = UDim2.new(0, 400, 0, 300)
		Frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centered on screen
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true

		-- Title Bar configuration
		TitleBar.Parent = Frame
		TitleBar.Size = UDim2.new(1, 0, 0, 30)
		TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0, 0, 0, 0)

		TitleLabel.Parent = TitleBar
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.Text = "Player Rank List"
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 20
		TitleLabel.TextStrokeTransparency = 0.8

		-- Exit Button configuration
		ExitButton.Parent = TitleBar
		ExitButton.Size = UDim2.new(0, 50, 0, 30)
		ExitButton.Position = UDim2.new(1, -50, 0, 0)
		ExitButton.Text = "X"
		ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExitButton.BorderSizePixel = 0

		-- ScrollingFrame configuration
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
		ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
		ScrollingFrame.BackgroundTransparency = 0.3
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		-- Populate the rank list
		for _, player in ipairs(game.Players:GetPlayers()) do
			local playerName = player.Name
			local playerRank = getRank(player)

			local RankLabel = Instance.new("TextLabel")
			RankLabel.Parent = ScrollingFrame
			RankLabel.Text = playerName .. " - " .. playerRank
			RankLabel.Size = UDim2.new(1, 0, 0, 30)
			RankLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			RankLabel.BackgroundTransparency = 1
			RankLabel.Font = Enum.Font.SourceSans
			RankLabel.TextSize = 20
		end

		-- Exit button functionality
		ExitButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	-- Logs command
	commands["logs"] = function(player)
		-- Check if the GUI already exists
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui and playerGui:FindFirstChild("LogsGui") then
			return -- If it exists, return and do not create another one
		end

		-- Create the GUI elements
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "LogsGui"

		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local ExitButton = Instance.new("TextButton")
		local TitleBar = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")

		-- Parent to PlayerGui and configure
		ScreenGui.Parent = player:FindFirstChildOfClass("PlayerGui")
		ScreenGui.ResetOnSpawn = false -- Ensure GUI stays after death
		Frame.Parent = ScreenGui
		Frame.Size = UDim2.new(0, 400, 0, 300)
		Frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centered on screen
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true

		-- Title Bar configuration
		TitleBar.Parent = Frame
		TitleBar.Size = UDim2.new(1, 0, 0, 30)
		TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0, 0, 0, 0)

		TitleLabel.Parent = TitleBar
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.Text = "Command Logs"
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 20
		TitleLabel.TextStrokeTransparency = 0.8

		-- Exit Button configuration
		ExitButton.Parent = TitleBar
		ExitButton.Size = UDim2.new(0, 50, 0, 30)
		ExitButton.Position = UDim2.new(1, -50, 0, 0)
		ExitButton.Text = "X"
		ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExitButton.BorderSizePixel = 0

		-- ScrollingFrame configuration
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
		ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
		ScrollingFrame.BackgroundTransparency = 0.3
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #commandLogs * 35) -- Dynamically adjust the canvas size based on the number of logs

		-- UIListLayout configuration
		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		-- Add each log entry to the ScrollingFrame
		for _, log in ipairs(commandLogs) do
			local LogLabel = Instance.new("TextLabel")
			LogLabel.Parent = ScrollingFrame
			LogLabel.Text = "[" .. log.timestamp .. "] " .. log.playerName .. ": " .. log.command
			LogLabel.Size = UDim2.new(1, 0, 0, 30)
			LogLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			LogLabel.BackgroundTransparency = 1
			LogLabel.Font = Enum.Font.SourceSans
			LogLabel.TextSize = 18
			LogLabel.TextWrapped = true
		end

		-- Exit button functionality
		ExitButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	-- Crl command
	commands["crl"] = function(player)
		-- Check if the GUI already exists
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui and playerGui:FindFirstChild("CommandsRankListGui") then
			return -- If it exists, return and do not create another one
		end

		-- Create the GUI elements
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "CommandsRankListGui"

		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local ExitButton = Instance.new("TextButton")
		local TitleBar = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")

		-- Parent to PlayerGui and configure
		ScreenGui.Parent = player:FindFirstChildOfClass("PlayerGui")
		ScreenGui.ResetOnSpawn = false -- Ensure GUI stays after death
		Frame.Parent = ScreenGui
		Frame.Size = UDim2.new(0, 400, 0, 300)
		Frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centered on screen
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true

		-- Title Bar configuration
		TitleBar.Parent = Frame
		TitleBar.Size = UDim2.new(1, 0, 0, 30)
		TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0, 0, 0, 0)

		TitleLabel.Parent = TitleBar
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.Text = "Command Ranks List"
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 20
		TitleLabel.TextStrokeTransparency = 0.8

		-- Exit Button configuration
		ExitButton.Parent = TitleBar
		ExitButton.Size = UDim2.new(0, 50, 0, 30)
		ExitButton.Position = UDim2.new(1, -50, 0, 0)
		ExitButton.Text = "X"
		ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExitButton.BorderSizePixel = 0

		-- ScrollingFrame configuration
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Size = UDim2.new(1, -10, 1, -40)
		ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
		ScrollingFrame.BackgroundTransparency = 0.3
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated after content is added
		ScrollingFrame.ClipsDescendants = true

		-- UIListLayout configuration
		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		-- Add each command entry to the ScrollingFrame
		local numCommands = 0
		for cmd, rank in pairs(commandRanks) do
			local CmdLabel = Instance.new("TextLabel")
			CmdLabel.Parent = ScrollingFrame
			CmdLabel.Text = ";" .. cmd .. " - Requires Rank: " .. rank
			CmdLabel.Size = UDim2.new(1, 0, 0, 30)
			CmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			CmdLabel.BackgroundTransparency = 1
			CmdLabel.Font = Enum.Font.SourceSans
			CmdLabel.TextSize = 18
			CmdLabel.TextWrapped = true

			numCommands = numCommands + 1
		end

		-- Update the canvas size to fit the content
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, numCommands * 35 + 50) -- Adjust height based on number of commands

		-- Exit button functionality
		ExitButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	-- Smoke command
	commands["smoke"] = function(player, targetPlayer)
		local character = targetPlayer.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				-- Create smoke effect
				local smoke = Instance.new("Smoke")
				smoke.Parent = humanoidRootPart
				smoke.Color = Color3.fromRGB(255, 255, 255)  -- color for smoke
				smoke.Opacity = 0.8
				smoke.RiseVelocity = 2
				smoke.Size = 8  -- Adjusted for a more noticeable effect
			end
		end
	end

	-- Fire command
	commands["fire"] = function(player, targetPlayer)
		local character = targetPlayer.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoidRootPart and humanoid then
				-- Create fire effect
				local fire = Instance.new("Fire")
				fire.Parent = humanoidRootPart
				fire.Color = Color3.fromRGB(252, 127, 3)
				fire.Heat = 10
				fire.Size = 8
			end
		end
	end

	-- Shutdown command
	commands["shutdown"] = function(player)
		-- Check if the player issuing the command is an admin
		if not isAdmin(player) then
			-- Notify the player they don't have permission (optional)
			return
		end

		-- Function to display the shutdown message with a fade-in effect
		local function displayShutdownMessage()
			for _, plr in ipairs(game.Players:GetPlayers()) do
				-- Create the GUI
				local ScreenGui = Instance.new("ScreenGui")
				local Frame = Instance.new("Frame")
				local MessageLabel = Instance.new("TextLabel")

				-- Set up the GUI
				ScreenGui.Parent = plr.PlayerGui
				ScreenGui.Name = "ShutdownGui"
				ScreenGui.ResetOnSpawn = false

				Frame.Parent = ScreenGui
				Frame.Size = UDim2.new(1, 0, 1, 0)  -- Ensure it fills the whole screen
				Frame.Position = UDim2.new(0, 0, 0, 0)  -- Position it to cover the screen
				Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BackgroundTransparency = 0.5
				Frame.BorderSizePixel = 0
				Frame.ZIndex = 10

				MessageLabel.Parent = Frame
				MessageLabel.Size = UDim2.new(1, 0, 1, 0)
				MessageLabel.Position = UDim2.new(0, 0, 0, 0)
				MessageLabel.Text = "Shutting Down Server..."
				MessageLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
				MessageLabel.BackgroundTransparency = 1
				MessageLabel.TextScaled = true
				MessageLabel.Font = Enum.Font.SourceSansBold
				MessageLabel.TextSize = 24 -- Adjust text size as needed
				MessageLabel.TextStrokeTransparency = 0.8

				-- Set initial transparency for fade-in effect
				Frame.BackgroundTransparency = 1
				MessageLabel.TextTransparency = 1

				-- Tween for fade-in effect
				local tweenService = game:GetService("TweenService")
				local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In) -- 1 second fade-in
				local tweenFrame = tweenService:Create(Frame, tweenInfo, {BackgroundTransparency = 0.5})
				local tweenText = tweenService:Create(MessageLabel, tweenInfo, {TextTransparency = 0})

				tweenFrame:Play()
				tweenText:Play()
			end
		end

		-- Display the shutdown message
		displayShutdownMessage()

		-- Wait a few seconds to let the players see the message
		wait(4)

		-- Kick all players with the shutdown message
		for _, plr in ipairs(game.Players:GetPlayers()) do
			plr:Kick("Server was shut down by " .. player.Name)
		end
	end

	-- Thin command
	commands["thin"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to scale down the player's character
		local function makeThin(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Scale down the character parts to make it thin
			humanoid.BodyWidthScale.Value = 0.5
			humanoid.BodyDepthScale.Value = 0.5
		end

		-- Apply the thin effect to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		makeThin(targetCharacter)
	end

	-- Fat command
	commands["fat"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to scale up the player's character
		local function makeFat(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Scale up the character parts to make it fat
			humanoid.BodyWidthScale.Value = 1.5
			humanoid.BodyDepthScale.Value = 1.5
		end

		-- Apply the fat effect to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		makeFat(targetCharacter)
	end

	-- Width command
	commands["width"] = function(player, targetPlayer, scaleAmount)
		local scale = tonumber(scaleAmount)
		if not scale or scale <= 0 then
			return -- Invalid scale amount
		end

		if not targetPlayer then return end

		-- Function to scale the player's width
		local function scaleWidth(character, scale)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Scale the width of character parts
			humanoid.BodyWidthScale.Value = scale
		end

		-- Apply the width scaling to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		scaleWidth(targetCharacter, scale)
	end

	-- Height command
	commands["height"] = function(player, targetPlayer, scaleAmount)
		local scale = tonumber(scaleAmount)
		if not scale or scale <= 0 then
			return -- Invalid scale amount
		end

		if not targetPlayer then return end

		-- Function to scale the player's height
		local function scaleHeight(character, scale)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Scale the height of character parts
			humanoid.BodyHeightScale.Value = scale
		end

		-- Apply the height scaling to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		scaleHeight(targetCharacter, scale)
	end

	-- Unban command
	commands["unban"] = function(player)
		local playerGui = player:FindFirstChild("PlayerGui")
		if not playerGui then return end

		-- Check if the GUI already exists
		if playerGui:FindFirstChild("UnbanMenuGui") then
			return -- If it exists, return and do not create another one
		end

		-- Create the GUI elements
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "UnbanMenuGui"

		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local ExitButton = Instance.new("TextButton")
		local TitleBar = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")

		-- Parent to PlayerGui and configure
		ScreenGui.Parent = playerGui
		ScreenGui.ResetOnSpawn = false -- Ensure GUI stays after death
		Frame.Parent = ScreenGui
		Frame.Size = UDim2.new(0, 400, 0, 300)
		Frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centered on screen
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true

		-- Title Bar configuration
		TitleBar.Parent = Frame
		TitleBar.Size = UDim2.new(1, 0, 0, 30)
		TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0, 0, 0, 0)

		TitleLabel.Parent = TitleBar
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.Text = "Unban Player Menu"
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 20
		TitleLabel.TextStrokeTransparency = 0.8

		-- Exit Button configuration
		ExitButton.Parent = TitleBar
		ExitButton.Size = UDim2.new(0, 50, 0, 30)
		ExitButton.Position = UDim2.new(1, -50, 0, 0)
		ExitButton.Text = "X"
		ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExitButton.BorderSizePixel = 0

		-- ScrollingFrame configuration
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
		ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
		ScrollingFrame.BackgroundTransparency = 0.3
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		-- Populate the banned players list
		for playerName, isBanned in pairs(bannedPlayers) do
			if isBanned then
				local BanFrame = Instance.new("Frame")
				BanFrame.Size = UDim2.new(1, 0, 0, 30)
				BanFrame.BackgroundTransparency = 1
				BanFrame.Parent = ScrollingFrame

				local PlayerLabel = Instance.new("TextLabel")
				PlayerLabel.Parent = BanFrame
				PlayerLabel.Text = playerName
				PlayerLabel.Size = UDim2.new(0.7, 0, 1, 0)
				PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				PlayerLabel.BackgroundTransparency = 1
				PlayerLabel.Font = Enum.Font.SourceSans
				PlayerLabel.TextSize = 20

				local UnbanButton = Instance.new("TextButton")
				UnbanButton.Parent = BanFrame
				UnbanButton.Size = UDim2.new(0.3, 0, 2, 0)
				UnbanButton.Position = UDim2.new(0.7, 0, 0, 0)
				UnbanButton.Text = "Unban"
				UnbanButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
				UnbanButton.TextColor3 = Color3.fromRGB(0, 0, 0)
				UnbanButton.Font = Enum.Font.SourceSansBold
				UnbanButton.TextSize = 18
				UnbanButton.BorderSizePixel = 0

				-- Unban Button functionality
				UnbanButton.MouseButton1Click:Connect(function()
					bannedPlayers[playerName] = nil -- Remove from banned list
					BanFrame:Destroy() -- Remove the entry from the GUI
				end)
			end
		end

		-- Exit button functionality
		ExitButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end

	-- Unfire command
	commands["unfire"] = function(player, targetPlayer)
		local character = targetPlayer.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				-- Remove any Fire instances attached to HumanoidRootPart
				for _, child in ipairs(humanoidRootPart:GetChildren()) do
					if child:IsA("Fire") then
						child:Destroy() -- Remove the fire effect
					end
				end
			end
		end
	end

	-- Unfat command
	commands["unfat"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to reset the player's character size
		local function resetFat(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Reset the character's body size to normal
			humanoid.BodyWidthScale.Value = 1
			humanoid.BodyDepthScale.Value = 1
		end

		-- Apply the reset effect to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		resetFat(targetCharacter)
	end

	-- Unwidth command
	commands["unwidth"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to reset the player's width to default
		local function resetWidth(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Reset the width to default
			humanoid.BodyWidthScale.Value = 1
		end

		-- Apply the reset to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		resetWidth(targetCharacter)
	end

	-- Unheight command
	commands["unheight"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to reset the player's height to default
		local function resetHeight(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Reset the height to default
			humanoid.BodyHeightScale.Value = 1
		end

		-- Apply the reset to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		resetHeight(targetCharacter)
	end

	-- Unsmoke command
	commands["unsmoke"] = function(player, targetPlayer)
		local character = targetPlayer.Character
		if character then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				-- Find and remove smoke effect
				local smoke = humanoidRootPart:FindFirstChildOfClass("Smoke")
				if smoke then
					smoke:Destroy()
				end
			end
		end
	end

	-- Unthin command
	commands["unthin"] = function(player, targetPlayer)
		if not targetPlayer then return end

		-- Function to reset the player's character size to default
		local function resetThin(character)
			if not character or not character:IsA("Model") then
				return -- Not a valid character model
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				return -- No humanoid found
			end

			-- Reset the character's body size to normal
			humanoid.BodyWidthScale.Value = 1
			humanoid.BodyDepthScale.Value = 1
		end

		-- Apply the reset effect to the target player's character
		local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
		resetThin(targetCharacter)
	end

	-- Unaura command
	commands["unaura"] = function(player, targetPlayer)
		-- Ensure the target player has a character
		if targetPlayer and targetPlayer.Character then
			local character = targetPlayer.Character

			-- Find and remove the existing "AuraHighlight"
			for _, obj in ipairs(character:GetChildren()) do
				if obj:IsA("Highlight") and obj.Name == "AuraHighlight" then
					obj:Destroy()
				end
			end
		end
	end

	-- Mute command
	commands["mute"] = function(player, targetPlayer)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		-- Ensure these names match exactly with those in ReplicatedStorage
		local muteEvent = ReplicatedStorage:WaitForChild("mute")
		if targetPlayer then
			muteEvent:FireClient(targetPlayer)
		end
	end

	-- Unmute command
	commands["unmute"] = function(executor, targetPlayer)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		-- Ensure these names match exactly with those in ReplicatedStorage
		local unmuteEvent = ReplicatedStorage:WaitForChild("unmute")
		if targetPlayer then
			unmuteEvent:FireClient(targetPlayer)
		end
	end

	-- Chatcolor command
	commands["chatcolor"] = function(player, targetPlayer, colorName)
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local chatColorEvent = ReplicatedStorage:WaitForChild("chatcolor")
		local color = colorTable[colorName:lower()] or Color3.fromRGB(255, 255, 255)

		if targetPlayer then
			chatColorEvent:FireClient(targetPlayer, color)
		end
	end

	-- Health command 
	commands["health"] = function(player, targetPlayer, healthAmount)
		-- Convert health amount to a number
		local healthValue = tonumber(healthAmount)

		-- Check if targetPlayer exists and healthValue is a valid number
		if targetPlayer and healthValue then
			local character = targetPlayer.Character
			if character and character:FindFirstChildOfClass("Humanoid") then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				-- Set the player's max health
				humanoid.MaxHealth = healthValue
				-- Optionally, also set the current health to the new max health
				humanoid.Health = healthValue
			end
		end
	end

	-- Title command
	commands["title"] = function(player, targetPlayer, titleText)
		-- Check if targetPlayer exists and titleText is provided
		if targetPlayer and titleText then
			local character = targetPlayer.Character
			if character then
				-- Check for an existing BillboardGui and remove it if found
				if character:FindFirstChild("TitleGui") then
					character.TitleGui:Destroy()
				end

				-- Create a new BillboardGui
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Name = "TitleGui"
				billboardGui.Parent = character
				billboardGui.Size = UDim2.new(4, 0, 1, 0) -- Size of the title above the head
				billboardGui.Adornee = character:FindFirstChild("Head") -- Attach to the player's head
				billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- Position above the head
				billboardGui.AlwaysOnTop = true

				-- Create the TextLabel for the title
				local textLabel = Instance.new("TextLabel")
				textLabel.Parent = billboardGui
				textLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the entire BillboardGui
				textLabel.BackgroundTransparency = 1 -- Make background transparent
				textLabel.Text = titleText
				textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text color
				textLabel.TextScaled = true -- Scale text to fit
				textLabel.Font = Enum.Font.SourceSansBold -- Choose a font
			end
		end
	end

	-- Untitle command
	commands["untitle"] = function(player, targetPlayer)
		-- Check if the targetPlayer exists
		if targetPlayer then
			local character = targetPlayer.Character
			if character then
				-- Find the existing BillboardGui named "TitleGui" and remove it
				local existingTitle = character:FindFirstChild("TitleGui")
				if existingTitle then
					existingTitle:Destroy()
				end
			end
		end
	end

	-- Spin command
	commands["spin"] = function(player, targetPlayer, speed)
		-- Ensure the target player exists and a valid speed is provided
		if targetPlayer and tonumber(speed) then
			local character = targetPlayer.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
				if humanoidRootPart then
					-- Check if an existing BodyAngularVelocity is present and remove it
					if humanoidRootPart:FindFirstChild("SpinVelocity") then
						humanoidRootPart.SpinVelocity:Destroy()
					end

					-- Create a new BodyAngularVelocity to make the character spin
					local spinVelocity = Instance.new("BodyAngularVelocity")
					spinVelocity.Name = "SpinVelocity"
					spinVelocity.Parent = humanoidRootPart
					spinVelocity.MaxTorque = Vector3.new(0, math.huge, 0) -- Allow unlimited torque around the Y-axis
					spinVelocity.AngularVelocity = Vector3.new(0, tonumber(speed) * 10, 0) -- Increase the spin speed multiplier

					-- Optional: Adjust the density and friction if needed
					humanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0.3, 0.5) -- Lower the density for less resistance
				end
			end
		end
	end

	-- Unspin command
	commands["unspin"] = function(player, targetPlayer)
		-- Check if targetPlayer exists
		if targetPlayer then
			local character = targetPlayer.Character
			if character then
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
				if humanoidRootPart then
					-- Find and remove the BodyAngularVelocity named "SpinVelocity"
					local spinVelocity = humanoidRootPart:FindFirstChild("SpinVelocity")
					if spinVelocity then
						spinVelocity:Destroy()
					end
				end
			end
		end
	end

	-- Float command
	commands["float"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local humanoidRootPart = targetPlayer.Character.HumanoidRootPart

			-- Create a BodyPosition to control levitation
			local bodyPosition = Instance.new("BodyPosition")
			bodyPosition.Parent = humanoidRootPart
			bodyPosition.MaxForce = Vector3.new(0, math.huge, 0) -- Allow movement only on Y-axis
			bodyPosition.Position = humanoidRootPart.Position + Vector3.new(0, 10, 0) -- Float 10 studs above

			-- Levitate for 5 seconds
			wait(8)

			-- Remove the levitation effect
			bodyPosition:Destroy()
		end
	end

	-- Flashbang command
	commands["flashbang"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer:FindFirstChild("PlayerGui") then
			-- Create a ScreenGui to simulate the flashbang effect
			local screenGui = Instance.new("ScreenGui")
			screenGui.Parent = targetPlayer:FindFirstChild("PlayerGui")
			screenGui.Name = "FlashbangGui"
			screenGui.IgnoreGuiInset = true

			-- Create a white frame to simulate the flash
			local flashFrame = Instance.new("Frame")
			flashFrame.Parent = screenGui
			flashFrame.Size = UDim2.new(1, 0, 1, 0) -- Full screen
			flashFrame.BackgroundColor3 = Color3.new(1, 1, 1) -- Pure white
			flashFrame.BackgroundTransparency = 0 -- Full opacity

			-- Fade out the flash over time
			for i = 1, 10 do
				flashFrame.BackgroundTransparency = i / 10
				wait(0.4) -- Adjust to control flash duration
			end

			-- Remove the GUI after the flash
			screenGui:Destroy()
		end
	end

	-- Npc command
	commands["npc"] = function(player, npcName)
		local npcStorage = game:GetService("ServerStorage")
		local npcTemplate = npcStorage:FindFirstChild("Player")

		if npcTemplate then
			local npcClone = npcTemplate:Clone() -- Clone the NPC from ServerStorage
			npcClone.Parent = workspace

			-- Calculate the position 8 studs in front of the player
			local playerPosition = player.Character.PrimaryPart.Position
			local forwardDirection = player.Character.PrimaryPart.CFrame.LookVector
			local spawnPosition = playerPosition + (forwardDirection * 8)

			npcClone:SetPrimaryPartCFrame(CFrame.new(spawnPosition)) -- Move the NPC to the calculated position
		end
	end

	-- Trap command
	commands["trap"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			-- Create a trap (Part) under the player's feet
			local trap = Instance.new("Part")
			trap.Size = Vector3.new(5, 1, 5)
			trap.Anchored = true
			trap.BrickColor = BrickColor.new("Really black")
			trap.Position = targetPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
			trap.Parent = workspace

			-- Freeze the player by setting their WalkSpeed to 0
			local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
			humanoid.WalkSpeed = 0

			-- Set up a listener to check if the player dies
			humanoid.Died:Connect(function()
				-- Once the player dies, remove the trap
				trap:Destroy()
			end)
		end
	end

	-- Blackhole command
	commands["blackhole"] = function(player, targetPlayer)
		local workspace = game:GetService("Workspace")
		local debris = game:GetService("Debris")

		-- Create the black hole part
		local blackHole = Instance.new("Part")
		blackHole.Shape = Enum.PartType.Ball
		blackHole.Size = Vector3.new(5, 5, 5)
		blackHole.BrickColor = BrickColor.new("Really black")
		blackHole.Material = Enum.Material.Neon
		blackHole.Anchored = true
		blackHole.Position = targetPlayer.Character.HumanoidRootPart.Position
		blackHole.Parent = workspace

		-- Function to pull players toward the black hole
		local function pullPlayer(target)
			local bodyPosition = Instance.new("BodyPosition")
			bodyPosition.MaxForce = Vector3.new(1e6, 1e6, 1e6) -- Strong pulling force
			bodyPosition.Position = blackHole.Position
			bodyPosition.Parent = target.Character.HumanoidRootPart

			-- Remove the pulling effect after 8 seconds
			debris:AddItem(bodyPosition, 8)
		end

		-- Pull all players within range
		for _, player in pairs(game.Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local distance = (blackHole.Position - player.Character.HumanoidRootPart.Position).Magnitude
				if distance <= 50 then -- Pull players within 50 studs
					pullPlayer(player)
					-- Damage players
					player.Character:FindFirstChildOfClass("Humanoid"):TakeDamage(40)
				end
			end
		end

		-- Remove the black hole after 8 seconds
		debris:AddItem(blackHole, 8)
	end
	
	-- Notify command
	commands["notify"] = function(player, targetPlayer, message)
		if not targetPlayer or not targetPlayer:FindFirstChild("PlayerGui") or not message or message == "" then
			return
		end

		local playerGui = targetPlayer:FindFirstChild("PlayerGui")
		local notificationGui = Instance.new("ScreenGui")
		notificationGui.Name = "NotificationGui"
		notificationGui.Parent = playerGui
		notificationGui.ResetOnSpawn = false

		local backgroundFrame = Instance.new("Frame")
		backgroundFrame.Name = "BackgroundFrame"
		backgroundFrame.Parent = notificationGui
		backgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		backgroundFrame.BackgroundTransparency = 0.2
		backgroundFrame.BorderSizePixel = 0
		backgroundFrame.Size = UDim2.new(0, 400, 0, 80)
		backgroundFrame.Position = UDim2.new(0.5, -200, -0.2, 0) -- Start off-screen at the top

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "TitleLabel"
		titleLabel.Parent = backgroundFrame
		titleLabel.Size = UDim2.new(1, -10, 0, 30)
		titleLabel.Position = UDim2.new(0, 5, 0, 5)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Font = Enum.Font.SourceSansBold
		titleLabel.Text = "Notification from " .. player.Name
		titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		titleLabel.TextSize = 18
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left

		local messageLabel = Instance.new("TextLabel")
		messageLabel.Name = "MessageLabel"
		messageLabel.Parent = backgroundFrame
		messageLabel.Size = UDim2.new(1, -10, 0, 40)
		messageLabel.Position = UDim2.new(0, 5, 0, 35)
		messageLabel.BackgroundTransparency = 1
		messageLabel.Font = Enum.Font.SourceSans
		messageLabel.Text = message
		messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		messageLabel.TextSize = 16
		messageLabel.TextWrapped = true
		messageLabel.TextXAlignment = Enum.TextXAlignment.Left
		messageLabel.TextYAlignment = Enum.TextYAlignment.Top

		local TweenService = game:GetService("TweenService")
		local tweenInfoIn = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local tweenIn = TweenService:Create(backgroundFrame, tweenInfoIn, {Position = UDim2.new(0.5, -200, 0, 10)})

		local tweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		local tweenOut = TweenService:Create(backgroundFrame, tweenInfoOut, {Position = UDim2.new(0.5, -200, -0.2, 0)})

		tweenIn:Play()
		tweenIn.Completed:Wait()

		wait(5) -- How long the notification stays on screen

		tweenOut:Play()
		tweenOut.Completed:Connect(function()
			notificationGui:Destroy()
		end)
	end

	-- Blind command
	commands["blind"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer:FindFirstChild("PlayerGui") then
			local playerGui = targetPlayer:FindFirstChild("PlayerGui")
			if playerGui:FindFirstChild("BlindGui") then
				playerGui.BlindGui:Destroy()
			end

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "BlindGui"
			screenGui.Parent = playerGui
			screenGui.IgnoreGuiInset = true 

			local blackFrame = Instance.new("Frame")
			blackFrame.Parent = screenGui
			blackFrame.Size = UDim2.new(1, 0, 1, 0)
			blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
			blackFrame.BorderSizePixel = 0
		end
	end

	-- Unblind command
	commands["unblind"] = function(player, targetPlayer)
		if targetPlayer and targetPlayer:FindFirstChild("PlayerGui") then
			local playerGui = targetPlayer:FindFirstChild("PlayerGui")
			local blindGui = playerGui:FindFirstChild("BlindGui")
			if blindGui then
				blindGui:Destroy()
			end
		end
	end

	-- Laydown command
	commands["laydown"] = function(player)
		-- Ensure the player has a character
		if player and player.Character then
			local character = player.Character
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				-- Set the character's position and orientation to simulate laying down
				local torso = character:FindFirstChild("HumanoidRootPart")
				if torso then
					torso.CFrame = torso.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(math.rad(90), 0, 0)
				end

				-- Disable collisions to prevent the character from getting stuck
				humanoid.PlatformStand = true

				-- Function to get the player back up when they jump
				local function onJumpRequest()
					-- Only allow jumping if the player is laying down
					if humanoid.PlatformStand then
						humanoid.PlatformStand = false -- Re-enable movement
						humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- Optional for smooth transition
					end
				end

				-- Detect jump input for PC (spacebar) and mobile
				if player == game.Players.LocalPlayer then
					-- PC: Detect jump with spacebar
					game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
				end

				-- Mobile: Detect jump with the jump button
				humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
					if humanoid.Jump then
						onJumpRequest()
					end
				end)
			end
		end
	end

	-- Cmds command
	commands["cmds"] = function(player)
		-- Check if the GUI already exists
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui and playerGui:FindFirstChild("CommandsGui") then
			return -- If it exists, return and do not create another one
		end

		-- Create the GUI elements
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "CommandsGui" -- Name the GUI to identify it later
		local Frame = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local MinimizeButton = Instance.new("TextButton")
		local ExitButton = Instance.new("TextButton")
		local TitleBar = Instance.new("Frame")
		local TitleLabel = Instance.new("TextLabel")

		-- Parent to PlayerGui and configure
		ScreenGui.Parent = playerGui
		ScreenGui.ResetOnSpawn = false  -- Ensure GUI stays after death
		Frame.Parent = ScreenGui
		Frame.Size = UDim2.new(0, 400, 0, 300)
		Frame.Position = UDim2.new(0.5, -200, 0, 0) -- Centered on screen
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Active = true
		Frame.Draggable = true

		-- Title Bar configuration
		TitleBar.Parent = Frame
		TitleBar.Size = UDim2.new(1, 0, 0, 30)
		TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TitleBar.BorderSizePixel = 0
		TitleBar.Position = UDim2.new(0, 0, 0, 0)

		TitleLabel.Parent = TitleBar
		TitleLabel.Size = UDim2.new(1, 0, 1, 0)
		TitleLabel.Text = "Commands"
		TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 20
		TitleLabel.TextStrokeTransparency = 0.8

		-- Minimize Button configuration
		MinimizeButton.Parent = TitleBar
		MinimizeButton.Size = UDim2.new(0, 50, 0, 30)
		MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
		MinimizeButton.Text = "-"
		MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		MinimizeButton.BorderSizePixel = 0

		-- Exit Button configuration
		ExitButton.Parent = TitleBar
		ExitButton.Size = UDim2.new(0, 50, 0, 30)
		ExitButton.Position = UDim2.new(1, -50, 0, 0)
		ExitButton.Text = "X"
		ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		ExitButton.BorderSizePixel = 0

		-- ScrollingFrame configuration
		ScrollingFrame.Parent = Frame
		ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
		ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
		ScrollingFrame.BackgroundTransparency = 0.3
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 4000)

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		-- List of commands
		local commandsList = {
			";kill - Kills the player.",
			";jump - Makes the player jump.",
			";speed - Sets the player's walk speed.",
			";to - Teleports you to the player.",
			";freeze - Freezes the player's character.",
			";unfreeze - Unfreezes the player's character.",
			";invisible - Makes the player invisible.",
			";visible - Makes the player visible.",
			";heal - Heals the player to full health.",
			";god - Makes the player invincible.",
			";ungod - Removes invincibility from the player.",
			";bring - Brings the player to you.",
			";sit - Makes the player sit.",
			";sword - Gives the player a sword.",
			";explode - Explodes the player.",
			";loopkill - Loop kills a player.",
			";unloopkill - Stops loop killing.",
			";btools - Gives the player btools.",
			";fling - Flings the player.",
			";ff - Spawns a forcefield around the player.",
			";unff - Removes the forcefield around the player.",
			";hff - Hides the forcefield.",
			";kick - Kicks the player from the game.",
			";damage - Makes the player take damage.",
			";clone - Clones the player.",
			";jail - Puts the player in a jail cell.",
			";unjail - Takes the player out of jail.",
			";rpg - Gives the player an RPG.",
			";rejoin - Rejoins the game.",
			";tptool - Gives you a teleport tool.",
			";re - Respawns the player.",
			";loadmap - Loads the default map for this game.",
			";fly - Lets the player fly.",
			";unfly - Stops the player from flying.",
			";char - Changes the player's avatar to a certain user.",
			";gear - Gives the player Roblox gears.",
			";talk - Makes the player chat what you want.",
			";erain - Makes explosive rain.",
			";ls - Summons a lightning strike on the player.",
			";light - Can't see? Use this command for light.",
			";gflip - Flips the player's gravity.",
			";noclip - Allows you to go through walls.",
			";clip - Disables noclip.",
			";rank - Give the player a rank.",
			";unrank - Removes a rank from a player.",
			";spike - Spawns spikes around the player.",
			";ban - Bans the player from the server.",
			";unban - Brings up unban menu to unban players.",
			";pm - Gives the player a private message.",
			";color - Changes the player's color.",
			";size - Changes the player's size.",
			";aura - Highlights the player with a certain color.",
			";unaura - Removes aura from player.",
			";tkill - Kills a player over time.",
			";gravity - Changes the player's gravity.",
			";flip - Flips the player upside down.",
			";rocket - Sends the player into the sky and explodes.",
			";karua - Spawns a kill aura around the player.",
			";rlist - Shows what player has what rank.",
			";logs - Shows what player executed a command.",
			";crl - Shows all commands with what rank u need.",
			";smoke - Spawns smoke around the player.",
			";unsmoke - Removes smoke from player.",
			";fire - Set the player on fire.",
			";unfire - Removes fire from player.",
			";shutdown - Shut down the server.",
			";thin - Makes the player thin.",
			";unthin - Make the player non thin.",
			";fat - Makes the player fat.",
			";unfat - Makes u not fat.",
			";width - Change the player width.",
			";unwidth - Removes width from player.",
			";height - Change the player height.",
			";unheight - Removes height cmd from player.",
			";mute - Prevents the player from chatting.",
			";unmute - Enables chatting.",
			";chatcolor - Changes your chat color.",
			";health - Sets the max health of a player.",
			";title - puts text above the player's head.",
			";untitle - Removes the title above the player head.",
			";spin - Makes the player spin.",
			";unspin - Stops making the player spin.",
			";unlight - Removes the light from a player.",
			";unspike - Removes all spikes from the map.",
			";m - Displays a server-wide message.",
			";team - Team creation menu.",
			";notify - Sends a notification to a player's screen.",
			";blind - Makes the player's screen black.",
			";unblind - Reverses the blind command."
		}

		-- Add each command to the ScrollingFrame
		for _, cmd in pairs(commandsList) do
			local CmdLabel = Instance.new("TextLabel")
			CmdLabel.Parent = ScrollingFrame
			CmdLabel.Text = cmd
			CmdLabel.Size = UDim2.new(1, 0, 0, 30)
			CmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			CmdLabel.BackgroundTransparency = 1
			CmdLabel.Font = Enum.Font.SourceSans
			CmdLabel.TextSize = 20
		end

		-- Minimize/Maximize function
		local isMinimized = false
		local function toggleMinimize()
			if isMinimized then
				Frame.Size = UDim2.new(0, 400, 0, 300)
				ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
				ScrollingFrame.Visible = true
				isMinimized = false
				MinimizeButton.Text = "-"
			else
				Frame.Size = UDim2.new(0, 400, 0, 30)
				ScrollingFrame.Size = UDim2.new(1, 0, 0, 0)
				ScrollingFrame.Visible = false
				isMinimized = true
				MinimizeButton.Text = "+"
			end
		end

		MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

		-- Exit button functionality
		ExitButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)
	end
end)

-- Function to execute a command
local function executeCommand(player, command, targetName, arg1)
	local playerRank = getRank(player)
	local requiredRank = commandRanks[command]

	if canExecute(playerRank, requiredRank) then
		-- Handle global commands that don't need to loop through targets
		if command == "message" or command == "unspike" or command == "erain" or command == "loadmap" then
			if commands[command] then
				-- Reconstruct the full argument since the regex splits it
				local fullArgument = targetName .. (arg1 and #arg1 > 0 and " " .. arg1 or "")
				commands[command](player, nil, fullArgument) -- Pass player, nil for target, and the full argument
			end
			logCommand(player, command) -- Log once
			return -- Exit after executing
		end

		local targets = getPlayerByName(targetName, player)
		if #targets == 0 then return end -- No targets found

		for _, target in ipairs(targets) do
			if commands[command] then
				commands[command](player, target, arg1)
			end
		end
		logCommand(player, command) -- Log once after executing on all targets
	end
end

-- Connect to RemoteEvent for command execution
local executeCommandRemote = game.ReplicatedStorage:WaitForChild("execute")
executeCommandRemote.OnServerEvent:Connect(function(player, message)
	local command, targetName, arg1 = message:match("^;(%w+)%s*(%w*)%s*(.*)")

	if command and commands[command] then
		executeCommand(player, command, targetName, arg1)
	end
end)
