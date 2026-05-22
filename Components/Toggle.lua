local Toggle = {}
Toggle.__index = Toggle

local UserInputService = game:GetService("UserInputService")

function Toggle.New(Options)
	local self = setmetatable({}, Toggle)

	self.Name          = Options.Name or "Toggle"
	self.Sub           = Options.Sub or nil
	self.Value         = Options.Default or false
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Locked        = false

	if self.Flag and self.ConfigModule then
		local Saved = self.ConfigModule:Get(self.Flag)
		if Saved ~= nil then
			self.Value = Saved
		end
	end

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	return self
end

function Toggle:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Toggle_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.Y
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 6)
	Padding.PaddingBottom = UDim.new(0, 6)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingRight = UDim.new(0, 2)
	Padding.Parent = self.Frame

	local Row = Instance.new("Frame")
	Row.Name = "Row"
	Row.Size = UDim2.new(1, 0, 0, 24)
	Row.BackgroundTransparency = 1
	Row.Parent = self.Frame

	self.LabelFrame = Instance.new("Frame")
	self.LabelFrame.Name = "LabelFrame"
	self.LabelFrame.Size = UDim2.new(1, -42, 1, 0)
	self.LabelFrame.BackgroundTransparency = 1
	self.LabelFrame.Parent = Row

	local LabelLayout = Instance.new("UIListLayout")
	LabelLayout.FillDirection = Enum.FillDirection.Vertical
	LabelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	LabelLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LabelLayout.Parent = self.LabelFrame

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, 0, 0, 14)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name
	self.NameLabel.TextColor3 = T.Bright
	self.NameLabel.TextSize = 12
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.LayoutOrder = 1
	self.NameLabel.Parent = self.LabelFrame

	if self.Sub then
		self.SubLabel = Instance.new("TextLabel")
		self.SubLabel.Name = "SubLabel"
		self.SubLabel.Size = UDim2.new(1, 0, 0, 11)
		self.SubLabel.BackgroundTransparency = 1
		self.SubLabel.Text = self.Sub
		self.SubLabel.TextColor3 = T.Ghost
		self.SubLabel.TextSize = 9
		self.SubLabel.Font = Enum.Font.Gotham
		self.SubLabel.TextXAlignment = Enum.TextXAlignment.Left
		self.SubLabel.LayoutOrder = 2
		self.SubLabel.Parent = self.LabelFrame
	end

	self.TrackFrame = Instance.new("Frame")
	self.TrackFrame.Name = "Track"
	self.TrackFrame.Size = UDim2.new(0, 32, 0, 14)
	self.TrackFrame.Position = UDim2.new(1, -34, 0.5, -7)
	self.TrackFrame.BackgroundColor3 = self.Value and T.Accent or T.Wire
	self.TrackFrame.BorderSizePixel = 0
	self.TrackFrame.Parent = Row

	local TrackCorner = Instance.new("UICorner")
	TrackCorner.CornerRadius = UDim.new(0, 2)
	TrackCorner.Parent = self.TrackFrame

	local TrackStroke = Instance.new("UIStroke")
	TrackStroke.Color = self.Value and T.Accent or T.Wire
	TrackStroke.Thickness = 1
	TrackStroke.Parent = self.TrackFrame

	self.TrackStroke = TrackStroke

	self.Knob = Instance.new("Frame")
	self.Knob.Name = "Knob"
	self.Knob.Size = UDim2.new(0, 8, 0, 8)
	self.Knob.Position = self.Value and UDim2.new(0, 18, 0.5, -4) or UDim2.new(0, 3, 0.5, -4)
	self.Knob.BackgroundColor3 = self.Value and T.White or T.Ghost
	self.Knob.BorderSizePixel = 0
	self.Knob.Parent = self.TrackFrame

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(0, 2)
	KnobCorner.Parent = self.Knob

	self.HitBox = Instance.new("TextButton")
	self.HitBox.Name = "HitBox"
	self.HitBox.Size = UDim2.new(1, 0, 1, 0)
	self.HitBox.BackgroundTransparency = 1
	self.HitBox.Text = ""
	self.HitBox.Parent = Row

	local HoverHighlight = Instance.new("Frame")
	HoverHighlight.Name = "HoverHighlight"
	HoverHighlight.Size = UDim2.new(1, 0, 1, 0)
	HoverHighlight.BackgroundColor3 = T.White
	HoverHighlight.BackgroundTransparency = 1
	HoverHighlight.BorderSizePixel = 0
	HoverHighlight.ZIndex = 0
	HoverHighlight.Parent = Row

	self.HoverHighlight = HoverHighlight

	local HitConn = self.HitBox.MouseButton1Click:Connect(function()
		self:SetValue(not self.Value)
	end)

	local EnterConn = self.HitBox.MouseEnter:Connect(function()
		self.AnimateModule:Tween(HoverHighlight, { BackgroundTransparency = 0.97 }, "Snappy")
	end)

	local LeaveConn = self.HitBox.MouseLeave:Connect(function()
		self.AnimateModule:Tween(HoverHighlight, { BackgroundTransparency = 1 }, "Snappy")
	end)

	table.insert(self.Connections, HitConn)
	table.insert(self.Connections, EnterConn)
	table.insert(self.Connections, LeaveConn)

	self:Refresh()
end

function Toggle:SetValue(Value)
	if self.Locked then return end
	self.Locked = true

	self.Value = Value
	self:Refresh()

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, Value)
	end

	if self.Callback then
		pcall(self.Callback, Value)
	end

	task.delay(0.12, function()
		self.Locked = false
	end)
end

function Toggle:Refresh()
	local T = self.Theme
	local On = self.Value

	self.AnimateModule:Tween(self.TrackFrame, {
		BackgroundColor3 = On and T.Accent or T.Lift,
	}, "Snappy")

	self.AnimateModule:Tween(self.TrackStroke, {
		Color = On and T.Accent or T.Wire,
	}, "Snappy")

	self.AnimateModule:Tween(self.Knob, {
		Position = On and UDim2.new(0, 18, 0.5, -4) or UDim2.new(0, 3, 0.5, -4),
		BackgroundColor3 = On and T.White or T.Ghost,
	}, "Spring")
end

function Toggle:GetValue()
	return self.Value
end

function Toggle:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Bright
	if self.SubLabel then
		self.SubLabel.TextColor3 = T.Ghost
	end
	self:Refresh()
end

function Toggle:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Toggle
