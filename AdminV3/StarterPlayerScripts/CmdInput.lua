-- Services
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Cmdbar"
screenGui.ResetOnSpawn = false

-- Create the TextBox for commands
local commandBox = Instance.new("TextBox")
commandBox.Name = "Cmdtext"
commandBox.Size = UDim2.new(1, 0, 0, 30)
commandBox.Position = UDim2.new(0, 0, 0, 0)
commandBox.Text = ""
commandBox.ClearTextOnFocus = false
commandBox.TextScaled = true
commandBox.TextColor3 = Color3.new(1, 1, 1)
commandBox.BackgroundColor3 = Color3.new(0, 0, 0)
commandBox.BackgroundTransparency = 0.4
commandBox.Visible = false -- Start hidden

commandBox.Parent = screenGui
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Create or reference the RemoteEvent in ReplicatedStorage
local executeCommandRemote = replicatedStorage:FindFirstChild("execute")
if not executeCommandRemote then
	executeCommandRemote = Instance.new("RemoteEvent")
	executeCommandRemote.Name = "execute"
	executeCommandRemote.Parent = replicatedStorage
end

-- Toggle the command box visibility when ";" is pressed
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Semicolon then
		commandBox.Visible = not commandBox.Visible
		if commandBox.Visible then
			commandBox:CaptureFocus()
		else
			commandBox:ReleaseFocus()
		end
	end
end)

-- Handle command execution
commandBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local command = commandBox.Text
		commandBox.Text = ""
		commandBox.Visible = false

		-- Send the command to the server
		if executeCommandRemote then
			executeCommandRemote:FireServer(command)
		end
	end
end)