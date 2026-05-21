local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Notification = {}
Notification.__index = Notification

function Notification.new(Library, options)
	options = options or {}

	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexNotifications"
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(280, 60)
	frame.Position = UDim2.new(1, 0, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.Parent = gui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = options.Title or "Notification"
	label.TextColor3 = Color3.new(1,1,1)
	label.Parent = frame

	TweenService:Create(frame, TweenInfo.new(0.3), {
		Position = UDim2.new(1, -300, 0, 20)
	}):Play()

	task.delay(options.Duration or 3, function()
		gui:Destroy()
	end)

	return setmetatable({}, Notification)
end

return Notification
