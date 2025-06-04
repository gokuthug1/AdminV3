--[[
    Admin System with Data Persistence
    Make sure API Services are enabled in Game Settings > Security > Enable Studio Access to API Services
]]

-- Services
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatService = game:GetService("Chat") -- Used in 'talk'
local InsertService = game:GetService("InsertService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService") -- Used in 'pm'
-- UserInputService is client-side, remove from server script unless specifically for server-side keybinds (rare)

-- DataStore
local adminSystemDataStore = DataStoreService:GetDataStore("AdminSystemData_V2") -- V2 for new structure

-- Define player ranks (runtime cache, defaults for specific users if no data loaded)
local playerRanks = {
	["gokuthug1"] = "Creator",
	["LJXBOXGMAER"] = "Owner",
	["Iluvfnfppl"] = "Owner",
	["32x977"] = "Owner",
	["banconnnoob"] = "Owner",
	["altdrago250"] = "Owner"
	-- Add more players and their ranks here
}

-- Define command ranks
local commandRanks = {
	["rank"] = "Owner", ["kill"] = "Mod", ["unrank"] = "Owner", ["jump"] = "VIP", ["speed"] = "VIP",
	["to"] = "Mod", ["freeze"] = "Mod", ["unfreeze"] = "Mod", ["invisible"] = "Mod", ["visible"] = "Mod",
	["heal"] = "Admin", ["god"] = "Admin", ["ungod"] = "Admin", ["bring"] = "Admin", ["sit"] = "VIP",
	["sword"] = "VIP", ["explode"] = "Admin", ["loopkill"] = "Head admin", ["unloopkill"] = "Head admin",
	["btools"] = "Admin", ["fling"] = "Admin", ["ff"] = "Admin", ["unff"] = "Admin", ["hff"] = "Admin",
	["kick"] = "Admin", ["damage"] = "Admin", ["clone"] = "Admin", ["jail"] = "Admin", ["unjail"] = "Admin",
	["rpg"] = "Admin", ["rejoin"] = "Player", ["tptool"] = "Admin", ["re"] = "Mod", ["loadmap"] = "Head admin",
	["fly"] = "Admin", ["unfly"] = "Admin", ["char"] = "Admin", ["gear"] = "Admin", ["talk"] = "Admin",
	["erain"] = "Admin", ["ls"] = "Admin", ["light"] = "Admin", ["gflip"] = "Admin", ["noclip"] = "Admin",
	["clip"] = "Admin", ["spike"] = "Admin", ["ban"] = "Owner", ["pm"] = "Mod", ["color"] = "Mod",
	["size"] = "Admin", ["aura"] = "Admin", ["tkill"] = "Head admin", ["gravity"] = "Admin",
	["flip"] = "Admin", ["rocket"] = "Head admin", ["kaura"] = "Head admin", ["cmds"] = "VIP",
	["warp"] = "Owner", -- Changed from Creator in previous user example to Owner as per this script
	["rlist"] = "Player", ["logs"] = "Mod", ["crl"] = "Player", ["smoke"] = "VIP", ["fire"] = "VIP",
	["shutdown"] = "Owner", ["thin"] = "VIP", ["fat"] = "VIP", ["width"] = "VIP", ["height"] = "VIP",
	["unban"] = "Owner", ["unfire"] = "VIP", ["unfat"] = "VIP", ["unthin"] = "VIP", ["unwidth"] = "VIP",
	["unheight"] = "VIP", ["unsmoke"] = "VIP", ["unaura"] = "Admin", ["mute"] = "Head admin",
	["unmute"] = "Head admin", ["chatcolor"] = "Admin", ["health"] = "Mod", ["title"] = "Admin",
	["untitle"] = "Admin", ["spin"] = "Mod", ["unspin"] = "Mod", ["float"] = "VIP",
	["flashbang"] = "Admin", ["npc"] = "Mod", ["trap"] = "Admin", ["blackhole"] = "Admin",
	["laydown"] = "Player",
}

-- Define rank hierarchy
local rankHierarchy = {
	["Player"] = 1, ["VIP"] = 2, ["Mod"] = 3, ["Admin"] = 4,
	["Head admin"] = 5, ["Owner"] = 6, ["Creator"] = 8,
}

-- Ban list (runtime cache)
local bannedPlayers = {} -- Key: Player.Name, Value: true (mainly for GUI compatibility)

-- Log list
local commandLogs = {}

-- Helper function to save player data
local function savePlayerData(player)
	if not player then return end
	local userId = player.UserId
	local dataToSave = {
		Rank = playerRanks[player.Name] or "Player",
		IsBanned = bannedPlayers[player.Name] or false -- Ban status by name for runtime cache consistency
	}

	local success, err = pcall(function()
		adminSystemDataStore:SetAsync(tostring(userId), dataToSave)
	end)

	if not success then
		warn("Failed to save data for " .. player.Name .. " (UserId: " .. userId .. "): " .. err)
		-- else
		-- print("Successfully saved data for " .. player.Name)
	end
end

-- Helper function to load player data
local function loadPlayerData(player)
	local userId = player.UserId
	local savedData

	local success, err = pcall(function()
		savedData = adminSystemDataStore:GetAsync(tostring(userId))
	end)

	if not success then
		warn("Failed to load data for " .. player.Name .. " (UserId: " .. userId .. "): " .. err)
		playerRanks[player.Name] = playerRanks[player.Name] or "Player" -- Use hardcoded default or "Player"
		bannedPlayers[player.Name] = false
		return
	end

	if savedData then
		playerRanks[player.Name] = savedData.Rank or playerRanks[player.Name] or "Player"
		if savedData.IsBanned then
			bannedPlayers[player.Name] = true -- Update runtime cache
			player:Kick("You are banned from this server.")
			return -- Stop further processing for this player if banned
		else
			bannedPlayers[player.Name] = false
		end
		-- print("Loaded data for " .. player.Name .. ": Rank - " .. playerRanks[player.Name] .. ", Banned - " .. tostring(bannedPlayers[player.Name]))
	else
		-- No saved data, check hardcoded defaults or assign "Player"
		playerRanks[player.Name] = playerRanks[player.Name] or "Player"
		bannedPlayers[player.Name] = false
		-- print("No saved data for " .. player.Name .. ". Assigned Rank: " .. playerRanks[player.Name] .. ". Creating initial entry.")
		savePlayerData(player) -- Save initial data for new players
	end
end

-- Function to log commands
local function logCommand(player, commandText)
	table.insert(commandLogs, {
		playerName = player.Name,
		command = commandText,
		timestamp = os.date("%X")
	})
end

-- Define colors (Keep your original table)
local colorTable = {
	red = Color3.fromRGB(255,0,0), green = Color3.fromRGB(0,255,0), blue = Color3.fromRGB(0,0,255), yellow = Color3.fromRGB(255,255,0),
	white = Color3.fromRGB(255,255,255), black = Color3.fromRGB(0,0,0), orange = Color3.fromRGB(255,165,0), purple = Color3.fromRGB(128,0,128),
	pink = Color3.fromRGB(255,192,203), brown = Color3.fromRGB(165,42,42), cyan = Color3.fromRGB(0,255,255), magenta = Color3.fromRGB(255,0,255),
	gray = Color3.fromRGB(128,128,128), lgray = Color3.fromRGB(211,211,211), dgray = Color3.fromRGB(169,169,169), lblue = Color3.fromRGB(173,216,230),
	lgreen = Color3.fromRGB(144,238,144), lyellow = Color3.fromRGB(255,255,224), lpink = Color3.fromRGB(255,182,193), dred = Color3.fromRGB(139,0,0),
	dgreen = Color3.fromRGB(0,100,0), dblue = Color3.fromRGB(0,0,139), dyellow = Color3.fromRGB(255,215,0), dpurple = Color3.fromRGB(75,0,130),
	dorange = Color3.fromRGB(255,140,0), dcyan = Color3.fromRGB(0,139,139), dmagenta = Color3.fromRGB(139,0,139), dpink = Color3.fromRGB(255,105,180),
	gold = Color3.fromRGB(255,215,0), silver = Color3.fromRGB(192,192,192), bronze = Color3.fromRGB(205,127,50), teal = Color3.fromRGB(0,128,128),
	indigo = Color3.fromRGB(75,0,130), violet = Color3.fromRGB(238,130,238), lavender = Color3.fromRGB(230,230,250), coral = Color3.fromRGB(255,127,80),
	salmon = Color3.fromRGB(250,128,114), plum = Color3.fromRGB(221,160,221), olive = Color3.fromRGB(128,128,0), khaki = Color3.fromRGB(240,230,140),
	mint = Color3.fromRGB(189,252,201), peach = Color3.fromRGB(255,218,185), chartreuse = Color3.fromRGB(127,255,0), sienna = Color3.fromRGB(160,82,45),
	rose = Color3.fromRGB(255,0,127), navy = Color3.fromRGB(0,0,128), taupe = Color3.fromRGB(72,60,50), periwinkle = Color3.fromRGB(204,204,255),
	azure = Color3.fromRGB(0,127,255), emerald = Color3.fromRGB(80,200,120), rust = Color3.fromRGB(183,65,14), mauve = Color3.fromRGB(224,176,255),
	apricot = Color3.fromRGB(251,206,177), amethyst = Color3.fromRGB(153,102,204), mintcream = Color3.fromRGB(245,255,250), antiqueWhite = Color3.fromRGB(250,235,215),
	beige = Color3.fromRGB(245,245,220), bisque = Color3.fromRGB(255,228,196), blanchedAlmond = Color3.fromRGB(255,235,205), cornflowerBlue = Color3.fromRGB(100,149,237),
	darkOliveGreen = Color3.fromRGB(85,107,47), aliceBlue = Color3.fromRGB(240,248,255), ivory = Color3.fromRGB(255,255,240), honeydew = Color3.fromRGB(240,255,240),
	lavenderBlush = Color3.fromRGB(255,240,245), lightCyan = Color3.fromRGB(224,255,255), lightGoldenrodYellow = Color3.fromRGB(250,250,210), lightPink = Color3.fromRGB(255,182,193),
	lightSalmon = Color3.fromRGB(255,160,122), lightSkyBlue = Color3.fromRGB(135,206,250), lightSlateGray = Color3.fromRGB(119,136,153), lightSteelBlue = Color3.fromRGB(176,196,222),
	mediumAquaMarine = Color3.fromRGB(102,205,170), mediumBlue = Color3.fromRGB(0,0,205), mediumOrchid = Color3.fromRGB(186,85,211), mediumPurple = Color3.fromRGB(147,112,219),
	mediumSeaGreen = Color3.fromRGB(60,179,113), mediumSlateBlue = Color3.fromRGB(123,104,238), mediumSpringGreen = Color3.fromRGB(0,250,154), mediumTurquoise = Color3.fromRGB(72,209,204),
	mediumVioletRed = Color3.fromRGB(199,21,133), midnightBlue = Color3.fromRGB(25,25,112), moccasin = Color3.fromRGB(255,228,181), oldLace = Color3.fromRGB(253,245,230),
	paleGoldenrod = Color3.fromRGB(252,253,150), paleGreen = Color3.fromRGB(152,251,152), paleTurquoise = Color3.fromRGB(175,238,238), paleVioletRed = Color3.fromRGB(219,112,147),
	papayaWhip = Color3.fromRGB(255,239,213), peachPuff = Color3.fromRGB(255,218,185), seashell = Color3.fromRGB(255,245,238), skyBlue = Color3.fromRGB(135,206,235),
	slateBlue = Color3.fromRGB(106,90,205), slateGray = Color3.fromRGB(112,128,144), snow = Color3.fromRGB(255,250,250), springGreen = Color3.fromRGB(0,255,127),
	steelBlue = Color3.fromRGB(70,130,180), tan = Color3.fromRGB(210,180,140), thistle = Color3.fromRGB(216,191,216), tomato = Color3.fromRGB(255,99,71),
	transparent = Color3.fromRGB(0,0,0), wheat = Color3.fromRGB(245,222,179), yellowGreen = Color3.fromRGB(154,205,50), chart = Color3.fromRGB(127,255,0),
	dodgerBlue = Color3.fromRGB(30,144,255), firebrick = Color3.fromRGB(178,34,34), fg = Color3.fromRGB(34,139,34), gb = Color3.fromRGB(220,220,220),
	hotPink = Color3.fromRGB(255,105,180), lgrd = Color3.fromRGB(250,250,210), lsg = Color3.fromRGB(32,178,170), msb = Color3.fromRGB(123,104,238),
	pg = Color3.fromRGB(252,253,150), sal = Color3.fromRGB(250,128,114), dt = Color3.fromRGB(0,206,209), darkViolet = Color3.fromRGB(148,0,211),
	deepPink = Color3.fromRGB(255,20,147), deepSkyBlue = Color3.fromRGB(0,191,255), dimGray = Color3.fromRGB(105,105,105), doBlue = Color3.fromRGB(30,144,255),
	darkOrange = Color3.fromRGB(255,140,0), darkRed = Color3.fromRGB(139,0,0), darkSeaGreen = Color3.fromRGB(143,188,143), darkSlateBlue = Color3.fromRGB(72,61,139),
	darkSlateGray = Color3.fromRGB(47,79,79), dv = Color3.fromRGB(148,0,211), dsb = Color3.fromRGB(0,191,255), digray= Color3.fromRGB(105,105,105),
	dodgerblue = Color3.fromRGB(30,144,255),
}

