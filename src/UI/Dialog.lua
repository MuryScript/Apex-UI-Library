local Players = game:GetService("Players")

local Dialog = {}
Dialog.__index = Dialog

function Dialog.new(_, options)
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexDialog"
	gui.Parent = playerGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(300, 180)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Parent = gui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 40)
	label.Text = options.Title or "Dialog"
	label.Parent = frame

	return setmetatable({}, Dialog)
end

return Dialog
