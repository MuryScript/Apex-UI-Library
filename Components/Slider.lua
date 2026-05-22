local Slider = {}
Slider.__index = Slider

local UserInputService = game:GetService("UserInputService")

function Slider.New(Options)
	local self = setmetatable({}, Slider)

	self.Name          = Options.Name or "Slider"
	self.Min           = Options.Min or 0
	self.Max           = Options.Max or 100
	self.Increment     = Options.Increment or 1
	self.Unit          = Options.Unit or ""
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Dragging      = false

	self.Value = Options.Default or self.Min

	if self.Flag and self.ConfigModule then
		local Saved = self.ConfigModule:Get(self.Flag)
		if Saved ~= nil then
			self.Value = math.clamp(Saved, self.Min, self.Max)
		end
	end

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	return self
end

function Slider:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Slider_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 52)
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 6)
	Padding.PaddingBottom = UDim.new(0, 6)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingRight = UDim.new(0, 2)
	Padding.Parent = self.Frame

	local TopRow = Instance.new("Frame")
	TopRow.Name = "TopRow"
	TopRow.Size = UDim2.new(1, 0, 0, 16)
	TopRow.BackgroundTransparency = 1
	TopRow.Parent = self.Frame

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, -50, 1, 0)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name
	self.NameLabel.TextColor3 = T.Bright
	self.NameLabel.TextSize = 12
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.Parent = TopRow

	self.ValueLabel = Instance.new("TextLabel")
	self.ValueLabel.Name = "ValueLabel"
	self.ValueLabel.Size = UDim2.new(0, 48, 1, 0)
	self.ValueLabel.Position = UDim2.new(1, -48, 0, 0)
	self.ValueLabel.BackgroundTransparency = 1
	self.ValueLabel.Text = tostring(self.Value) .. self.Unit
	self.ValueLabel.TextColor3 = T.Mid
	self.ValueLabel.TextSize = 10
	self.ValueLabel.Font = Enum.Font.GothamBold
	self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	self.ValueLabel.Parent = TopRow

	local TrackContainer = Instance.new("Frame")
	TrackContainer.Name = "TrackContainer"
	TrackContainer.Size = UDim2.new(1, 0, 0, 16)
	TrackContainer.Position = UDim2.new(0, 0, 0, 22)
	TrackContainer.BackgroundTransparency = 1
	TrackContainer.Parent = self.Frame

	self.Track = Instance.new("Frame")
	self.Track.Name = "Track"
	self.Track.Size = UDim2.new(1, 0, 0, 3)
	self.Track.Position = UDim2.new(0, 0, 0.5, -1)
	self.Track.BackgroundColor3 = T.Lift
	self.Track.BorderSizePixel = 0
	self.Track.Parent = TrackContainer

	local TrackStroke = Instance.new("UIStroke")
	TrackStroke.Color = T.Wire
	TrackStroke.Thickness = 1
	TrackStroke.Parent = self.Track

	local TickCount = 8
	for I = 1, TickCount - 1 do
		local Tick = Instance.new("Frame")
		Tick.Size = UDim2.new(0, 1, 1, 0)
		Tick.Position = UDim2.new(I / TickCount, 0, 0, 0)
		Tick.BackgroundColor3 = T.Edge
		Tick.BorderSizePixel = 0
		Tick.Parent = self.Track
	end

	self.Fill = Instance.new("Frame")
	self.Fill.Name = "Fill"
	self.Fill.Size = UDim2.new(0, 0, 1, 0)
	self.Fill.BackgroundColor3 = T.Accent
	self.Fill.BorderSizePixel = 0
	self.Fill.ZIndex = 2
	self.Fill.Parent = self.Track

	local FillGradient = Instance.new("UIGradient")
	FillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Ghost),
		ColorSequenceKeypoint.new(1, T.Bright),
	})
	FillGradient.Parent = self.Fill

	self.FillGradient = FillGradient

	self.Knob = Instance.new("Frame")
	self.Knob.Name = "Knob"
	self.Knob.Size = UDim2.new(0, 8, 0, 11)
	self.Knob.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Knob.Position = UDim2.new(0, 0, 0.5, 0)
	self.Knob.BackgroundColor3 = T.Deep
	self.Knob.BorderSizePixel = 0
	self.Knob.ZIndex = 3
	self.Knob.Parent = self.Track

	local KnobStroke = Instance.new("UIStroke")
	KnobStroke.Color = T.Bright
	KnobStroke.Thickness = 1
	KnobStroke.Parent = self.Knob

	self.KnobStroke = KnobStroke

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(0, 2)
	KnobCorner.Parent = self.Knob

	self.HitBox = Instance.new("TextButton")
	self.HitBox.Name = "HitBox"
	self.HitBox.Size = UDim2.new(1, 0, 1, 0)
	self.HitBox.BackgroundTransparency = 1
	self.HitBox.Text = ""
	self.HitBox.ZIndex = 4
	self.HitBox.Parent = TrackContainer

	local function GetValueFromInput(Input)
		local TrackPos = self.Track.AbsolutePosition.X
		local TrackSize = self.Track.AbsoluteSize.X
		local RelativeX = math.clamp(Input.Position.X - TrackPos, 0, TrackSize)
		local Pct = RelativeX / TrackSize
		local Raw = self.Min + (self.Max - self.Min) * Pct
		local Stepped = math.round(Raw / self.Increment) * self.Increment
		return math.clamp(Stepped, self.Min, self.Max)
	end

	local DownConn = self.HitBox.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			self.Dragging = true
			self:SetValue(GetValueFromInput(Input))
			self.AnimateModule:Tween(self.Knob, { Size = UDim2.new(0, 8, 0, 14) }, "Snappy")
			self.AnimateModule:Tween(self.ValueLabel, { TextColor3 = self.Theme.White }, "Snappy")
			self.AnimateModule:Tween(self.KnobStroke, { Color = self.Theme.White }, "Snappy")
		end
	end)

	local MoveConn = UserInputService.InputChanged:Connect(function(Input)
		if not self.Dragging then return end
		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then
			self:SetValue(GetValueFromInput(Input))
		end
	end)

	local UpConn = UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			if self.Dragging then
				self.Dragging = false
				self.AnimateModule:Tween(self.Knob, { Size = UDim2.new(0, 8, 0, 11) }, "Spring")
				self.AnimateModule:Tween(self.ValueLabel, { TextColor3 = self.Theme.Mid }, "Snappy")
				self.AnimateModule:Tween(self.KnobStroke, { Color = self.Theme.Bright }, "Snappy")
			end
		end
	end)

	table.insert(self.Connections, DownConn)
	table.insert(self.Connections, MoveConn)
	table.insert(self.Connections, UpConn)

	self:Refresh()
end

function Slider:SetValue(Value)
	self.Value = math.clamp(
		math.round(Value / self.Increment) * self.Increment,
		self.Min,
		self.Max
	)

	self:Refresh()

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	if self.Callback then
		pcall(self.Callback, self.Value)
	end
end

function Slider:Refresh()
	local Pct = (self.Value - self.Min) / (self.Max - self.Min)

	self.Fill.Size = UDim2.new(Pct, 0, 1, 0)
	self.Knob.Position = UDim2.new(Pct, 0, 0.5, 0)

	local ValueStr = tostring(math.round(self.Value * 100) / 100) .. self.Unit
	self.ValueLabel.Text = ValueStr
end

function Slider:GetValue()
	return self.Value
end

function Slider:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Bright
	self.ValueLabel.TextColor3 = T.Mid
	self.Track.BackgroundColor3 = T.Lift
	self.FillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Ghost),
		ColorSequenceKeypoint.new(1, T.Bright),
	})
	self.KnobStroke.Color = T.Bright
	self.Knob.BackgroundColor3 = T.Deep
end

function Slider:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Slider
