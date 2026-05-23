local Topbar = {}
Topbar.__index = Topbar

local RunService = game:GetService("RunService")

function Topbar.New(Options)
	local self = setmetatable({}, Topbar)

	self.Title     = Options.Title or "ApexUI"
	self.SubTitle  = Options.SubTitle or ""
	self.Theme     = Options.Theme
	self.Window    = Options.Window
	self.Animate   = Options.Animate
	self.Util      = Options.Util
	self.ScreenGui = Options.ScreenGui
	self.Connections = {}

	self:Build(Options.Parent)
	return self
end

function Topbar:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Topbar"
	self.Frame.Size = UDim2.new(1, 0, 0, 36)
	self.Frame.BackgroundColor3 = T.Void
	self.Frame.BorderSizePixel = 0
	self.Frame.ZIndex = 2
	self.Frame.Parent = Parent

	local BottomLine = Instance.new("Frame")
	BottomLine.Name = "BottomLine"
	BottomLine.Size = UDim2.new(1, 0, 0, 1)
	BottomLine.Position = UDim2.new(0, 0, 1, -1)
	BottomLine.BackgroundColor3 = T.Edge
	BottomLine.BorderSizePixel = 0
	BottomLine.Parent = self.Frame

	self.StatusDot = Instance.new("Frame")
	self.StatusDot.Name = "StatusDot"
	self.StatusDot.Size = UDim2.new(0, 5, 0, 5)
	self.StatusDot.Position = UDim2.new(0, 12, 0.5, -2)
	self.StatusDot.BackgroundColor3 = T.Ok
	self.StatusDot.BorderSizePixel = 0
	self.StatusDot.Parent = self.Frame

	local DotCorner = Instance.new("UICorner")
	DotCorner.CornerRadius = UDim.new(1, 0)
	DotCorner.Parent = self.StatusDot

	local DotStroke = Instance.new("UIStroke")
	DotStroke.Color = T.Ok
	DotStroke.Thickness = 3
	DotStroke.Transparency = 0.6
	DotStroke.Parent = self.StatusDot

	local PulseConn = RunService.Heartbeat:Connect(function()
		local T2 = tick() % 2.5 / 2.5
		local Alpha = math.sin(T2 * math.pi)
		DotStroke.Transparency = 0.4 + (0.6 * (1 - Alpha))
	end)
	table.insert(self.Connections, PulseConn)

	local TitleRow = Instance.new("Frame")
	TitleRow.Name = "TitleRow"
	TitleRow.Size = UDim2.new(1, -100, 1, 0)
	TitleRow.Position = UDim2.new(0, 22, 0, 0)
	TitleRow.BackgroundTransparency = 1
	TitleRow.Parent = self.Frame

	local TitleLayout = Instance.new("UIListLayout")
	TitleLayout.FillDirection = Enum.FillDirection.Horizontal
	TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TitleLayout.Padding = UDim.new(0, 4)
	TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TitleLayout.Parent = TitleRow

	local TitlePadding = Instance.new("UIPadding")
	TitlePadding.PaddingLeft = UDim.new(0, 4)
	TitlePadding.Parent = TitleRow

	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Name = "TitleLabel"
	self.TitleLabel.Size = UDim2.new(0, 0, 1, 0)
	self.TitleLabel.AutomaticSize = Enum.AutomaticSize.X
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = ""
	self.TitleLabel.TextColor3 = T.White
	self.TitleLabel.TextSize = 11
	self.TitleLabel.Font = Enum.Font.GothamBold
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.LayoutOrder = 1
	self.TitleLabel.Parent = TitleRow

	local Divider = Instance.new("TextLabel")
	Divider.Name = "Divider"
	Divider.Size = UDim2.new(0, 0, 1, 0)
	Divider.AutomaticSize = Enum.AutomaticSize.X
	Divider.BackgroundTransparency = 1
	Divider.Text = "//"
	Divider.TextColor3 = T.Edge
	Divider.TextSize = 11
	Divider.Font = Enum.Font.GothamBold
	Divider.LayoutOrder = 2
	Divider.Parent = TitleRow

	self.Divider = Divider

	self.SubTitleLabel = Instance.new("TextLabel")
	self.SubTitleLabel.Name = "SubTitleLabel"
	self.SubTitleLabel.Size = UDim2.new(0, 0, 1, 0)
	self.SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
	self.SubTitleLabel.BackgroundTransparency = 1
	self.SubTitleLabel.Text = ""
	self.SubTitleLabel.TextColor3 = T.Ghost
	self.SubTitleLabel.TextSize = 10
	self.SubTitleLabel.Font = Enum.Font.Gotham
	self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.SubTitleLabel.LayoutOrder = 3
	self.SubTitleLabel.Parent = TitleRow

	self.TimestampLabel = Instance.new("TextLabel")
	self.TimestampLabel.Name = "TimestampLabel"
	self.TimestampLabel.Size = UDim2.new(0, 60, 1, 0)
	self.TimestampLabel.Position = UDim2.new(1, -120, 0, 0)
	self.TimestampLabel.BackgroundTransparency = 1
	self.TimestampLabel.Text = "00:00:00"
	self.TimestampLabel.TextColor3 = T.Ghost
	self.TimestampLabel.TextSize = 9
	self.TimestampLabel.Font = Enum.Font.GothamBold
	self.TimestampLabel.TextXAlignment = Enum.TextXAlignment.Right
	self.TimestampLabel.ZIndex = 3
	self.TimestampLabel.Parent = self.Frame

	self.CloseButton = Instance.new("TextButton")
	self.CloseButton.Name = "CloseButton"
	self.CloseButton.Size = UDim2.new(0, 20, 0, 20)
	self.CloseButton.Position = UDim2.new(1, -10, 0.5, -10)
	self.CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	self.CloseButton.BackgroundColor3 = T.Err
	self.CloseButton.BackgroundTransparency = 0.8
	self.CloseButton.BorderSizePixel = 0
	self.CloseButton.Text = "✕"
	self.CloseButton.TextColor3 = T.Err
	self.CloseButton.TextSize = 9
	self.CloseButton.Font = Enum.Font.GothamBold
	self.CloseButton.AutoButtonColor = false
	self.CloseButton.ZIndex = 3
	self.CloseButton.Parent = self.Frame

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 3)
	CloseCorner.Parent = self.CloseButton

	self.MinimizeButton = Instance.new("TextButton")
	self.MinimizeButton.Name = "MinimizeButton"
	self.MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
	self.MinimizeButton.Position = UDim2.new(1, -34, 0.5, -10)
	self.MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	self.MinimizeButton.BackgroundColor3 = T.Warn
	self.MinimizeButton.BackgroundTransparency = 0.8
	self.MinimizeButton.BorderSizePixel = 0
	self.MinimizeButton.Text = "—"
	self.MinimizeButton.TextColor3 = T.Warn
	self.MinimizeButton.TextSize = 9
	self.MinimizeButton.Font = Enum.Font.GothamBold
	self.MinimizeButton.AutoButtonColor = false
	self.MinimizeButton.ZIndex = 3
	self.MinimizeButton.Parent = self.Frame

	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, 3)
	MinimizeCorner.Parent = self.MinimizeButton

	local ScanlineOverlay = Instance.new("Frame")
	ScanlineOverlay.Name = "Scanlines"
	ScanlineOverlay.Size = UDim2.new(1, 0, 1, 0)
	ScanlineOverlay.BackgroundTransparency = 1
	ScanlineOverlay.BorderSizePixel = 0
	ScanlineOverlay.ZIndex = 999
	ScanlineOverlay.ClipsDescendants = true
	ScanlineOverlay.Parent = self.ScreenGui

	local ScanLine = Instance.new("Frame")
	ScanLine.Name = "ScanLine"
	ScanLine.Size = UDim2.new(1, 0, 0, 80)
	ScanLine.Position = UDim2.new(0, 0, 0, -80)
	ScanLine.BorderSizePixel = 0
	ScanLine.ZIndex = 999
	ScanLine.Parent = ScanlineOverlay

	local ScanGradient = Instance.new("UIGradient")
	ScanGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
		ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
	})
	ScanGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.97),
		NumberSequenceKeypoint.new(1, 1),
	})
	ScanGradient.Rotation = 90
	ScanGradient.Parent = ScanLine

	ScanLine.BackgroundColor3 = Color3.new(1, 1, 1)
	ScanLine.BackgroundTransparency = 0

	local ScanConn = RunService.Heartbeat:Connect(function()
		local MaxY = ScanlineOverlay.AbsoluteSize.Y
		local Y = ScanLine.Position.Y.Offset
		if Y > MaxY then
			ScanLine.Position = UDim2.new(0, 0, 0, -80)
		else
			ScanLine.Position = UDim2.new(0, 0, 0, Y + 1.5)
		end
	end)
	table.insert(self.Connections, ScanConn)

	local CloseEnter = self.CloseButton.MouseEnter:Connect(function()
		self.Animate:Tween(self.CloseButton, { BackgroundTransparency = 0.4 }, "Snappy")
	end)
	local CloseLeave = self.CloseButton.MouseLeave:Connect(function()
		self.Animate:Tween(self.CloseButton, { BackgroundTransparency = 0.8 }, "Snappy")
	end)
	local CloseClick = self.CloseButton.MouseButton1Click:Connect(function()
		self.Window:Hide()
	end)
	local MinEnter = self.MinimizeButton.MouseEnter:Connect(function()
		self.Animate:Tween(self.MinimizeButton, { BackgroundTransparency = 0.4 }, "Snappy")
	end)
	local MinLeave = self.MinimizeButton.MouseLeave:Connect(function()
		self.Animate:Tween(self.MinimizeButton, { BackgroundTransparency = 0.8 }, "Snappy")
	end)
	local MinClick = self.MinimizeButton.MouseButton1Click:Connect(function()
		self.Window:Toggle()
	end)

	table.insert(self.Connections, CloseEnter)
	table.insert(self.Connections, CloseLeave)
	table.insert(self.Connections, CloseClick)
	table.insert(self.Connections, MinEnter)
	table.insert(self.Connections, MinLeave)
	table.insert(self.Connections, MinClick)

	self:StartClock()
	self:StartTypewriter()
