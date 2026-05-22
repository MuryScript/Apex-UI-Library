local ColorPicker = {}
ColorPicker.__index = ColorPicker

local UserInputService = game:GetService("UserInputService")

function ColorPicker.New(Options)
	local self = setmetatable({}, ColorPicker)

	self.Name          = Options.Name or "ColorPicker"
	self.Value         = Options.Default or Color3.fromRGB(255, 255, 255)
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Open          = false
	self.DraggingSV    = false
	self.DraggingHue   = false

	if self.Flag and self.ConfigModule then
		local Saved = self.ConfigModule:Get(self.Flag)
		if type(Saved) == "table" and Saved.R then
			self.Value = Color3.new(Saved.R, Saved.G, Saved.B)
		end
	end

	self.H, self.S, self.V = Color3.toHSV(self.Value)

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, { R = self.Value.R, G = self.Value.G, B = self.Value.B })
	end

	return self
end

function ColorPicker:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "ColorPicker_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.Y
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.ClipsDescendants = false
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 6)
	Padding.PaddingBottom = UDim.new(0, 6)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingRight = UDim.new(0, 2)
	Padding.Parent = self.Frame

	local TopRow = Instance.new("Frame")
	TopRow.Name = "TopRow"
	TopRow.Size = UDim2.new(1, 0, 0, 24)
	TopRow.BackgroundTransparency = 1
	TopRow.Parent = self.Frame

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, -36, 1, 0)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name
	self.NameLabel.TextColor3 = T.Bright
	self.NameLabel.TextSize = 12
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.Parent = TopRow

	self.PreviewButton = Instance.new("TextButton")
	self.PreviewButton.Name = "PreviewButton"
	self.PreviewButton.Size = UDim2.new(0, 28, 0, 18)
	self.PreviewButton.Position = UDim2.new(1, -28, 0.5, -9)
	self.PreviewButton.BackgroundColor3 = self.Value
	self.PreviewButton.BorderSizePixel = 0
	self.PreviewButton.Text = ""
	self.PreviewButton.AutoButtonColor = false
	self.PreviewButton.Parent = TopRow

	local PreviewCorner = Instance.new("UICorner")
	PreviewCorner.CornerRadius = UDim.new(0, 3)
	PreviewCorner.Parent = self.PreviewButton

	self.PreviewStroke = Instance.new("UIStroke")
	self.PreviewStroke.Color = T.Wire
	self.PreviewStroke.Thickness = 1
	self.PreviewStroke.Parent = self.PreviewButton

	self.PickerFrame = Instance.new("Frame")
	self.PickerFrame.Name = "PickerFrame"
	self.PickerFrame.Size = UDim2.new(1, 0, 0, 0)
	self.PickerFrame.BackgroundColor3 = T.Deep
	self.PickerFrame.BorderSizePixel = 0
	self.PickerFrame.ClipsDescendants = true
	self.PickerFrame.ZIndex = 5
	self.PickerFrame.Visible = false
	self.PickerFrame.Parent = self.Frame

	local PickerCorner = Instance.new("UICorner")
	PickerCorner.CornerRadius = UDim.new(0, 3)
	PickerCorner.Parent = self.PickerFrame

	local PickerStroke = Instance.new("UIStroke")
	PickerStroke.Color = T.Wire
	PickerStroke.Thickness = 1
	PickerStroke.Parent = self.PickerFrame

	local PickerPadding = Instance.new("UIPadding")
	PickerPadding.PaddingTop = UDim.new(0, 8)
	PickerPadding.PaddingBottom = UDim.new(0, 8)
	PickerPadding.PaddingLeft = UDim.new(0, 8)
	PickerPadding.PaddingRight = UDim.new(0, 8)
	PickerPadding.Parent = self.PickerFrame

	local PickerLayout = Instance.new("UIListLayout")
	PickerLayout.FillDirection = Enum.FillDirection.Vertical
	PickerLayout.Padding = UDim.new(0, 6)
	PickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PickerLayout.Parent = self.PickerFrame

	self.SVPicker = Instance.new("ImageLabel")
	self.SVPicker.Name = "SVPicker"
	self.SVPicker.Size = UDim2.new(1, 0, 0, 120)
	self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.H, 1, 1)
	self.SVPicker.BorderSizePixel = 0
	self.SVPicker.Image = "rbxassetid://4155801252"
	self.SVPicker.ZIndex = 6
	self.SVPicker.LayoutOrder = 1
	self.SVPicker.Parent = self.PickerFrame

	local SVCorner = Instance.new("UICorner")
	SVCorner.CornerRadius = UDim.new(0, 3)
	SVCorner.Parent = self.SVPicker

	self.SVCursor = Instance.new("Frame")
	self.SVCursor.Name = "SVCursor"
	self.SVCursor.Size = UDim2.new(0, 8, 0, 8)
	self.SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	self.SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	self.SVCursor.BorderSizePixel = 0
	self.SVCursor.ZIndex = 7
	self.SVCursor.Parent = self.SVPicker

	local SVCursorCorner = Instance.new("UICorner")
	SVCursorCorner.CornerRadius = UDim.new(1, 0)
	SVCursorCorner.Parent = self.SVCursor

	local SVCursorStroke = Instance.new("UIStroke")
	SVCursorStroke.Color = Color3.new(1, 1, 1)
	SVCursorStroke.Thickness = 1.5
	SVCursorStroke.Parent = self.SVCursor

	self.HueBar = Instance.new("ImageLabel")
	self.HueBar.Name = "HueBar"
	self.HueBar.Size = UDim2.new(1, 0, 0, 12)
	self.HueBar.BackgroundColor3 = Color3.new(1, 1, 1)
	self.HueBar.BorderSizePixel = 0
	self.HueBar.Image = "rbxassetid://3641079124"
	self.HueBar.ZIndex = 6
	self.HueBar.LayoutOrder = 2
	self.HueBar.Parent = self.PickerFrame

	local HueCorner = Instance.new("UICorner")
	HueCorner.CornerRadius = UDim.new(0, 3)
	HueCorner.Parent = self.HueBar

	self.HueCursor = Instance.new("Frame")
	self.HueCursor.Name = "HueCursor"
	self.HueCursor.Size = UDim2.new(0, 4, 1, 4)
	self.HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	self.HueCursor.Position = UDim2.new(self.H, 0, 0.5, 0)
	self.HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
	self.HueCursor.BorderSizePixel = 0
	self.HueCursor.ZIndex = 7
	self.HueCursor.Parent = self.HueBar

	local HueCursorCorner = Instance.new("UICorner")
	HueCursorCorner.CornerRadius = UDim.new(0, 2)
	HueCursorCorner.Parent = self.HueCursor

	local HueCursorStroke = Instance.new("UIStroke")
	HueCursorStroke.Color = Color3.new(1, 1, 1)
	HueCursorStroke.Thickness = 1
	HueCursorStroke.Parent = self.HueCursor

	local BottomRow = Instance.new("Frame")
	BottomRow.Name = "BottomRow"
	BottomRow.Size = UDim2.new(1, 0, 0, 20)
	BottomRow.BackgroundTransparency = 1
	BottomRow.LayoutOrder = 3
	BottomRow.Parent = self.PickerFrame

	self.HexInput = Instance.new("TextBox")
	self.HexInput.Name = "HexInput"
	self.HexInput.Size = UDim2.new(1, -36, 1, 0)
	self.HexInput.BackgroundColor3 = T.Lift
	self.HexInput.BorderSizePixel = 0
	self.HexInput.Text = self:ToHex(self.Value)
	self.HexInput.TextColor3 = T.White
	self.HexInput.PlaceholderText = "HEX"
	self.HexInput.PlaceholderColor3 = T.Ghost
	self.HexInput.TextSize = 10
	self.HexInput.Font = Enum.Font.GothamBold
	self.HexInput.ClearTextOnFocus = false
	self.HexInput.Parent = BottomRow

	local HexCorner = Instance.new("UICorner")
	HexCorner.CornerRadius = UDim.new(0, 3)
	HexCorner.Parent = self.HexInput

	local HexStroke = Instance.new("UIStroke")
	HexStroke.Color = T.Wire
	HexStroke.Thickness = 1
	HexStroke.Parent = self.HexInput

	self.ColorPreview = Instance.new("Frame")
	self.ColorPreview.Name = "ColorPreview"
	self.ColorPreview.Size = UDim2.new(0, 28, 1, 0)
	self.ColorPreview.Position = UDim2.new(1, -28, 0, 0)
	self.ColorPreview.BackgroundColor3 = self.Value
	self.ColorPreview.BorderSizePixel = 0
	self.ColorPreview.Parent = BottomRow

	local PreviewCorner2 = Instance.new("UICorner")
	PreviewCorner2.CornerRadius = UDim.new(0, 3)
	PreviewCorner2.Parent = self.ColorPreview

	self.PickerHeight = 120 + 12 + 20 + 8 + 8 + 6 + 6

	local function UpdateFromSV(Input)
		local Pos = self.SVPicker.AbsolutePosition
		local Size = self.SVPicker.AbsoluteSize
		local X = math.clamp(Input.Position.X - Pos.X, 0, Size.X)
		local Y = math.clamp(Input.Position.Y - Pos.Y, 0, Size.Y)
		self.S = X / Size.X
		self.V = 1 - (Y / Size.Y)
		self:UpdateColor()
	end

	local function UpdateFromHue(Input)
		local Pos = self.HueBar.AbsolutePosition
		local Size = self.HueBar.AbsoluteSize
		local X = math.clamp(Input.Position.X - Pos.X, 0, Size.X)
		self.H = X / Size.X
		self:UpdateColor()
	end

	local SVDownConn = self.SVPicker.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			self.DraggingSV = true
			UpdateFromSV(Input)
		end
	end)

	local HueDownConn = self.HueBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			self.DraggingHue = true
			UpdateFromHue(Input)
		end
	end)

	local MoveConn = UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then
			if self.DraggingSV then UpdateFromSV(Input) end
			if self.DraggingHue then UpdateFromHue(Input) end
		end
	end)

	local UpConn = UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			self.DraggingSV = false
			self.DraggingHue = false
		end
	end)

	local HexConn = self.HexInput.FocusLost:Connect(function()
		local Hex = self.HexInput.Text:gsub("#", "")
		if #Hex == 6 then
			local Success, Col = pcall(function()
				return Color3.fromHex(Hex)
			end)
			if Success then
				self.H, self.S, self.V = Color3.toHSV(Col)
				self:UpdateColor()
			end
		end
		self.HexInput.Text = self:ToHex(self.Value)
	end)

	local ToggleConn = self.PreviewButton.MouseButton1Click:Connect(function()
		if self.Open then
			self:ClosePickerFrame()
		else
			self:OpenPickerFrame()
		end
	end)

	table.insert(self.Connections, SVDownConn)
	table.insert(self.Connections, HueDownConn)
	table.insert(self.Connections, MoveConn)
	table.insert(self.Connections, UpConn)
	table.insert(self.Connections, HexConn)
	table.insert(self.Connections, ToggleConn)

	self:RefreshCursors()
