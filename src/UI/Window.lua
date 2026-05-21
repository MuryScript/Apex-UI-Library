local Players = game:GetService("Players")
local Utility = require(script.Parent.Parent.Core.Utility)

local Window = {}
Window.__index = Window

function Window.new(Library, options)
	local self = setmetatable({}, Window)

	options = options or {}

	self.Library = Library
	self.Title = options.Title or "Apex"
	self.Tabs = {}
	self.CurrentTab = nil

	local theme = Library:GetTheme()

	self.ScreenGui = Utility:Create("ScreenGui", {
		Name = "Apex",
		ResetOnSpawn = false,
		Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	})

	self.Main = Utility:Create("Frame", {
		Size = UDim2.fromOffset(620, 420),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		Parent = self.ScreenGui
	})

	Utility:Create("UICorner", {
		CornerRadius = UDim.new(0, 12),
		Parent = self.Main
	})

	self.Sidebar = Utility:Create("Frame", {
		Size = UDim2.fromOffset(160, 420),
		BackgroundColor3 = theme.Surface,
		BorderSizePixel = 0,
		Parent = self.Main
	})

	self.Content = Utility:Create("Frame", {
		Size = UDim2.new(1, -160, 1, 0),
		Position = UDim2.fromOffset(160, 0),
		BackgroundTransparency = 1,
		Parent = self.Main
	})

	return self
end

function Window:CreateTab(name)
	local Tab = {
		Name = name,
		Window = self
	}

	local theme = self.Library:GetTheme()

	Tab.Button = Utility:Create("TextButton", {
		Size = UDim2.new(1, -10, 0, 34),
		Position = UDim2.fromOffset(5, #self.Tabs * 38 + 5),
		BackgroundColor3 = theme.SurfaceLight,
		Text = name,
		TextColor3 = theme.Text,
		BorderSizePixel = 0,
		Parent = self.Sidebar
	})

	Utility:Create("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = Tab.Button
	})

	Tab.Page = Utility:Create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		Visible = false,
		Parent = self.Content
	})

	Tab.Button.MouseButton1Click:Connect(function()
		if self.CurrentTab then
			self.CurrentTab.Page.Visible = false
		end

		self.CurrentTab = Tab
		Tab.Page.Visible = true
	end)

	table.insert(self.Tabs, Tab)

	if #self.Tabs == 1 then
		self.CurrentTab = Tab
		Tab.Page.Visible = true
	end

	return Tab
end

function Window:Destroy()
	self.ScreenGui:Destroy()
end

return Window
