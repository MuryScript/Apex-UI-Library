local TextInput = {}
TextInput.__index = TextInput

function TextInput.New(Options)
	local self = setmetatable({}, TextInput)

	self.Name          = Options.Name or "TextInput"
	self.Placeholder   = Options.Placeholder or "Enter text..."
	self.Value         = Options.Default or ""
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Focused       = false

	if self.Flag and self.ConfigModule then
		local Saved = self.ConfigModule:Get(self.Flag)
		if Saved ~= nil then
			self.Value = tostring(Saved)
		end
	end

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	return self
end

function TextInput:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "TextInput_" .. self.Name
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

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, 0, 0, 11)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name:upper()
	self.NameLabel.TextColor3 = T.Ghost
	self.NameLabel.TextSize = 9
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.Parent = self.Frame

	self.InputContainer = Instance.new("Frame")
	self.InputContainer.Name = "InputContainer"
	self.InputContainer.Size = UDim2.new(1, 0, 0, 30)
	self.InputContainer.BackgroundColor3 = T.Lift
	self.InputContainer.BorderSizePixel = 0
	self.InputContainer.Parent = self.Frame

	local ContainerCorner = Instance.new("UICorner")
	ContainerCorner.CornerRadius = UDim.new(0, 3)
	ContainerCorner.Parent = self.InputContainer

	self.InputStroke = Instance.new("UIStroke")
	self.InputStroke.Color = T.Wire
	self.InputStroke.Thickness = 1
	self.InputStroke.Parent = self.InputContainer

	self.TextBox = Instance.new("TextBox")
	self.TextBox.Name = "TextBox"
	self.TextBox.Size = UDim2.new(1, -20, 1, 0)
	self.TextBox.Position = UDim2.new(0, 10, 0, 0)
	self.TextBox.BackgroundTransparency = 1
	self.TextBox.Text = self.Value
	self.TextBox.PlaceholderText = self.Placeholder
	self.TextBox.TextColor3 = T.White
	self.TextBox.PlaceholderColor3 = T.Ghost
	self.TextBox.TextSize = 11
	self.TextBox.Font = Enum.Font.GothamBold
	self.TextBox.TextXAlignment = Enum.TextXAlignment.Left
	self.TextBox.ClearTextOnFocus = false
	self.TextBox.Parent = self.InputContainer

	local ClearButton = Instance.new("TextButton")
	ClearButton.Name = "ClearButton"
	ClearButton.Size = UDim2.new(0, 20, 1, 0)
	ClearButton.Position = UDim2.new(1, -20, 0, 0)
	ClearButton.BackgroundTransparency = 1
	ClearButton.Text = "✕"
	ClearButton.TextColor3 = T.Ghost
	ClearButton.TextSize = 9
	ClearButton.Font = Enum.Font.GothamBold
	ClearButton.Visible = self.Value ~= ""
	ClearButton.Parent = self.InputContainer

	self.ClearButton = ClearButton

	local FocusConn = self.TextBox.Focused:Connect(function()
		self.Focused = true
		self.AnimateModule:Tween(self.InputStroke, { Color = self.Theme.Accent }, "Snappy")
		self.AnimateModule:Tween(self.InputContainer, { BackgroundColor3 = self.Theme.Edge }, "Snappy")
	end)

	local FocusLostConn = self.TextBox.FocusLost:Connect(function(EnterPressed)
		self.Focused = false
		self.AnimateModule:Tween(self.InputStroke, { Color = self.Theme.Wire }, "Snappy")
		self.AnimateModule:Tween(self.InputContainer, { BackgroundColor3 = self.Theme.Lift }, "Snappy")

		local NewValue = self.TextBox.Text
		if NewValue ~= self.Value then
			self.Value = NewValue
			ClearButton.Visible = NewValue ~= ""
			if self.Flag and self.ConfigModule then
				self.ConfigModule:Set(self.Flag, NewValue)
			end
			if self.Callback then
				pcall(self.Callback, NewValue, EnterPressed)
			end
		end
	end)

	local ChangedConn = self.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		ClearButton.Visible = self.TextBox.Text ~= ""
	end)

	local ClearConn = ClearButton.MouseButton1Click:Connect(function()
		self.TextBox.Text = ""
		self.Value = ""
		ClearButton.Visible = false
		if self.Flag and self.ConfigModule then
			self.ConfigModule:Set(self.Flag, "")
		end
		if self.Callback then
			pcall(self.Callback, "", false)
		end
	end)

	local EnterConn = self.InputContainer.MouseEnter:Connect(function()
		if not self.Focused then
			self.AnimateModule:Tween(self.InputStroke, { Color = self.Theme.Mid }, "Snappy")
		end
	end)

	local LeaveConn = self.InputContainer.MouseLeave:Connect(function()
		if not self.Focused then
			self.AnimateModule:Tween(self.InputStroke, { Color = self.Theme.Wire }, "Snappy")
		end
	end)

	table.insert(self.Connections, FocusConn)
	table.insert(self.Connections, FocusLostConn)
	table.insert(self.Connections, ChangedConn)
	table.insert(self.Connections, ClearConn)
	table.insert(self.Connections, EnterConn)
	table.insert(self.Connections, LeaveConn)
end

function TextInput:SetValue(Text)
	self.Value = tostring(Text)
	self.TextBox.Text = self.Value
	self.ClearButton.Visible = self.Value ~= ""
	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end
	if self.Callback then
		pcall(self.Callback, self.Value, false)
	end
end

function TextInput:GetValue()
	return self.Value
end

function TextInput:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Ghost
	self.InputContainer.BackgroundColor3 = T.Lift
	self.InputStroke.Color = T.Wire
	self.TextBox.TextColor3 = T.White
	self.TextBox.PlaceholderColor3 = T.Ghost
	self.ClearButton.TextColor3 = T.Ghost
end

function TextInput:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return TextInput