end

function ColorPicker:ToHex(Color)
	return string.format("%02X%02X%02X",
		math.round(Color.R * 255),
		math.round(Color.G * 255),
		math.round(Color.B * 255)
	)
end

function ColorPicker:UpdateColor()
	self.Value = Color3.fromHSV(self.H, self.S, self.V)
	self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.H, 1, 1)
	self.PreviewButton.BackgroundColor3 = self.Value
	self.ColorPreview.BackgroundColor3 = self.Value
	self.HexInput.Text = self:ToHex(self.Value)
	self:RefreshCursors()

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, { R = self.Value.R, G = self.Value.G, B = self.Value.B })
	end

	if self.Callback then
		pcall(self.Callback, self.Value)
	end
end

function ColorPicker:RefreshCursors()
	self.SVCursor.Position = UDim2.new(self.S, 0, 1 - self.V, 0)
	self.HueCursor.Position = UDim2.new(self.H, 0, 0.5, 0)
end

function ColorPicker:OpenPickerFrame()
	self.Open = true
	self.PickerFrame.Visible = true
	self.PickerFrame.Size = UDim2.new(1, 0, 0, 0)
	self.AnimateModule:Tween(self.PickerFrame, { Size = UDim2.new(1, 0, 0, self.PickerHeight) }, "Reveal")
	self.AnimateModule:Tween(self.PreviewStroke, { Color = self.Theme.Accent }, "Snappy")