end

function Topbar:StartTypewriter()
	local FullTitle = self.Title:upper()
	local FullSub   = self.SubTitle
	task.spawn(function()
		for I = 1, #FullTitle do
			self.TitleLabel.Text = FullTitle:sub(1, I)
			task.wait(0.04)
		end
		task.wait(0.1)
		for I = 1, #FullSub do
			self.SubTitleLabel.Text = FullSub:sub(1, I)
			task.wait(0.03)
		end
	end)
end

function Topbar:StartClock()
	local ClockConn = RunService.Heartbeat:Connect(function()
		local T = os.date("*t")
		self.TimestampLabel.Text = string.format("%02d:%02d:%02d", T.hour, T.min, T.sec)
	end)
	table.insert(self.Connections, ClockConn)
end

function Topbar:SetTitle(Text)
	self.Title = Text
	self.TitleLabel.Text = Text:upper()
end

function Topbar:SetSubTitle(Text)
	self.SubTitle = Text
	self.SubTitleLabel.Text = Text
end

function Topbar:SetStatus(Ok)
	local Col = Ok and self.Theme.Ok or self.Theme.Err
	self.Animate:Tween(self.StatusDot, { BackgroundColor3 = Col }, "Snappy")
end

function Topbar:ApplyTheme(T)
	self.Theme = T
	self.Frame.BackgroundColor3 = T.Void
	self.TitleLabel.TextColor3 = T.White
	self.SubTitleLabel.TextColor3 = T.Ghost
	self.Divider.TextColor3 = T.Edge
	self.TimestampLabel.TextColor3 = T.Ghost
	self.CloseButton.BackgroundColor3 = T.Err
	self.CloseButton.TextColor3 = T.Err
	self.MinimizeButton.BackgroundColor3 = T.Warn
	self.MinimizeButton.TextColor3 = T.Warn
end

function Topbar:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Topbar