-- Define command functions
local commands = {}

-- Function to get the rank of a player
local function getRank(player)
	return playerRanks[player.Name] or "Player" -- Default to "Player" if no rank assigned
end

-- Function to compare ranks
local function canExecute(playerRank, requiredRank)
	local playerRankVal = rankHierarchy[playerRank]
	local requiredRankVal = rankHierarchy[requiredRank]
	return playerRankVal and requiredRankVal and playerRankVal >= requiredRankVal
end

-- Function to get players by name or keyword (no changes needed for DataStore)
local function getPlayerByName(name, executingPlayer)
	if not name or name == "" then
		return {executingPlayer}
	elseif name:lower() == "me" then
		return {executingPlayer}
	elseif name:lower() == "all" then
		return Players:GetPlayers()
	elseif name:lower() == "others" then
		local others = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= executingPlayer then
				table.insert(others, player)
			end
		end
		return others
	elseif name:lower() == "random" then
		local allPlayers = Players:GetPlayers()
		if #allPlayers > 0 then
			return {allPlayers[math.random(#allPlayers)]}
		else
			return {}
		end
	else
		local foundPlayers = {}
		local lowerName = name:lower()
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Name:lower():match("^"..lowerName) then -- Match prefix
				table.insert(foundPlayers, player)
			end
		end
		if #foundPlayers == 0 then -- If no prefix match, try exact match
			local exactMatch = Players:FindFirstChild(name)
			if exactMatch then return {exactMatch} end
		end
		return foundPlayers
	end
end


-- Rank command
commands["rank"] = function(executingPlayer, targetPlayer, newRank)
	if targetPlayer and newRank and rankHierarchy[newRank] then
		if playerRanks[targetPlayer.Name] == "Creator" and getRank(executingPlayer) ~= "Creator" then
			return -- Only Creator can rank a Creator
		end
		playerRanks[targetPlayer.Name] = newRank
		savePlayerData(targetPlayer) -- Save after rank change
	end
end

-- Unrank command
commands["unrank"] = function(executingPlayer, targetPlayer)
	if targetPlayer then
		if playerRanks[targetPlayer.Name] == "Creator" and getRank(executingPlayer) ~= "Creator" then
			return
		end
		playerRanks[targetPlayer.Name] = "Player"
		savePlayerData(targetPlayer) -- Save after unrank
	end
end

-- Ban command
commands["ban"] = function(executingPlayer, targetPlayer)
	if targetPlayer then
		if getRank(targetPlayer) == "Creator" and getRank(executingPlayer) ~= "Creator" then return end
		if rankHierarchy[getRank(targetPlayer)] >= rankHierarchy[getRank(executingPlayer)] and getRank(executingPlayer) ~= "Creator" then return end

		bannedPlayers[targetPlayer.Name] = true
		savePlayerData(targetPlayer) -- Save ban status
		targetPlayer:Kick("You have been banned from this server.")
	end
end

-- Unban command (GUI part)
commands["unban"] = function(player) -- player is the one executing the command
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end

	if playerGui:FindFirstChild("UnbanMenuGui") then
		playerGui.UnbanMenuGui:Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui", playerGui)
	ScreenGui.Name = "UnbanMenuGui"
	ScreenGui.ResetOnSpawn = false
	-- ... (rest of your GUI creation for unban: Frame, TitleBar, TitleLabel, ExitButton, ScrollingFrame, UIListLayout)
	-- Keep your existing GUI creation code here.
	-- The important part is the UnbanButton.MouseButton1Click connection:
	local Frame = Instance.new("Frame")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local ExitButton = Instance.new("TextButton")
	local TitleBar = Instance.new("Frame")
	local TitleLabel = Instance.new("TextLabel")

	Frame.Parent = ScreenGui
	Frame.Size = UDim2.new(0, 400, 0, 300)
	Frame.Position = UDim2.new(0.5, -200, 0.5, -150) 
	Frame.BackgroundTransparency = 0.3
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true

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

	ExitButton.Parent = TitleBar
	ExitButton.Size = UDim2.new(0, 50, 0, 30)
	ExitButton.Position = UDim2.new(1, -50, 0, 0)
	ExitButton.Text = "X"
	ExitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExitButton.BorderSizePixel = 0

	ScrollingFrame.Parent = Frame
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
	ScrollingFrame.BackgroundTransparency = 0.3
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 8

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	local banCount = 0
	for playerNameFromList, isBannedStatus in pairs(bannedPlayers) do -- Iterate runtime cache
		if isBannedStatus then
			banCount = banCount + 1
			local BanFrame = Instance.new("Frame", ScrollingFrame)
			BanFrame.Size = UDim2.new(1, 0, 0, 30)
			BanFrame.BackgroundTransparency = 1

			local PlayerLabel = Instance.new("TextLabel", BanFrame)
			PlayerLabel.Text = playerNameFromList
			PlayerLabel.Size = UDim2.new(0.7, 0, 1, 0)
			PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			PlayerLabel.BackgroundTransparency = 1
			PlayerLabel.Font = Enum.Font.SourceSans
			PlayerLabel.TextSize = 20

			local UnbanButton = Instance.new("TextButton", BanFrame)
			UnbanButton.Size = UDim2.new(0.3, 0, 1, 0) -- Corrected
			UnbanButton.Position = UDim2.new(0.7, 0, 0, 0)
			UnbanButton.Text = "Unban"
			UnbanButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
			UnbanButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			UnbanButton.Font = Enum.Font.SourceSansBold
			UnbanButton.TextSize = 18
			UnbanButton.BorderSizePixel = 0

			UnbanButton.MouseButton1Click:Connect(function()
				bannedPlayers[playerNameFromList] = nil -- Remove from runtime list

				-- Attempt to find player by name to get UserId for DataStore update
				local targetPlayerToUnban = Players:FindFirstChild(playerNameFromList)
				if targetPlayerToUnban then
					savePlayerData(targetPlayerToUnban) -- This will save IsBanned as false
					-- print("Unbanned online player " .. playerNameFromList .. " and updated DataStore.")
				else
					-- Player is offline. We need their UserId to update DataStore.
					-- This requires a Name->UserId mapping or an unban-by-id command.
					-- For now, they are removed from runtime list. If they rejoin,
					-- loadPlayerData will check their (potentially still banned) DataStore state.
					-- To truly unban an offline player by name here, you would need to:
					-- 1. Have previously stored their UserId when they were banned.
					-- 2. Use that UserId to call adminSystemDataStore:UpdateAsync() or SetAsync()
					--    to change IsBanned to false.
					warn("Player " .. playerNameFromList .. " is offline. Removed from runtime ban list. DataStore status unchanged without UserId.")
				end
				BanFrame:Destroy()
				-- Recalculate canvas size
				local currentBans = 0; for _, child in ipairs(ScrollingFrame:GetChildren()) do if child:IsA("Frame") then currentBans = currentBans + 1 end end
				ScrollingFrame.CanvasSize = UDim2.new(0,0,0, currentBans * (30 + UIListLayout.Padding.Offset) )
			end)
		end
	end
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0, banCount * (30 + UIListLayout.Padding.Offset) )

	ExitButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end


-- ... (ALL YOUR OTHER COMMAND FUNCTIONS - OMITTED FOR BREVITY, KEEP THEM AS THEY ARE) ...
-- Example of one:
commands["kick"] = function(player, targetPlayer)
	if targetPlayer then
		if getRank(targetPlayer) == "Creator" and getRank(player) ~= "Creator" then return end
		if rankHierarchy[getRank(targetPlayer)] >= rankHierarchy[getRank(player)] and getRank(player) ~= "Creator" then return end
		targetPlayer:Kick("Kicked by " .. player.Name)
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
	if targetPlayer and targetPlayer.Character and player.Character and player.Character.PrimaryPart then
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
	if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart and player.Character then
		player.Character:SetPrimaryPartCFrame(targetPlayer.Character.PrimaryPart.CFrame)
	end
end
-- Speed command
commands["speed"] = function(player, targetPlayer, speedValue)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local speed = tonumber(speedValue)
			if speed and speed > 0 and speed < 500 then -- Added sanity checks
				humanoid.WalkSpeed = speed
			end
		end
	end
end
-- Invisible command
commands["invisible"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local character = targetPlayer.Character
		for _, descendant in pairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") or descendant:IsA("Decal") then
				descendant.Transparency = 1
			elseif descendant:IsA("Accessory") then
				local handle = descendant:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					handle.Transparency = 1
				end
			end
		end
		if character.PrimaryPart then character.PrimaryPart.CanCollide = false end
	end
end
-- Visible command
commands["visible"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local character = targetPlayer.Character
		local defaultTransparency = {} -- Store original transparencies if needed for complex models

		for _, descendant in pairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") or descendant:IsA("Decal") then
				descendant.Transparency = defaultTransparency[descendant] or 0 -- Restore or set to 0
			elseif descendant:IsA("Accessory") then
				local handle = descendant:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					handle.Transparency = defaultTransparency[handle] or 0
				end
			end
		end
		if character.PrimaryPart then character.PrimaryPart.CanCollide = true end -- Be careful, might not always be true
		if character:FindFirstChild("HumanoidRootPart") then character.HumanoidRootPart.Transparency = 1 end -- HRP usually stays transparent
	end
end
-- God command
commands["god"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
			-- For true god mode, prevent damage events
			targetPlayer:SetAttribute("IsGodMode", true)
			humanoid.HealthChanged:Connect(function(newHealth)
				if targetPlayer:GetAttribute("IsGodMode") and newHealth < humanoid.MaxHealth then
					humanoid.Health = humanoid.MaxHealth
				end
			end)
		end
	end
end
-- Jump command
commands["jump"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then -- Added targetPlayer nil check
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Jump = true -- Setting Jump property is often better
		end
	end
end
-- Sit command
commands["sit"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		humanoid.Sit = true
	end
end
-- Ungod command
commands["ungod"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		humanoid.MaxHealth = 100
		humanoid.Health = 100
		targetPlayer:SetAttribute("IsGodMode", false)
		-- No need to disconnect HealthChanged if checking attribute
	end
end
-- Btools command
commands["btools"] = function(player, targetPlayer)
	local toolIds = {18574012849, 18574014709, 18574016321} -- Delete, Clone, Move tools by F3X
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		for _, toolId in ipairs(toolIds) do
			pcall(function()
				local asset = InsertService:LoadAsset(toolId)
				local tool = asset:FindFirstChildOfClass("Tool")
				if tool then
					tool:Clone().Parent = targetPlayer.Backpack
				end
				asset:Destroy()
			end)
		end
	end
end
-- Sword command
commands["sword"] = function(player, targetPlayer)
	local toolId = 240075373 -- Classic LinkedSword
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		pcall(function()
			local asset = InsertService:LoadAsset(toolId)
			local tool = asset:FindFirstChildOfClass("Tool")
			if tool then
				tool:Clone().Parent = targetPlayer.Backpack
			end
			asset:Destroy()
		end)
	end
end
-- Forcefield command
commands["ff"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and not targetPlayer.Character:FindFirstChildOfClass("ForceField") then
		Instance.new("ForceField", targetPlayer.Character)
	end
end
-- Unforcefield command
commands["unff"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local forceField = targetPlayer.Character:FindFirstChildOfClass("ForceField")
		if forceField then
			forceField:Destroy()
		end
	end
end
-- Explode command
commands["explode"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		local explosion = Instance.new("Explosion")
		explosion.Position = hrp.Position
		explosion.BlastRadius = 15
		explosion.BlastPressure = 500000 -- Higher pressure for more oomph
		explosion.DestroyJointRadiusPercent = 1 -- Ensure joints break
		explosion.Parent = workspace
	end
end
-- Fling command
commands["fling"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(math.random(-150, 150), math.random(200, 350), math.random(-150, 150))
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.P = 5000 -- Make it more responsive
		bodyVelocity.Parent = hrp
		game:GetService("Debris"):AddItem(bodyVelocity, 0.3) -- Short duration
	end
end

-- Loopkill command
local loopKillingPlayers = {}
commands["loopkill"] = function(player, targetPlayer)
	if not targetPlayer then return end
	if loopKillingPlayers[targetPlayer.UserId] then return end -- Already active

	loopKillingPlayers[targetPlayer.UserId] = coroutine.create(function()
		while loopKillingPlayers[targetPlayer.UserId] do -- Check if this coroutine should still run
			if targetPlayer and targetPlayer.Parent and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
				targetPlayer.Character.Humanoid.Health = 0
			else
				loopKillingPlayers[targetPlayer.UserId] = nil -- Target gone, stop loop
				break
			end
			task.wait(0.6)
		end
	end)
	coroutine.resume(loopKillingPlayers[targetPlayer.UserId])
end
-- Unloopkill command
commands["unloopkill"] = function(player, targetPlayer)
	if targetPlayer and loopKillingPlayers[targetPlayer.UserId] then
		-- To stop the coroutine, we can set its tracking variable to nil or false
		-- The loop itself checks this.
		loopKillingPlayers[targetPlayer.UserId] = nil -- Signal loop to stop
	end
end
-- Damage command
commands["damage"] = function(player, targetPlayer, damageAmount)
	local damage = tonumber(damageAmount)
	if not damage or damage <= 0 then return end

	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		targetPlayer.Character.Humanoid:TakeDamage(damage)
	end
end
-- Clone command
commands["clone"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		targetPlayer.Character.Archivable = true -- Ensure it's archivable
		local charClone = targetPlayer.Character:Clone()
		targetPlayer.Character.Archivable = false -- Reset if it wasn't originally
		charClone.Parent = workspace
		charClone.Name = targetPlayer.Name .. "_Clone"
		charClone:MakeJoints() -- Important for cloned characters to not fall apart
		local humanoid = charClone:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.DisplayName = targetPlayer.Name .. " (Clone)" end
	end
end
-- Jail command
commands["jail"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

	local jailFolderName = "Jail_" .. targetPlayer.Name
	if workspace:FindFirstChild(jailFolderName) then workspace[jailFolderName]:Destroy() end -- Clear old jail

	local jailFolder = Instance.new("Model", workspace) -- Use Model for easier grouping
	jailFolder.Name = jailFolderName

	local hrp = targetPlayer.Character.HumanoidRootPart
	local cellSize = Vector3.new(8, 10, 8)
	local cellPosition = hrp.Position - Vector3.new(0, hrp.Size.Y/2 - cellSize.Y/2 + 0.5, 0) -- On the ground

	local wallMaterial = Enum.Material.ForceField
	local wallColor = BrickColor.new("Institutional white")
	local wallTransparency = 0.5

	local function createWall(size, cframe, name)
		local wall = Instance.new("Part", jailFolder)
		wall.Size = size
		wall.CFrame = cframe
		wall.Anchored = true
		wall.BrickColor = wallColor
		wall.Material = wallMaterial
		wall.Transparency = wallTransparency
		wall.Name = name
		wall.CanCollide = true
		return wall
	end
	-- Floor
	createWall(Vector3.new(cellSize.X, 0.5, cellSize.Z), CFrame.new(cellPosition) * CFrame.new(0, -cellSize.Y/2, 0), "Floor")
	-- Ceiling
	createWall(Vector3.new(cellSize.X, 0.5, cellSize.Z), CFrame.new(cellPosition) * CFrame.new(0, cellSize.Y/2, 0), "Ceiling")
	-- Walls
	createWall(Vector3.new(0.5, cellSize.Y, cellSize.Z), CFrame.new(cellPosition) * CFrame.new(-cellSize.X/2, 0, 0), "Wall1")
	createWall(Vector3.new(0.5, cellSize.Y, cellSize.Z), CFrame.new(cellPosition) * CFrame.new(cellSize.X/2, 0, 0), "Wall2")
	createWall(Vector3.new(cellSize.X, cellSize.Y, 0.5), CFrame.new(cellPosition) * CFrame.new(0, 0, -cellSize.Z/2), "Wall3")
	createWall(Vector3.new(cellSize.X, cellSize.Y, 0.5), CFrame.new(cellPosition) * CFrame.new(0, 0, cellSize.Z/2), "Wall4")

	targetPlayer.Character:SetPrimaryPartCFrame(CFrame.new(cellPosition))
end
-- Unjail command
commands["unjail"] = function(player, targetPlayer)
	if not targetPlayer then return end
	local jailFolderName = "Jail_" .. targetPlayer.Name
	local jailFolder = workspace:FindFirstChild(jailFolderName)
	if jailFolder then jailFolder:Destroy() end

	-- Optional: move player to a spawn
	local spawns = workspace:GetChildren()
	for _, item in ipairs(spawns) do
		if item:IsA("SpawnLocation") and targetPlayer.Character then
			targetPlayer.Character:SetPrimaryPartCFrame(item.CFrame + Vector3.new(0,3,0))
			break
		end
	end
end
-- Char command
commands["char"] = function(player, targetPlayer, newUsernameOrId)
	if not targetPlayer or not targetPlayer.Character or not newUsernameOrId then return end
	local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local userIdToApply
	if tonumber(newUsernameOrId) then -- If it's a number, assume UserId
		userIdToApply = tonumber(newUsernameOrId)
	else -- Otherwise, assume username
		local success, foundUserId = pcall(Players.GetUserIdFromNameAsync, Players, newUsernameOrId)
		if success and foundUserId then
			userIdToApply = foundUserId
		else
			-- print("User not found: " .. newUsernameOrId)
			return
		end
	end

	if userIdToApply then
		local successDesc, desc = pcall(Players.GetHumanoidDescriptionFromUserId, Players, userIdToApply)
		if successDesc and desc then
			humanoid:ApplyDescription(desc)
		else
			-- print("Could not apply description for ID: " .. userIdToApply)
		end
	end
end
-- Rejoin command (targets self by default if no target specified)
commands["rejoin"] = function(player, targetNameOrNil)
	local playerToTeleport = player -- Default to self
	if targetNameOrNil and type(targetNameOrNil) == "userdata" and targetNameOrNil:IsA("Player") then
		playerToTeleport = targetNameOrNil
	elseif type(targetNameOrNil) == "string" then
		local found = getPlayerByName(targetNameOrNil, player)
		if #found > 0 then playerToTeleport = found[1] end
	end

	if playerToTeleport then
		TeleportService:Teleport(game.PlaceId, playerToTeleport)
	end
end
-- Talk command
commands["talk"] = function(player, targetPlayer, ...)
	local message = table.concat({...}, " ")
	if targetPlayer and message and message ~= "" and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
		ChatService:Chat(targetPlayer.Character.Head, message, Enum.ChatColor.White) -- Chat from Head for bubble chat
	end
end
-- Gear command
commands["gear"] = function(player, targetPlayer, gearId)
	local id = tonumber(gearId)
	if not id then return end
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		pcall(function()
			local asset = InsertService:LoadAsset(id)
			local tool = asset:FindFirstChildOfClass("Tool") or asset:FindFirstChildOfClass("HopperBin")
			if tool then
				tool:Clone().Parent = targetPlayer.Backpack
			end
			asset:Destroy()
		end)
	end
end
-- RPG command
commands["rpg"] = function(player, targetPlayer)
	local toolId = 123829060 -- Example RPG ID
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		pcall(function()
			local asset = InsertService:LoadAsset(toolId)
			local tool = asset:FindFirstChildOfClass("Tool")
			if tool then
				tool:Clone().Parent = targetPlayer.Backpack
			end
			asset:Destroy()
		end)
	end
end
-- Tptool command
commands["tptool"] = function(player, targetPlayer)
	local toolId = 139382374 -- Example TP Tool ID
	if targetPlayer and targetPlayer:FindFirstChild("Backpack") then
		pcall(function()
			local asset = InsertService:LoadAsset(toolId)
			local tool = asset:FindFirstChildOfClass("Tool")
			if tool then
				tool:Clone().Parent = targetPlayer.Backpack
			end
			asset:Destroy()
		end)
	end
end
-- Re (Refresh) command
commands["re"] = function(player, targetPlayer)
	if targetPlayer then
		targetPlayer:LoadCharacter()
	end
end
-- Ls (Lightning Strike) command
commands["ls"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
		local pos = targetPlayer.Character.PrimaryPart.Position
		local lightning = Instance.new("Part", workspace)
		lightning.Size = Vector3.new(3, 200, 3)
		lightning.Position = pos + Vector3.new(0, lightning.Size.Y/2 - 10, 0) -- Start higher up
		lightning.Anchored = true
		lightning.CanCollide = false
		lightning.BrickColor = BrickColor.new("New Yeller")
		lightning.Material = Enum.Material.Neon
		lightning.Transparency = 0.4

		local sound = Instance.new("Sound", lightning)
		sound.SoundId = "rbxassetid://159510039" -- Thunder sound
		sound.Volume = 1.5
		sound:Play()

		game:GetService("Debris"):AddItem(lightning, 0.2)
		game:GetService("Debris"):AddItem(sound, 3)

		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:TakeDamage(60) end
	end
end
-- Erain (Explosive Rain) command
commands["erain"] = function(player, targetOrNil) -- Target not used for this global effect
	local rainAreaSize = 150
	local rainHeight = 200
	local numBarrels = 25
	for i = 1, numBarrels do
		local barrel = Instance.new("Part", workspace)
		barrel.Shape = Enum.PartType.Cylinder
		barrel.Size = Vector3.new(4, 6, 4) -- Diameter 4, Height 6
		barrel.BrickColor = BrickColor.Red()
		barrel.Position = Vector3.new(math.random(-rainAreaSize/2, rainAreaSize/2), rainHeight, math.random(-rainAreaSize/2, rainAreaSize/2))
		barrel.Anchored = false
		barrel.CanCollide = true
		barrel.Name = "ExplodingBarrel"

		local fire = Instance.new("Fire", barrel)
		fire.Heat = 9; fire.Size = 5;

		barrel.Touched:Connect(function(hit)
			if not barrel.Parent then return end -- Already exploded
			local explosion = Instance.new("Explosion", workspace)
			explosion.Position = barrel.Position
			explosion.BlastRadius = 18
			explosion.BlastPressure = 300000
			explosion.DestroyJointRadiusPercent = 0.5
			barrel:Destroy()
		end)
		game:GetService("Debris"):AddItem(barrel, 12) -- Auto-cleanup if not touched
		task.wait(0.15)
	end
end
-- Gflip (Gravity Flip) command
commands["gflip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		hrp.CFrame = hrp.CFrame * CFrame.Angles(math.pi, 0, 0) -- Flip upside down

		local bodyForce = Instance.new("BodyForce", hrp)
		bodyForce.Force = Vector3.new(0, workspace.Gravity * hrp:GetMass() * 2.1, 0) -- Counteract gravity + push up

		task.delay(3.5, function()
			if bodyForce and bodyForce.Parent then bodyForce:Destroy() end
			if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart and targetPlayer.Character.PrimaryPart.Parent then
				targetPlayer.Character.PrimaryPart.CFrame = targetPlayer.Character.PrimaryPart.CFrame * CFrame.Angles(math.pi, 0, 0) -- Flip back
			end
		end)
	end
end
-- Noclip command
commands["noclip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		targetPlayer:SetAttribute("NoclipActive", true)
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end -- Helps sometimes

		for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end
-- Clip command
commands["clip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		targetPlayer:SetAttribute("NoclipActive", false)
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end -- Return to normal physics state

		for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				-- This is a basic reset. A more robust system would remember original CanCollide states.
				if part.Name ~= "HumanoidRootPart" then -- HRP should generally not collide
					part.CanCollide = true
				end
			end
		end
	end
end
-- Heal command
commands["heal"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local humanoid = targetPlayer.Character.Humanoid
		humanoid.Health = humanoid.MaxHealth -- Heal to current max health
	end
end
-- Light command
commands["light"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
		local head = targetPlayer.Character.Head
		local existingLight = head:FindFirstChild("AdminSpotLight")
		if existingLight then existingLight:Destroy() end

		local light = Instance.new("SpotLight", head)
		light.Name = "AdminSpotLight"
		light.Range = 70
		light.Brightness = 2.5
		light.Angle = 80
		light.Face = Enum.NormalId.Front
		light.Shadows = true
	end
end
-- Fly command (Server-side part, needs client LocalScript for controls)
local flyEvent = ReplicatedStorage:FindFirstChild("FlyEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
flyEvent.Name = "FlyEvent"

commands["fly"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	targetPlayer:SetAttribute("IsFlyingAdmin", true)
	flyEvent:FireClient(targetPlayer, true) -- Signal client to enable flight controls
end
-- Unfly command
commands["unfly"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end
	targetPlayer:SetAttribute("IsFlyingAdmin", false)
	flyEvent:FireClient(targetPlayer, false) -- Signal client to disable
end
-- Spike command
commands["spike"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then return end
	local hrp = targetPlayer.Character.PrimaryPart
	local spikeModelName = "SpikeTrap_"..targetPlayer.Name
	if workspace:FindFirstChild(spikeModelName) then workspace[spikeModelName]:Destroy() end

	local spikeModel = Instance.new("Model", workspace)
	spikeModel.Name = spikeModelName

	local numSpikes = 16
	local radius = 7
	local spikeHeight = 12
	local basePos = hrp.Position - Vector3.new(0, hrp.Size.Y/2, 0) -- Ground level

	for i = 1, numSpikes do
		local angle = (i / numSpikes) * math.pi * 2
		local xOffset = math.cos(angle) * radius
		local zOffset = math.sin(angle) * radius

		local spike = Instance.new("WedgePart", spikeModel)
		spike.Size = Vector3.new(1.5, spikeHeight, 1.5)
		spike.Anchored = true
		spike.BrickColor = BrickColor.new("Really red")
		spike.Material = Enum.Material.CorrodedMetal
		spike.Name = "Spike"
		spike.CanCollide = true
		spike.CFrame = CFrame.new(basePos + Vector3.new(xOffset, spikeHeight/2, zOffset)) * CFrame.fromEulerAnglesYXZ(0, angle + math.pi/2, math.pi/2)

		spike.Touched:Connect(function(hit)
			local char = hit.Parent
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then hum.Health = 0 end
		end)
	end
	game:GetService("Debris"):AddItem(spikeModel, 15) -- Auto cleanup
end
-- Hide Forcefield command
commands["hff"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local forceField = targetPlayer.Character:FindFirstChildOfClass("ForceField")
		if forceField then forceField.Visible = false end
	end
end

-- Pm command (pop-up on target's screen)
commands["pm"] = function(executingPlayer, targetPlayer, ...)
	local message = table.concat({...}, " ")
	if not targetPlayer or not targetPlayer.PlayerGui or message == "" then return end

	local pmGuiName = "PrivateMessageDisplay"
	local oldGui = targetPlayer.PlayerGui:FindFirstChild(pmGuiName)
	if oldGui then oldGui:Destroy() end

	local screenGui = Instance.new("ScreenGui", targetPlayer.PlayerGui)
	screenGui.Name = pmGuiName
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(0, 320, 0, 130)
	frame.Position = UDim2.new(0.5, -160, 0.05, 0) -- Near top-center
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BorderSizePixel = 1
	frame.BorderColor3 = Color3.fromRGB(60,60,60)

	local titleLabel = Instance.new("TextLabel", frame)
	titleLabel.Size = UDim2.new(1, 0, 0, 25)
	titleLabel.BackgroundColor3 = Color3.fromRGB(45,45,45)
	titleLabel.Text = "PM from: " .. executingPlayer.Name
	titleLabel.Font = Enum.Font.SourceSansSemibold
	titleLabel.TextSize = 16
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

	local messageLabel = Instance.new("TextLabel", frame)
	messageLabel.Size = UDim2.new(1, -10, 0, 70) -- Padded
	messageLabel.Position = UDim2.new(0, 5, 0, 30)
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
	messageLabel.BackgroundTransparency = 1
	messageLabel.TextWrapped = true
	messageLabel.Font = Enum.Font.SourceSans
	messageLabel.TextSize = 14
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top

	local closeButton = Instance.new("TextButton", frame)
	closeButton.Size = UDim2.new(1, -10, 0, 20)
	closeButton.Position = UDim2.new(0, 5, 1, -25) -- Padded bottom
	closeButton.Text = "Close"
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
	closeButton.Font = Enum.Font.SourceSansBold
	closeButton.TextSize = 14

	closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)
	game:GetService("Debris"):AddItem(screenGui, 25) -- Auto-close after 25 seconds
end
-- Color command
commands["color"] = function(player, targetPlayer, colorName)
	local color = colorName and colorTable[colorName:lower()]
	if not color then return end
	if targetPlayer and targetPlayer.Character then
		for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.Color = color end -- Use .Color for Color3
		end
	end
end
-- Size command
commands["size"] = function(player, targetPlayer, sizeFactor)
	local size = tonumber(sizeFactor)
	if not size or size <= 0.1 or size > 4 then return end -- Sanity limits
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.DepthScale = size
			desc.WidthScale = size
			desc.HeightScale = size
			desc.HeadScale = size
			humanoid:ApplyDescription(desc)
		end
	end
end
-- Aura command
commands["aura"] = function(player, targetPlayer, colorName)
	local color = colorName and colorTable[colorName:lower()] or Color3.new(1,1,1) -- Default white
	if targetPlayer and targetPlayer.Character then
		local oldHighlight = targetPlayer.Character:FindFirstChild("AdminAuraHighlight")
		if oldHighlight then oldHighlight:Destroy() end

		local highlight = Instance.new("Highlight", targetPlayer.Character)
		highlight.Name = "AdminAuraHighlight"
		highlight.Adornee = targetPlayer.Character -- Highlight whole character model
		highlight.FillColor = color
		highlight.OutlineColor = color
		highlight.FillTransparency = 0.75
		highlight.OutlineTransparency = 0.3
	end
end
-- Tkill (Timed Kill) command
commands["tkill"] = function(player, targetPlayer, timeInSeconds)
	local delayTime = tonumber(timeInSeconds)
	if not delayTime or delayTime <= 0 then return end
	if targetPlayer then
		task.delay(delayTime, function()
			if targetPlayer and targetPlayer.Parent and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
				targetPlayer.Character.Humanoid.Health = 0
			end
		end)
	end
end
-- Rocket command
commands["rocket"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then return end
	local hrp = targetPlayer.Character.PrimaryPart
	local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Allow forces
	local bodyVelocity = Instance.new("BodyVelocity", hrp)
	bodyVelocity.Velocity = Vector3.new(0, 250, 0) -- Stronger launch
	bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
	bodyVelocity.P = 10000 -- Responsive

	task.delay(1.2, function() -- Shorter fuse
		if bodyVelocity and bodyVelocity.Parent then bodyVelocity:Destroy() end
		if targetPlayer and targetPlayer.Parent and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
			local explosion = Instance.new("Explosion", workspace)
			explosion.Position = targetPlayer.Character.PrimaryPart.Position
			explosion.BlastRadius = 25
			explosion.BlastPressure = 600000
			if humanoid and humanoid.Parent then humanoid.Health = 0 end
		end
	end)
end
-- Gravity command (affects global workspace gravity)
commands["gravity"] = function(player, targetOrValue, valueIfTarget)
	local newGravity
	if tonumber(targetOrValue) then -- ;gravity 50
		newGravity = tonumber(targetOrValue)
	elseif valueIfTarget and tonumber(valueIfTarget) then -- ;gravity <target_ignored> 50
		newGravity = tonumber(valueIfTarget)
	elseif type(targetOrValue) == "string" and targetOrValue:lower() == "reset" then
		workspace.Gravity = 196.2 -- Roblox default
		return
	end

	if newGravity and newGravity >= 0 and newGravity <= 1000 then -- Reasonable range
		workspace.Gravity = newGravity
	end
end
-- Kaura (Kill Aura) command
local activeKillAuras = {} -- Stores { UserId = {Part=auraPart, Connection=touchedConn} }
commands["kaura"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then return end
	if activeKillAuras[targetPlayer.UserId] then return end -- Already active

	local hrp = targetPlayer.Character.PrimaryPart
	local auraPart = Instance.new("Part", targetPlayer.Character)
	auraPart.Name = "PlayerKillAura"
	auraPart.Shape = Enum.PartType.Ball
	auraPart.Size = Vector3.new(12,12,12)
	auraPart.BrickColor = BrickColor.new("Really red")
	auraPart.Material = Enum.Material.Neon
	auraPart.Transparency = 0.65
	auraPart.Anchored = false
	auraPart.CanCollide = false

	local weld = Instance.new("WeldConstraint", auraPart)
	weld.Part0 = auraPart
	weld.Part1 = hrp

	local connection
	connection = auraPart.Touched:Connect(function(hit)
		local hitChar = hit.Parent
		local hitHum = hitChar and hitChar:FindFirstChildOfClass("Humanoid")
		if hitHum and hitChar ~= targetPlayer.Character and hitHum.Health > 0 then
			hitHum.Health = 0
		end
	end)
	activeKillAuras[targetPlayer.UserId] = {Part = auraPart, Connection = connection}

	-- Cleanup when character removed
	targetPlayer.CharacterRemoving:Connect(function()
		if activeKillAuras[targetPlayer.UserId] then
			activeKillAuras[targetPlayer.UserId].Connection:Disconnect()
			activeKillAuras[targetPlayer.UserId].Part:Destroy()
			activeKillAuras[targetPlayer.UserId] = nil
		end
	end)
end
-- Flip command
commands["flip"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
		local primaryPart = targetPlayer.Character.PrimaryPart
		primaryPart.CFrame = primaryPart.CFrame * CFrame.Angles(0, 0, math.pi) -- Roll 180 degrees
	end
end
-- Warp command
commands["warp"] = function(player, targetPlayer, dimensionName)
	local dimensions = {
		["test"] = CFrame.new(math.random(-200,200), 50, math.random(-200,200)),
		["ohio"] = CFrame.new(-5000, 20, -5000),
		["void"] = CFrame.new(0, -1000, 0)
	}
	local destination = dimensionName and dimensions[dimensionName:lower()]

	if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart and destination then
		local hrp = targetPlayer.Character.PrimaryPart
		local effect = Instance.new("Part", workspace)
		effect.Size = Vector3.new(12,12,12); effect.Shape = Enum.PartType.Ball
		effect.Position = hrp.Position; effect.BrickColor = BrickColor.new("Electric blue")
		effect.Material = Enum.Material.Neon; effect.Anchored = true
		effect.CanCollide = false; effect.Transparency = 0.4
		game:GetService("Debris"):AddItem(effect, 0.8)

		targetPlayer.Character:SetPrimaryPartCFrame(destination)
	end
end
-- Loadmap command
commands["loadmap"] = function(player, targetOrNil) -- Target not used
	-- Clear existing loose parts (be careful with this in a real game with important models)
	for _, item in ipairs(workspace:GetChildren()) do
		if item:IsA("BasePart") and not item.Anchored and item.Name ~= "Terrain" and not item:FindFirstAncestorOfClass("Model") then
			item:Destroy()
		elseif item:IsA("Model") and (item.Name == "Baseplate" or item.Name == "Spawn") then -- Example names
			item:Destroy()
		end
	end
	if workspace:FindFirstChild("Baseplate") then workspace.Baseplate:Destroy() end
	if workspace:FindFirstChild("SpawnLocation") then workspace.SpawnLocation:Destroy() end


	local baseplate = Instance.new("Part", workspace)
	baseplate.Name = "Baseplate"
	baseplate.Size = Vector3.new(1024, 20, 1024)
	baseplate.Position = Vector3.new(0, -10, 0)
	baseplate.Anchored = true
	baseplate.Locked = true
	baseplate.BrickColor = BrickColor.new("Medium stone grey")
	baseplate.Material = Enum.Material.Plastic

	local spawnPoint = Instance.new("SpawnLocation", workspace)
	spawnPoint.Name = "SpawnLocation"
	spawnPoint.Position = Vector3.new(0, 5, 0)
	spawnPoint.Size = Vector3.new(15, 1, 15)
	spawnPoint.Anchored = true
	spawnPoint.Locked = true
	spawnPoint.AllowTeamChangeOnTouch = false
	spawnPoint.Neutral = true

	-- Reload all players to the new spawn
	for _, p in ipairs(Players:GetPlayers()) do p:LoadCharacter() end

	-- Basic lighting reset
	local lighting = game:GetService("Lighting")
	lighting.Ambient = Color3.fromRGB(128,128,128)
	lighting.Brightness = 2
	lighting.GlobalShadows = true
	lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
	if lighting:FindFirstChild("Sky") then lighting.Sky:Destroy() end
	Instance.new("Sky", lighting) -- Default sky
end
-- Rlist (Rank List GUI) command
commands["rlist"] = function(player, targetOrNil) -- Target not used
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	if playerGui:FindFirstChild("AdminRankListGui") then playerGui.AdminRankListGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui", playerGui)
	ScreenGui.Name = "AdminRankListGui"; ScreenGui.ResetOnSpawn = false

	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0,300,0,350); Frame.Position = UDim2.new(0.5,-150,0.5,-175)
	Frame.BackgroundColor3 = Color3.fromRGB(35,35,35); Frame.BorderSizePixel = 0
	Frame.Active = true; Frame.Draggable = true

	local TitleBar = Instance.new("Frame", Frame)
	TitleBar.Size = UDim2.new(1,0,0,28); TitleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1,-28,1,0); TitleLabel.Text = "Player Ranks"; TitleLabel.Font = Enum.Font.SourceSansSemibold
	TitleLabel.TextSize = 17; TitleLabel.TextColor3 = Color3.fromRGB(255,255,0); TitleLabel.BackgroundTransparency = 1
	local ExitButton = Instance.new("TextButton", TitleBar)
	ExitButton.Size = UDim2.new(0,28,1,0); ExitButton.Position = UDim2.new(1,-28,0,0); ExitButton.Text = "X"
	ExitButton.BackgroundColor3 = Color3.fromRGB(190,40,40); ExitButton.TextColor3 = Color3.white; ExitButton.Font = Enum.Font.SourceSansBold

	local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
	ScrollingFrame.Size = UDim2.new(1,-8,1,-32); ScrollingFrame.Position = UDim2.new(0,4,0,28)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45,45,45); ScrollingFrame.BorderSizePixel = 0; ScrollingFrame.ScrollBarThickness = 5

	local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
	UIListLayout.Padding = UDim.new(0,4); UIListLayout.SortOrder = Enum.SortOrder.Name

	local totalHeight = 0
	for _, p in ipairs(Players:GetPlayers()) do
		local rank = getRank(p)
		local rankLabel = Instance.new("TextLabel", ScrollingFrame); rankLabel.Name = p.Name -- For sorting
		rankLabel.Text = p.Name .. " - " .. rank; rankLabel.Size = UDim2.new(1,0,0,22)
		rankLabel.Font = Enum.Font.SourceSans; rankLabel.TextSize = 15; rankLabel.TextColor3 = Color3.fromRGB(210,210,210)
		rankLabel.BackgroundTransparency = 1; rankLabel.TextXAlignment = Enum.TextXAlignment.Left
		totalHeight = totalHeight + 22 + UIListLayout.Padding.Offset
	end
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0,totalHeight)
	ExitButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end
-- Logs command
commands["logs"] = function(player, targetOrNil) -- Target not used
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	if playerGui:FindFirstChild("AdminCommandLogsGui") then playerGui.AdminCommandLogsGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui", playerGui)
	ScreenGui.Name = "AdminCommandLogsGui"; ScreenGui.ResetOnSpawn = false
	-- Frame, Title, ExitButton setup similar to rlist
	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0,400,0,300); Frame.Position = UDim2.new(0.5,-200,0.5,-150)
	Frame.BackgroundColor3 = Color3.fromRGB(35,35,35); Frame.BorderSizePixel = 0
	Frame.Active = true; Frame.Draggable = true
	local TitleBar = Instance.new("Frame", Frame)
	TitleBar.Size = UDim2.new(1,0,0,28); TitleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1,-28,1,0); TitleLabel.Text = "Command Logs"; TitleLabel.Font = Enum.Font.SourceSansSemibold
	TitleLabel.TextSize = 17; TitleLabel.TextColor3 = Color3.fromRGB(255,255,0); TitleLabel.BackgroundTransparency = 1
	local ExitButton = Instance.new("TextButton", TitleBar)
	ExitButton.Size = UDim2.new(0,28,1,0); ExitButton.Position = UDim2.new(1,-28,0,0); ExitButton.Text = "X"
	ExitButton.BackgroundColor3 = Color3.fromRGB(190,40,40); ExitButton.TextColor3 = Color3.white; ExitButton.Font = Enum.Font.SourceSansBold

	local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
	ScrollingFrame.Size = UDim2.new(1,-8,1,-32); ScrollingFrame.Position = UDim2.new(0,4,0,28)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45,45,45); ScrollingFrame.BorderSizePixel = 0; ScrollingFrame.ScrollBarThickness = 5

	local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
	UIListLayout.Padding = UDim.new(0,2)

	local totalHeight = 0
	for i = #commandLogs, 1, -1 do -- Newest first
		local logEntry = commandLogs[i]
		local logLabel = Instance.new("TextLabel", ScrollingFrame)
		logLabel.Text = string.format("[%s] %s: %s", logEntry.timestamp, logEntry.playerName, logEntry.command)
		logLabel.Size = UDim2.new(1,-4,0,20); logLabel.Font = Enum.Font.Code -- Monospace
		logLabel.TextSize = 13; logLabel.TextColor3 = Color3.fromRGB(190,190,190); logLabel.BackgroundTransparency = 1
		logLabel.TextXAlignment = Enum.TextXAlignment.Left; logLabel.TextWrapped = true
		totalHeight = totalHeight + 20 + UIListLayout.Padding.Offset
	end
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0,totalHeight)
	ScrollingFrame.CanvasPosition = Vector2.new(0, ScrollingFrame.CanvasSize.Y.Offset) -- Scroll to bottom

	ExitButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end
-- Crl (Command Rank List) command
commands["crl"] = function(player, targetOrNil) -- Target not used
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	if playerGui:FindFirstChild("AdminCmdRankListGui") then playerGui.AdminCmdRankListGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui", playerGui)
	ScreenGui.Name = "AdminCmdRankListGui"; ScreenGui.ResetOnSpawn = false
	-- Frame, Title, ExitButton setup similar to rlist
	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0,350,0,400); Frame.Position = UDim2.new(0.5,-175,0.5,-200)
	Frame.BackgroundColor3 = Color3.fromRGB(35,35,35); Frame.BorderSizePixel = 0
	Frame.Active = true; Frame.Draggable = true
	local TitleBar = Instance.new("Frame", Frame)
	TitleBar.Size = UDim2.new(1,0,0,28); TitleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1,-28,1,0); TitleLabel.Text = "Command Permissions"; TitleLabel.Font = Enum.Font.SourceSansSemibold
	TitleLabel.TextSize = 17; TitleLabel.TextColor3 = Color3.fromRGB(255,255,0); TitleLabel.BackgroundTransparency = 1
	local ExitButton = Instance.new("TextButton", TitleBar)
	ExitButton.Size = UDim2.new(0,28,1,0); ExitButton.Position = UDim2.new(1,-28,0,0); ExitButton.Text = "X"
	ExitButton.BackgroundColor3 = Color3.fromRGB(190,40,40); ExitButton.TextColor3 = Color3.white; ExitButton.Font = Enum.Font.SourceSansBold

	local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
	ScrollingFrame.Size = UDim2.new(1,-8,1,-32); ScrollingFrame.Position = UDim2.new(0,4,0,28)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45,45,45); ScrollingFrame.BorderSizePixel = 0; ScrollingFrame.ScrollBarThickness = 5

	local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
	UIListLayout.Padding = UDim.new(0,4); UIListLayout.SortOrder = Enum.SortOrder.Name

	local sortedCmds = {}
	for cmdName, _ in pairs(commandRanks) do table.insert(sortedCmds, cmdName) end
	table.sort(sortedCmds)

	local totalHeight = 0
	for _, cmdName in ipairs(sortedCmds) do
		local rankNeeded = commandRanks[cmdName]
		local cmdLabel = Instance.new("TextLabel", ScrollingFrame); cmdLabel.Name = cmdName -- For sorting
		cmdLabel.Text = ";" .. cmdName .. "  -  (" .. rankNeeded .. ")"
		cmdLabel.Size = UDim2.new(1,0,0,22); cmdLabel.Font = Enum.Font.SourceSans
		cmdLabel.TextSize = 15; cmdLabel.TextColor3 = Color3.fromRGB(210,210,210); cmdLabel.BackgroundTransparency = 1
		cmdLabel.TextXAlignment = Enum.TextXAlignment.Left
		totalHeight = totalHeight + 22 + UIListLayout.Padding.Offset
	end
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0,totalHeight)
	ExitButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end
-- Smoke command
commands["smoke"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		if hrp:FindFirstChild("AdminSmokeEffect") then return end
		local smoke = Instance.new("Smoke", hrp); smoke.Name = "AdminSmokeEffect"
		smoke.Color = Color3.fromRGB(150,150,150); smoke.Opacity = 0.6
		smoke.RiseVelocity = 0.5; smoke.Size = 12
	end
end
-- Fire command
commands["fire"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		if hrp:FindFirstChild("AdminFireEffect") then return end
		local fire = Instance.new("Fire", hrp); fire.Name = "AdminFireEffect"
		fire.Color = Color3.fromRGB(255,120,0); fire.SecondaryColor = Color3.fromRGB(200,50,0)
		fire.Heat = 12; fire.Size = 6
	end
end
-- Shutdown command
commands["shutdown"] = function(player, targetOrNil) -- Target not used
	for _, p in ipairs(Players:GetPlayers()) do
		p.PlayerGui:ClearAllChildren() -- Clear GUIs for the message
		local gui = Instance.new("ScreenGui", p.PlayerGui); gui.IgnoreGuiInset = true
		local frame = Instance.new("Frame", gui); frame.Size = UDim2.fromScale(1,1); frame.BackgroundColor3 = Color3.new(0,0,0); frame.BackgroundTransparency = 0.2
		local label = Instance.new("TextLabel", frame); label.Size = UDim2.fromScale(0.8,0.2); label.Position = UDim2.fromScale(0.1,0.4)
		label.Text = "SERVER IS SHUTTING DOWN\nKicked by: " .. player.Name; label.Font = Enum.Font.GothamBold
		label.TextScaled = true; label.TextColor3 = Color3.fromRGB(255,30,30); label.BackgroundTransparency = 1
		label.TextWrapped = true
	end
	task.wait(5)
	for _, p in ipairs(Players:GetPlayers()) do
		p:Kick("Server shutdown by: " .. player.Name)
	end
	-- Note: game:Shutdown() is for the entire game instance, not just one server. Usually not what's wanted for admin commands.
end
-- Thin command
commands["thin"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.WidthScale = 0.5; desc.DepthScale = 0.5
			humanoid:ApplyDescription(desc)
		end
	end
end
-- Fat command
commands["fat"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.WidthScale = 1.5; desc.DepthScale = 1.5
			humanoid:ApplyDescription(desc)
		end
	end
end
-- Width command
commands["width"] = function(player, targetPlayer, scaleAmount)
	local scale = tonumber(scaleAmount)
	if not scale or scale <= 0.1 or scale > 3 then return end
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.WidthScale = scale
			humanoid:ApplyDescription(desc)
		end
	end
end
-- Height command
commands["height"] = function(player, targetPlayer, scaleAmount)
	local scale = tonumber(scaleAmount)
	if not scale or scale <= 0.1 or scale > 3 then return end
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.HeightScale = scale
			humanoid:ApplyDescription(desc)
		end
	end
end
-- Unfire command
commands["unfire"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local fireEffect = targetPlayer.Character.HumanoidRootPart:FindFirstChild("AdminFireEffect")
		if fireEffect then fireEffect:Destroy() end
	end
end
-- Unfat / Unthin / Unwidth / Unheight (reset to default scales)
local function resetScales(targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local desc = humanoid:GetAppliedDescription()
			desc.WidthScale = 1; desc.DepthScale = 1; desc.HeightScale = 1; desc.HeadScale = 1
			humanoid:ApplyDescription(desc)
		end
	end
end
commands["unfat"] = resetScales
commands["unthin"] = resetScales
commands["unwidth"] = resetScales
commands["unheight"] = resetScales

-- Unsmoke command
commands["unsmoke"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local smokeEffect = targetPlayer.Character.HumanoidRootPart:FindFirstChild("AdminSmokeEffect")
		if smokeEffect then smokeEffect:Destroy() end
	end
end
-- Unaura command
commands["unaura"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character then
		local highlight = targetPlayer.Character:FindFirstChild("AdminAuraHighlight")
		if highlight then highlight:Destroy() end
	end
end
-- Mute/Unmute/ChatColor: Server sets attributes, client LocalScript reads them for effect.
local muteEventClient = ReplicatedStorage:FindFirstChild("ClientMuteEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
muteEventClient.Name = "ClientMuteEvent"
local chatColorEventClient = ReplicatedStorage:FindFirstChild("ClientChatColorEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
chatColorEventClient.Name = "ClientChatColorEvent"

commands["mute"] = function(player, targetPlayer)
	if targetPlayer then
		targetPlayer:SetAttribute("IsAdminMuted", true)
		muteEventClient:FireClient(targetPlayer, true) -- Signal client
	end
end
commands["unmute"] = function(player, targetPlayer)
	if targetPlayer then
		targetPlayer:SetAttribute("IsAdminMuted", false)
		muteEventClient:FireClient(targetPlayer, false)
	end
end
commands["chatcolor"] = function(player, targetPlayer, colorName)
	local color = colorName and colorTable[colorName:lower()]
	if not color then return end
	if targetPlayer then
		targetPlayer:SetAttribute("AdminChatColor", color)
		chatColorEventClient:FireClient(targetPlayer, color)
	end
end
-- Health command
commands["health"] = function(player, targetPlayer, healthAmount)
	local health = tonumber(healthAmount)
	if not health or health <= 0 then return end
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = health; humanoid.Health = health
		end
	end
end
-- Title command
commands["title"] = function(player, targetPlayer, ...)
	local titleText = table.concat({...}, " ")
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") or titleText == "" then return end
	local head = targetPlayer.Character.Head
	local oldTitleGui = head:FindFirstChild("AdminTitleGui")
	if oldTitleGui then oldTitleGui:Destroy() end

	local billboardGui = Instance.new("BillboardGui", head); billboardGui.Name = "AdminTitleGui"
	billboardGui.Size = UDim2.new(4, 0, 1, 0); billboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
	billboardGui.AlwaysOnTop = true; billboardGui.MaxDistance = 60

	local textLabel = Instance.new("TextLabel", billboardGui)
	textLabel.Size = UDim2.fromScale(1,1); textLabel.BackgroundTransparency = 1
	textLabel.Text = titleText; textLabel.TextColor3 = Color3.new(1,0.9,0.3) -- Gold-ish
	textLabel.Font = Enum.Font.SourceSansSemibold; textLabel.TextScaled = true
	textLabel.TextStrokeTransparency = 0.6; textLabel.TextStrokeColor3 = Color3.new(0,0,0)
end
-- Untitle command
commands["untitle"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
		local titleGui = targetPlayer.Character.Head:FindFirstChild("AdminTitleGui")
		if titleGui then titleGui:Destroy() end
	end
end
-- Spin command
local spinningChars = {} -- { [UserId] = BodyAngularVelocity }
commands["spin"] = function(player, targetPlayer, speedStr)
	local speed = tonumber(speedStr) or 6
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.PrimaryPart then return end
	local hrp = targetPlayer.Character.PrimaryPart
	if spinningChars[targetPlayer.UserId] then spinningChars[targetPlayer.UserId]:Destroy() end

	local av = Instance.new("BodyAngularVelocity", hrp)
	av.AngularVelocity = Vector3.new(0, speed, 0)
	av.MaxTorque = Vector3.new(0, math.huge, 0); av.P = 12000
	spinningChars[targetPlayer.UserId] = av
	-- Auto-cleanup
	targetPlayer.CharacterRemoving:Connect(function()
		if spinningChars[targetPlayer.UserId] then
			spinningChars[targetPlayer.UserId]:Destroy()
			spinningChars[targetPlayer.UserId] = nil
		end
	end)
end
-- Unspin command
commands["unspin"] = function(player, targetPlayer)
	if targetPlayer and spinningChars[targetPlayer.UserId] then
		spinningChars[targetPlayer.UserId]:Destroy()
		spinningChars[targetPlayer.UserId] = nil
	end
end
-- Float command
commands["float"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		if hrp:FindFirstChild("AdminFloatForce") then hrp.AdminFloatForce:Destroy() end

		local bodyForce = Instance.new("BodyForce", hrp); bodyForce.Name = "AdminFloatForce"
		bodyForce.Force = Vector3.new(0, workspace.Gravity * hrp:GetMass() * 1.05, 0) -- Gentle float
		game:GetService("Debris"):AddItem(bodyForce, 10)
	end
end
-- Flashbang command
commands["flashbang"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.PlayerGui then
		local flashGuiName = "AdminFlashbangGui"
		local oldGui = targetPlayer.PlayerGui:FindFirstChild(flashGuiName)
		if oldGui then oldGui:Destroy() end

		local screenGui = Instance.new("ScreenGui", targetPlayer.PlayerGui); screenGui.Name = flashGuiName
		screenGui.IgnoreGuiInset = true; screenGui.ResetOnSpawn = false

		local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.fromScale(1,1)
		frame.BackgroundColor3 = Color3.new(1,1,1); frame.BackgroundTransparency = 0

		TweenService:Create(frame, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {BackgroundTransparency = 0}):Play()
		task.delay(0.05, function()
			if frame.Parent then
				TweenService:Create(frame, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			end
		end)
		game:GetService("Debris"):AddItem(screenGui, 1.5)
	end
end
-- Npc command
commands["npc"] = function(player, targetOrName, npcNameIfTarget)
	local npcName = (type(targetOrName) == "string" and targetOrName) or npcNameIfTarget or "Cool NPC"
	local spawnNearPlayer = (type(targetOrName) == "userdata" and targetOrName:IsA("Player") and targetOrName) or player

	if not spawnNearPlayer or not spawnNearPlayer.Character or not spawnNearPlayer.Character.PrimaryPart then return end

	local npc = Instance.new("Model", workspace); npc.Name = npcName
	local hrp = Instance.new("Part", npc); hrp.Name = "HumanoidRootPart"; hrp.Size = Vector3.new(2,2,1); hrp.Transparency = 1
	local head = Instance.new("Part", npc); head.Name = "Head"; head.Shape = Enum.PartType.Ball; head.Size = Vector3.new(2,2,2)
	local torso = Instance.new("Part", npc); torso.Name = "Torso"; torso.Size = Vector3.new(2,2,1)
	Instance.new("Humanoid", npc).DisplayName = npcName
	-- Basic R6 structure, simplified welds
	local weld = Instance.new("Weld"); weld.Part0 = torso; weld.Part1 = hrp; weld.Parent = torso
	local weldH = Instance.new("Weld"); weldH.Part0 = torso; weldH.Part1 = head; weldH.C0 = CFrame.new(0,1.5,0); weldH.Parent = torso
	npc:SetPrimaryPartCFrame(spawnNearPlayer.Character.PrimaryPart.CFrame * CFrame.new(math.random(3,7),0,math.random(3,7)))
end
-- Trap command
commands["trap"] = function(player, targetPlayer)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = targetPlayer.Character.HumanoidRootPart
		local trapName = "AdminTrap_"..targetPlayer.Name
		if workspace:FindFirstChild(trapName) then workspace[trapName]:Destroy() end

		local trapPart = Instance.new("Part", workspace); trapPart.Name = trapName
		trapPart.Size = Vector3.new(5,0.5,5); trapPart.Anchored = true
		trapPart.BrickColor = BrickColor.new("Obsidian"); trapPart.Material = Enum.Material.Metal
		trapPart.Position = hrp.Position - Vector3.new(0, hrp.Size.Y/2 + trapPart.Size.Y/4, 0)
		trapPart.CanCollide = true

		local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = 0; humanoid.JumpPower = 0 end

		game:GetService("Debris"):AddItem(trapPart, 12)
		task.delay(12, function()
			if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid") then
				local hum = targetPlayer.Character.Humanoid
				hum.WalkSpeed = 16; hum.JumpPower = 50
			end
		end)
	end
end
-- Blackhole command
commands["blackhole"] = function(player, targetOrNil)
	local spawnPos
	if targetOrNil and targetOrNil.Character and targetOrNil.Character.PrimaryPart then spawnPos = targetOrNil.Character.PrimaryPart.Position
	elseif player.Character and player.Character.PrimaryPart then spawnPos = player.Character.PrimaryPart.Position + player.Character.PrimaryPart.CFrame.LookVector * 15
	else return end

	local blackHole = Instance.new("Part", workspace); blackHole.Name = "AdminBlackhole"
	blackHole.Shape = Enum.PartType.Ball; blackHole.Size = Vector3.new(8,8,8)
	blackHole.BrickColor = BrickColor.Black(); blackHole.Material = Enum.Material.Neon
	blackHole.Anchored = true; blackHole.Position = spawnPos; blackHole.CanCollide = false

	local pullForceMagnitude = 7000; local pullRadius = 50; local duration = 8
	local startTime = tick()
	local heartbeatConn; heartbeatConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
		if tick() - startTime > duration or not blackHole.Parent then
			heartbeatConn:Disconnect(); if blackHole.Parent then blackHole:Destroy() end
			for _, p_itr in ipairs(Players:GetPlayers()) do if p_itr.Character and p_itr.Character:FindFirstChild("AdminBHForce") then p_itr.Character.AdminBHForce:Destroy() end end
			return
		end
		blackHole.CFrame = blackHole.CFrame * CFrame.Angles(0, dt * 2.5, 0) -- Spin
		for _, p_itr in ipairs(Players:GetPlayers()) do
			if p_itr.Character and p_itr.Character.PrimaryPart then
				local p_hrp = p_itr.Character.PrimaryPart
				local dir = (blackHole.Position - p_hrp.Position)
				if dir.Magnitude < pullRadius and dir.Magnitude > blackHole.Size.X * 0.6 then
					local bhForce = p_hrp:FindFirstChild("AdminBHForce") or Instance.new("BodyForce", p_hrp)
					bhForce.Name = "AdminBHForce"
					bhForce.Force = dir.Unit * pullForceMagnitude * p_hrp:GetMass() / math.max(1, dir.Magnitude ^ 0.7)
					if dir.Magnitude < blackHole.Size.X * 1.2 then
						local hum = p_itr.Character:FindFirstChildOfClass("Humanoid")
						if hum then hum:TakeDamage(8 * dt * 60) end -- 8 DPS when very close
					end
				elseif p_hrp:FindFirstChild("AdminBHForce") then p_hrp.AdminBHForce:Destroy() end
			end
		end
	end)
end
-- Laydown command (causes character to enter FallingDown state)
commands["laydown"] = function(player, targetPlayer)
	if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChildOfClass("Humanoid") then return end
	targetPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
end
-- Cmds command (GUI)
commands["cmds"] = function(player, targetOrNil) -- Target not used
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return end
	if playerGui:FindFirstChild("AdminCommandsGui") then playerGui.AdminCommandsGui:Destroy() end

	local ScreenGui = Instance.new("ScreenGui", playerGui); ScreenGui.Name = "AdminCommandsGui"; ScreenGui.ResetOnSpawn = false
	-- Frame, Title, Minimize, Exit setup similar to rlist
	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0,400,0,450); Frame.Position = UDim2.new(0.5,-200,0.5,-225)
	Frame.BackgroundColor3 = Color3.fromRGB(35,35,35); Frame.BorderSizePixel = 0
	Frame.Active = true; Frame.Draggable = true
	local TitleBar = Instance.new("Frame", Frame)
	TitleBar.Size = UDim2.new(1,0,0,28); TitleBar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = UDim2.new(1,-56,1,0); TitleLabel.Text = "Command List"; TitleLabel.Font = Enum.Font.SourceSansSemibold
	TitleLabel.TextSize = 17; TitleLabel.TextColor3 = Color3.fromRGB(255,255,0); TitleLabel.BackgroundTransparency = 1
	local MinimizeButton = Instance.new("TextButton", TitleBar)
	MinimizeButton.Size = UDim2.new(0,28,1,0); MinimizeButton.Position = UDim2.new(1,-56,0,0); MinimizeButton.Text = "_"
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(60,60,180); MinimizeButton.TextColor3 = Color3.white; MinimizeButton.Font = Enum.Font.SourceSansBold
	local ExitButton = Instance.new("TextButton", TitleBar)
	ExitButton.Size = UDim2.new(0,28,1,0); ExitButton.Position = UDim2.new(1,-28,0,0); ExitButton.Text = "X"
	ExitButton.BackgroundColor3 = Color3.fromRGB(190,40,40); ExitButton.TextColor3 = Color3.white; ExitButton.Font = Enum.Font.SourceSansBold

	local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
	ScrollingFrame.Size = UDim2.new(1,-8,1,-32); ScrollingFrame.Position = UDim2.new(0,4,0,28)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45,45,45); ScrollingFrame.BorderSizePixel = 0; ScrollingFrame.ScrollBarThickness = 5

	local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
	UIListLayout.Padding = UDim.new(0,2); UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local commandsListDescriptions = { -- Keep your original descriptions
		";kill - Kills the player.",";jump - Makes the player jump.",";speed - Sets player's walk speed.",";to - Teleports you to the player.",";freeze - Freezes player.", ";unfreeze - Unfreezes player.",";invisible - Makes player invisible.",";visible - Makes player visible.",";heal - Heals player to full health.",";god - Makes player invincible.",";ungod - Removes invincibility.",";bring - Brings player to you.",";sit - Makes player sit.",";sword - Gives player a sword.",";explode - Explodes player.",";loopkill - Loop kills a player.",";unloopkill - Stops loop killing.",";btools - Gives player btools.",";fling - Flings player.",";ff - Spawns forcefield.",";unff - Removes forcefield.",";hff - Hides forcefield.",";kick - Kicks player.",";damage - Damages player.",";clone - Clones player.",";jail - Jails player.",";unjail - Unjails player.",";rpg - Gives player an RPG.",";rejoin - Rejoins game.",";tptool - Gives teleport tool.",";re - Respawns player.",";loadmap - Loads default map.",";fly - Lets player fly.",";unfly - Stops flying.",";char - Changes avatar.",";gear - Gives Roblox gears.",";talk - Makes player chat.",";erain - Explosive rain.",";ls - Lightning strike.",";light - Spawns light.",";gflip - Flips gravity.",";noclip - Go through walls.",";clip - Disables noclip.",";spike - Spawns spikes.",";ban - Bans player.",";pm - Private message.",";color - Changes color.",";size - Changes size.",";aura - Highlights player.",";tkill - Timed kill.",";gravity - Changes gravity.",";flip - Flips player.",";rocket - Launches player.",";kaura - Kill aura.",";rlist - Player rank list.",";logs - Command logs.",";crl - Command rank list.",";smoke - Spawns smoke.",";fire - Sets player on fire.",";shutdown - Shuts down server.",";thin - Makes player thin.",";fat - Makes player fat.",";width - Changes width.",";height - Changes height.",";unban - Unban menu.",";unfire - Removes fire.",";unfat - Resets fatness.",";unthin - Resets thinness.",";unwidth - Resets width.",";unheight - Resets height.",";unsmoke - Removes smoke.",";unaura - Removes aura.",";mute - Mutes player chat.",";unmute - Unmutes player.",";chatcolor - Changes chat color.",";health - Sets max health.",";title - Text above head.",";untitle - Removes title.",";spin - Makes player spin.",";unspin - Stops spin.",";float - Makes player float.",";flashbang - Blinds player.",";npc - Spawns NPC.",";trap - Traps player.",";blackhole - Spawns blackhole.",";laydown - Makes player lay down.",
	}
	table.sort(commandsListDescriptions) -- Sort alphabetically for easier reading

	local totalHeight = 0
	for _, cmdDesc in ipairs(commandsListDescriptions) do
		local cmdLabel = Instance.new("TextLabel", ScrollingFrame)
		cmdLabel.Text = cmdDesc; cmdLabel.Size = UDim2.new(1,-4,0,18); cmdLabel.Font = Enum.Font.SourceSans
		cmdLabel.TextSize = 13; cmdLabel.TextColor3 = Color3.fromRGB(200,200,200); cmdLabel.BackgroundTransparency = 1
		cmdLabel.TextXAlignment = Enum.TextXAlignment.Left; cmdLabel.TextWrapped = true
		totalHeight = totalHeight + 18 + UIListLayout.Padding.Offset
	end
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0,totalHeight)

	local isMin = false; local originalSize = Frame.Size
	MinimizeButton.MouseButton1Click:Connect(function()
		isMin = not isMin; ScrollingFrame.Visible = not isMin
		Frame.Size = isMin and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, TitleBar.AbsoluteSize.Y) or originalSize
		MinimizeButton.Text = isMin and "O" or "_"
	end)
	ExitButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

-- Player Added Event
Players.PlayerAdded:Connect(function(player)
	loadPlayerData(player) -- Load rank and check ban status. Kicks if banned.
	-- Any other on-join logic for the player can go here.
	-- The command definitions (like pm, color, size) from your original PlayerAdded
	-- should be in the global 'commands' table to work with the RemoteEvent.
end)

-- Player Removing Event
Players.PlayerRemoving:Connect(function(player)
	savePlayerData(player) -- Save data when player leaves
	playerRanks[player.Name] = nil -- Clear runtime cache
	bannedPlayers[player.Name] = nil -- Clear runtime cache
	if loopKillingPlayers and loopKillingPlayers[player.UserId] then loopKillingPlayers[player.UserId] = nil end
	if spinningChars and spinningChars[player.UserId] then spinningChars[player.UserId]:Destroy(); spinningChars[player.UserId] = nil end
	if activeKillAuras and activeKillAuras[player.UserId] then
		if activeKillAuras[player.UserId].Connection then activeKillAuras[player.UserId].Connection:Disconnect() end
		if activeKillAuras[player.UserId].Part then activeKillAuras[player.UserId].Part:Destroy() end
		activeKillAuras[player.UserId] = nil
	end
end)

-- Save all player data on game shutdown
game:BindToClose(function()
	if Players:GetPlayers() then
		for _, player in ipairs(Players:GetPlayers()) do
			savePlayerData(player)
		end
	end
	-- A small wait can sometimes help ensure DataStore operations complete, especially in Studio.
	if game:GetService("RunService"):IsStudio() then task.wait(1) end
	-- print("Server shutting down, all player data attempting to save.")
end)


-- Function to execute a command (called by RemoteEvent)
local function executeCommand(player, commandName, targetName, arg1)
	local playerRank = getRank(player)
	local requiredRankStr = commandRanks[commandName]

	if not requiredRankStr then
		-- print("Command "..commandName.." has no rank defined.")
		return
	end

	if canExecute(playerRank, requiredRankStr) then
		logCommand(player, commandName .. " " .. (targetName or "") .. " " .. (arg1 or "")) -- Log the executed command

		local targets = getPlayerByName(targetName, player)

		if #targets == 0 and targetName and targetName ~= "" then
			-- Check if command is one that doesn't strictly need a player target but might take targetName as arg1
			local nonPlayerTargetCommands = {"gravity", "erain", "loadmap", "shutdown", "unban", "cmds", "rlist", "logs", "crl"}
			local isNonPlayerTargetCmd = false
			for _, cmd in ipairs(nonPlayerTargetCommands) do if cmd == commandName then isNonPlayerTargetCmd = true; break; end end

			if not isNonPlayerTargetCmd then
				-- Optionally notify player: SendMessage(player, "Target player '"..targetName.."' not found.")
				return
			end
		end

		if #targets == 0 then -- For commands that operate on self or globally if no target found/needed
			if commandName == "gravity" or commandName == "erain" or commandName == "loadmap" or commandName == "shutdown" or commandName == "unban" or commandName == "cmds" or commandName == "rlist" or commandName == "logs" or commandName == "crl" then
				commands[commandName](player, targetName, arg1) -- Pass targetName as potential first argument
			elseif commands[commandName] then -- Command might be for self
				commands[commandName](player, player, targetName or arg1) -- Pass targetName as arg1 if it exists
			end
		else
			for _, target in ipairs(targets) do
				commands[commandName](player, target, arg1)
			end
		end
	else
		-- Optionally notify player: SendMessage(player, "You do not have permission for this command.")
	end
end

-- Connect to RemoteEvent for command execution
local executeCommandRemote = ReplicatedStorage:FindFirstChild("execute")
if not executeCommandRemote then
	executeCommandRemote = Instance.new("RemoteEvent", ReplicatedStorage)
	executeCommandRemote.Name = "execute"
	-- print("Admin execute RemoteEvent created.")
end

executeCommandRemote.OnServerEvent:Connect(function(player, fullCommandString)
	if not player or type(fullCommandString) ~= "string" or not fullCommandString:match("^;") then
		return
	end

	local args = {}
	for word in fullCommandString:gmatch("[^%s]+") do
		table.insert(args, word)
	end

	local commandName = args[1] and args[1]:sub(2):lower() -- Remove ; and lowercase
	if not commandName or not commands[commandName] then
		-- print("Unknown command: " .. (commandName or "nil"))
		return
	end

	local targetName = args[2] -- Can be player name or first argument
	local remainingArgs = {}
	for i = 3, #args do
		table.insert(remainingArgs, args[i])
	end
	local arg1Combined = table.concat(remainingArgs, " ")
	if arg1Combined == "" then arg1Combined = nil end

	executeCommand(player, commandName, targetName, arg1Combined)
end)

print("Admin System with Data Persistence V2 Loaded.")

--[[
    REMINDER FOR LOCAL SCRIPTS (e.g., in StarterPlayerScripts for Fly, Mute, ChatColor):

    FlyEvent LocalScript Example:
    local player = game:GetService("Players").LocalPlayer
    local flyEvent = game:GetService("ReplicatedStorage"):WaitForChild("FlyEvent")
    local isFlying = false
    -- ... (flight control logic based on 'isFlying' toggled by flyEvent:FireClient)

    ClientMuteEvent / ClientChatColorEvent LocalScript Example:
    local player = game:GetService("Players").LocalPlayer
    local muteEvent = game:GetService("ReplicatedStorage"):WaitForChild("ClientMuteEvent")
    local chatColorEvent = game:GetService("ReplicatedStorage"):WaitForChild("ClientChatColorEvent")
    local TextChatService = game:GetService("TextChatService")

    muteEvent.OnClientEvent:Connect(function(muted)
        player:SetAttribute("IsLocallyMuted", muted) -- Store for chat intercept
    end)
    chatColorEvent.OnClientEvent:Connect(function(color)
        player:SetAttribute("LocalChatColor", color)
    end)

    if TextChatService then
        TextChatService.OnIncomingMessage = function(message: TextChatMessage)
            local props = Instance.new("TextChatMessageProperties")
            if message.TextSource then
                local sourcePlayer = Players:GetPlayerByUserId(message.TextSource.UserId)
                if sourcePlayer then
                    if sourcePlayer == player and player:GetAttribute("IsLocallyMuted") then
                        props.Text = "" -- Blank out own message if muted
                    end
                    if sourcePlayer == player and player:GetAttribute("LocalChatColor") then
                        local colorHex = player:GetAttribute("LocalChatColor"):ToHex()
                        props.PrefixText = string.format("<font color='#%s'>%s</font>", colorHex, message.PrefixText)
                    end
                end
            end
            return props
        end
    end
]]