end

function ColorPicker:ClosePickerFrame()
	self.Open = false
	self.AnimateModule:Tween(self.PickerFrame, { Size = UDim2.new(1, 0, 0, 0) }, "Collapse")
	self.AnimateModule:Tween(self.PreviewStroke, { Color = self.Theme.Wire }, "Snappy")
	task.delay(0.35, function()
		if not self.Open then
			self.PickerFrame.Visible = false
		end
	end)
end

function ColorPicker:SetValue(Color)
	self.Value = Color
	self.H, self.S, self.V = Color3.toHSV(Color)
	self.SVPicker.BackgroundColor3 = Color3.fromHSV(self.H, 1, 1)
	self.PreviewButton.BackgroundColor3 = Color
	self.ColorPreview.BackgroundColor3 = Color
	self.HexInput.Text = self:ToHex(Color)
	self:RefreshCursors()
	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, { R = Color.R, G = Color.G, B = Color.B })
	end
	if self.Callback then
		pcall(self.Callback, Color)
	end
end

function ColorPicker:GetValue()
	return self.Value
end

function ColorPicker:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Bright
	self.PreviewStroke.Color = T.Wire
	self.HexInput.BackgroundColor3 = T.Lift
	self.HexInput.TextColor3 = T.White
	self.HexInput.PlaceholderColor3 = T.Ghost
end

function ColorPicker:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return ColorPicker
