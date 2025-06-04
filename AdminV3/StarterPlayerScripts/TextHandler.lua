-- LocalScript in StarterPlayerScripts
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

-- RemoteEvents
local muteEvent = ReplicatedStorage:WaitForChild("mute")
local unmuteEvent = ReplicatedStorage:WaitForChild("unmute")
local chatColorEvent = ReplicatedStorage:WaitForChild("chatcolor")

-- Function to mute the player
local function mutePlayer()
	local chatWindowConfig = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
	if chatWindowConfig then
		chatWindowConfig.Enabled = false
	end
end

-- Function to unmute the player
local function unmutePlayer()
	local chatWindowConfig = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
	if chatWindowConfig then
		chatWindowConfig.Enabled = true
	end
end

-- Function to change chat color
local function changeChatColor(color)
	-- Update BubbleChatConfiguration
	local bubbleChatConfig = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")
	if bubbleChatConfig then
		bubbleChatConfig.TextColor3 = color
	end

	-- Update ChatInputBarConfiguration
	local chatInputBarConfig = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
	if chatInputBarConfig then
		chatInputBarConfig.TextColor3 = color
	end

	-- Update ChatWindowConfiguration
	local chatWindowConfig = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
	if chatWindowConfig then
		chatWindowConfig.TextColor3 = color
	end
end

-- Event Listeners
muteEvent.OnClientEvent:Connect(mutePlayer)
unmuteEvent.OnClientEvent:Connect(unmutePlayer)
chatColorEvent.OnClientEvent:Connect(changeChatColor)