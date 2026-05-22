local Button = {}
Button.__index = Button

function Button.New(Options)
	local self = setmetatable({}, Button)

	self.Name          = Options.Name or "Button"
	self.Sub           = Options.Sub or nil
	self.Variant       = Options.Variant or "Default"
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Locked        = false

	self:Build(Options.Parent)
	return self
end

function Button:GetVariantColor()
	local T = self.Theme
	local Variants = {
		Default = T.Bright,
		Ok      = T.Ok,
		Warn    = T.Warn,
		Err     = T.Err,
		Accent  = T.Accent,
	}
	return Variants[self.Variant] or T.Bright
end

function Button:Build(Parent)
	local T = self.Theme
	local Col = self:GetVariantColor()

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Button_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.Y
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 4)
	Padding.PaddingBottom = UDim.new(0, 4)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingRight = UDim.new(0, 2)
	Padding.Parent = self.Frame

	self.ButtonFrame = Instance.new("TextButton")
	self.ButtonFrame.Name = "ButtonFrame"
	self.ButtonFrame.Size = UDim2.new(1, 0, 0, 32)
	self.ButtonFrame.BackgroundColor3 = Col
	self.ButtonFrame.BackgroundTransparency = 0.88
	self.ButtonFrame.BorderSizePixel = 0
	self.ButtonFrame.Text = ""
	self.ButtonFrame.AutoButtonColor = false
	self.ButtonFrame.Parent = self.Frame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 3)
	BtnCorner.Parent = self.ButtonFrame

	self.BtnStroke = Instance.new("UIStroke")
	self.BtnStroke.Color = Col
	self.BtnStroke.Transparency = 0.6
	self.BtnStroke.Thickness = 1
	self.BtnStroke.Parent = self.ButtonFrame

	local LabelContainer = Instance.new("Frame")
	LabelContainer.Name = "LabelContainer"
	LabelContainer.Size = UDim2.new(1, 0, 1, 0)
	LabelContainer.BackgroundTransparency = 1
	LabelContainer.Parent = self.ButtonFrame

	local LabelLayout = Instance.new("UIListLayout")
	LabelLayout.FillDirection = Enum.FillDirection.Vertical
	LabelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	LabelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	LabelLayout.Padding = UDim.new(0, 2)
	LabelLayout.Parent = LabelContainer

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, 0, 0, 14)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name:upper()
	self.NameLabel.TextColor3 = Col
	self.NameLabel.TextSize = 11
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.LayoutOrder = 1
	self.NameLabel.Parent = LabelContainer

	if self.Sub then
		self.SubLabel = Instance.new("TextLabel")
		self.SubLabel.Name = "SubLabel"
		self.SubLabel.Size = UDim2.new(1, 0, 0, 10)
		self.SubLabel.BackgroundTransparency = 1
		self.SubLabel.Text = self.Sub
		self.SubLabel.TextColor3 = Col
		self.SubLabel.TextTransparency = 0.4
		self.SubLabel.TextSize = 9
		self.SubLabel.Font = Enum.Font.Gotham
		self.SubLabel.LayoutOrder = 2
		self.SubLabel.Parent = LabelContainer
	end

	local RippleFrame = Instance.new("Frame")
	RippleFrame.Name = "RippleFrame"
	RippleFrame.Size = UDim2.new(1, 0, 1, 0)
	RippleFrame.BackgroundTransparency = 1
	RippleFrame.ClipsDescendants = true
	RippleFrame.ZIndex = 2
	RippleFrame.Parent = self.ButtonFrame

	self.RippleFrame = RippleFrame

	local ClickConn = self.ButtonFrame.MouseButton1Click:Connect(function()
		if self.Locked then return end
		self.Locked = true
		self:Ripple()
		self.AnimateModule:Tween(self.ButtonFrame, { BackgroundTransparency = 0.7 }, "Snappy")
		self.AnimateModule:Tween(self.BtnStroke, { Transparency = 0.2 }, "Snappy")
		task.delay(0.15, function()
			self.AnimateModule:Tween(self.ButtonFrame, { BackgroundTransparency = 0.88 }, "Default")
			self.AnimateModule:Tween(self.BtnStroke, { Transparency = 0.6 }, "Default")
		end)
		if self.Callback then
			pcall(self.Callback)
		end
		task.delay(0.3, function()
			self.Locked = false
		end)
	end)

	local EnterConn = self.ButtonFrame.MouseEnter:Connect(function()
		if not self.Locked then
			self.AnimateModule:Tween(self.ButtonFrame, { BackgroundTransparency = 0.8 }, "Snappy")
			self.AnimateModule:Tween(self.BtnStroke, { Transparency = 0.4 }, "Snappy")
		end
	end)

	local LeaveConn = self.ButtonFrame.MouseLeave:Connect(function()
		if not self.Locked then
			self.AnimateModule:Tween(self.ButtonFrame, { BackgroundTransparency = 0.88 }, "Snappy")
			self.AnimateModule:Tween(self.BtnStroke, { Transparency = 0.6 }, "Snappy")
		end
	end)

	table.insert(self.Connections, ClickConn)
	table.insert(self.Connections, EnterConn)
	table.insert(self.Connections, LeaveConn)
end

function Button:Ripple()
	local Col = self:GetVariantColor()
	local Ripple = Instance.new("Frame")
	Ripple.Name = "Ripple"
	Ripple.Size = UDim2.new(0, 0, 0, 0)
	Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	Ripple.BackgroundColor3 = Col
	Ripple.BackgroundTransparency = 0.7
	Ripple.BorderSizePixel = 0
	Ripple.ZIndex = 3
	Ripple.Parent = self.RippleFrame

	local RippleCorner = Instance.new("UICorner")
	RippleCorner.CornerRadius = UDim.new(1, 0)
	RippleCorner.Parent = Ripple

	self.AnimateModule:Tween(Ripple, {
		Size = UDim2.new(1.5, 0, 3, 0),
		BackgroundTransparency = 1,
	}, "Fluid")

	task.delay(0.5, function()
		Ripple:Destroy()
	end)
end

function Button:SetLabel(Text)
	self.Name = Text
	self.NameLabel.Text = Text:upper()
end

function Button:ApplyTheme(T)
	self.Theme = T
	local Col = self:GetVariantColor()
	self.ButtonFrame.BackgroundColor3 = Col
	self.BtnStroke.Color = Col
	self.NameLabel.TextColor3 = Col
	if self.SubLabel then
		self.SubLabel.TextColor3 = Col
	end
end

function Button:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Button
