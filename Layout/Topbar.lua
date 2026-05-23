local Topbar = {}
Topbar.__index = Topbar

function Topbar.New(Options)
	local self = setmetatable({}, Topbar)

	self.Title    = Options.Title or "ApexUI"
	self.SubTitle = Options.SubTitle or ""
	self.Theme    = Options.Theme
	self.Window   = Options.Window
	self.Animate  = Options.Animate
	self.Util     = Options.Util
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

	local StatusDot = Instance.new("Frame")
	StatusDot.Name = "StatusDot"
	StatusDot.Size = UDim2.new(0, 5, 0, 5)
	StatusDot.Position = UDim2.new(0, 12, 0.5, -2)
	StatusDot.BackgroundColor3 = T.Ok
	StatusDot.BorderSizePixel = 0
	StatusDot.Parent = self.Frame

	local DotCorner = Instance.new("UICorner")
	DotCorner.CornerRadius = UDim.new(1, 0)
	DotCorner.Parent = StatusDot

	self.StatusDot = StatusDot

	local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 0, 0, 14)
TitleLabel.AutomaticSize = Enum.AutomaticSize.X
TitleLabel.Position = UDim2.new(0, 22, 0.5, -7)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = ""
TitleLabel.TextColor3 = T.White
TitleLabel.TextSize = 11
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = self.Frame

self.TitleLabel = TitleLabel

local FullTitle = self.Title:upper()
local Index = 0
task.spawn(function()
	while Index < #FullTitle do
		Index = Index + 1
		TitleLabel.Text = FullTitle:sub(1, Index)
		task.wait(0.04)
	end
end)


	local Divider = Instance.new("TextLabel")
	Divider.Name = "Divider"
	Divider.Size = UDim2.new(0, 10, 0, 14)
	Divider.Position = UDim2.new(0, 22, 0.5, -7)
	Divider.AutomaticSize = Enum.AutomaticSize.X
	Divider.BackgroundTransparency = 1
	Divider.Text = " //"
	Divider.TextColor3 = T.Edge
	Divider.TextSize = 11
	Divider.Font = Enum.Font.GothamBold
	Divider.Parent = self.Frame

	self.Divider = Divider

	local SubTitleLabel = Instance.new("TextLabel")
	SubTitleLabel.Name = "SubTitleLabel"
	SubTitleLabel.Size = UDim2.new(0, 0, 0, 14)
	SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
	SubTitleLabel.Position = UDim2.new(0, 22, 0.5, -7)
	SubTitleLabel.BackgroundTransparency = 1
	SubTitleLabel.Text = self.SubTitle
	SubTitleLabel.TextColor3 = T.Ghost
	SubTitleLabel.TextSize = 10
	SubTitleLabel.Font = Enum.Font.Gotham
	SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubTitleLabel.Parent = self.Frame

	self.SubTitleLabel = SubTitleLabel

	local TopbarLayout = Instance.new("UIListLayout")
	TopbarLayout.FillDirection = Enum.FillDirection.Horizontal
	TopbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TopbarLayout.Padding = UDim.new(0, 4)
	TopbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TopbarLayout.Parent = self.Frame

	local TopbarPadding = Instance.new("UIPadding")
	TopbarPadding.PaddingLeft = UDim.new(0, 10)
	TopbarPadding.Parent = self.Frame

	TitleLabel.LayoutOrder = 2
	Divider.LayoutOrder = 3
	SubTitleLabel.LayoutOrder = 4

	local TimestampLabel = Instance.new("TextLabel")
	TimestampLabel.Name = "TimestampLabel"
	TimestampLabel.Size = UDim2.new(0, 60, 1, 0)
	TimestampLabel.Position = UDim2.new(1, -120, 0, 0)
	TimestampLabel.BackgroundTransparency = 1
	TimestampLabel.Text = "00:00:00"
	TimestampLabel.TextColor3 = T.Ghost
	TimestampLabel.TextSize = 9
	TimestampLabel.Font = Enum.Font.GothamBold
	TimestampLabel.TextXAlignment = Enum.TextXAlignment.Right
	TimestampLabel.ZIndex = 3
	TimestampLabel.Parent = self.Frame

	self.TimestampLabel = TimestampLabel

	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0, 20, 0, 20)
	CloseButton.Position = UDim2.new(1, -10, 0.5, -10)
	CloseButton.AnchorPoint = Vector2.new(1, 0.5)
	CloseButton.BackgroundColor3 = T.Err
	CloseButton.BackgroundTransparency = 0.8
	CloseButton.BorderSizePixel = 0
	CloseButton.Text = "✕"
	CloseButton.TextColor3 = T.Err
	CloseButton.TextSize = 9
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.AutoButtonColor = false
	CloseButton.ZIndex = 3
	CloseButton.Parent = self.Frame

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 3)
	CloseCorner.Parent = CloseButton

	self.CloseButton = CloseButton

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
	MinimizeButton.Position = UDim2.new(1, -34, 0.5, -10)
	MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
	MinimizeButton.BackgroundColor3 = T.Warn
	MinimizeButton.BackgroundTransparency = 0.8
	MinimizeButton.BorderSizePixel = 0
	MinimizeButton.Text = "—"
	MinimizeButton.TextColor3 = T.Warn
	MinimizeButton.TextSize = 9
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.AutoButtonColor = false
	MinimizeButton.ZIndex = 3
	MinimizeButton.Parent = self.Frame

	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, 3)
	MinimizeCorner.Parent = MinimizeButton

	self.MinimizeButton = MinimizeButton

	local CloseEnter = CloseButton.MouseEnter:Connect(function()
		self.Animate:Tween(CloseButton, { BackgroundTransparency = 0.4 }, "Snappy")
	end)

	local CloseLeave = CloseButton.MouseLeave:Connect(function()
		self.Animate:Tween(CloseButton, { BackgroundTransparency = 0.8 }, "Snappy")
	end)

	local CloseClick = CloseButton.MouseButton1Click:Connect(function()
		self.Window:Hide()
	end)

	local MinimizeEnter = MinimizeButton.MouseEnter:Connect(function()
		self.Animate:Tween(MinimizeButton, { BackgroundTransparency = 0.4 }, "Snappy")
	end)

	local MinimizeLeave = MinimizeButton.MouseLeave:Connect(function()
		self.Animate:Tween(MinimizeButton, { BackgroundTransparency = 0.8 }, "Snappy")
	end)

	local MinimizeClick = MinimizeButton.MouseButton1Click:Connect(function()
		self.Window:Toggle()
	end)

	table.insert(self.Connections, CloseEnter)
	table.insert(self.Connections, CloseLeave)
	table.insert(self.Connections, CloseClick)
	table.insert(self.Connections, MinimizeEnter)
	table.insert(self.Connections, MinimizeLeave)
	table.insert(self.Connections, MinimizeClick)

	self:StartClock()
end

function Topbar:StartClock()
	local RunService = game:GetService("RunService")
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
