local Dropdown = {}
Dropdown.__index = Dropdown

local UserInputService = game:GetService("UserInputService")

function Dropdown.New(Options)
	local self = setmetatable({}, Dropdown)

	self.Name          = Options.Name or "Dropdown"
	self.Options       = Options.Options or {}
	self.Multi         = Options.Multi or false
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.OptionButtons = {}
	self.Open          = false

	if self.Multi then
		self.Value = {}
		local Default = Options.Default or {}
		if type(Default) == "table" then
			for _, V in ipairs(Default) do
				self.Value[V] = true
			end
		end
		if self.Flag and self.ConfigModule then
			local Saved = self.ConfigModule:Get(self.Flag)
			if type(Saved) == "table" then
				self.Value = Saved
			end
		end
	else
		self.Value = Options.Default or self.Options[1]
		if self.Flag and self.ConfigModule then
			local Saved = self.ConfigModule:Get(self.Flag)
			if Saved ~= nil then
				self.Value = Saved
			end
		end
	end

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	return self
end

function Dropdown:GetDisplayText()
	if not self.Multi then
		return tostring(self.Value)
	end
	local Selected = {}
	for _, Option in ipairs(self.Options) do
		if self.Value[Option] then
			table.insert(Selected, tostring(Option))
		end
	end
	if #Selected == 0 then
		return "None"
	elseif #Selected == #self.Options then
		return "All"
	elseif #Selected <= 2 then
		return table.concat(Selected, ", ")
	else
		return Selected[1] .. ", +" .. (#Selected - 1)
	end
end

function Dropdown:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Dropdown_" .. self.Name
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

	local HeaderRow = Instance.new("Frame")
	HeaderRow.Name = "HeaderRow"
	HeaderRow.Size = UDim2.new(1, 0, 0, 11)
	HeaderRow.BackgroundTransparency = 1
	HeaderRow.Parent = self.Frame

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Name = "NameLabel"
	self.NameLabel.Size = UDim2.new(1, 0, 1, 0)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name:upper()
	self.NameLabel.TextColor3 = T.Ghost
	self.NameLabel.TextSize = 9
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.Parent = HeaderRow

	if self.Multi then
		local MultiTag = Instance.new("TextLabel")
		MultiTag.Name = "MultiTag"
		MultiTag.Size = UDim2.new(0, 40, 1, 0)
		MultiTag.Position = UDim2.new(1, -40, 0, 0)
		MultiTag.BackgroundTransparency = 1
		MultiTag.Text = "MULTI"
		MultiTag.TextColor3 = T.Accent
		MultiTag.TextSize = 8
		MultiTag.Font = Enum.Font.GothamBold
		MultiTag.TextXAlignment = Enum.TextXAlignment.Right
		MultiTag.Parent = HeaderRow
	end

	self.SelectButton = Instance.new("TextButton")
	self.SelectButton.Name = "SelectButton"
	self.SelectButton.Size = UDim2.new(1, 0, 0, 28)
	self.SelectButton.BackgroundColor3 = T.Lift
	self.SelectButton.BorderSizePixel = 0
	self.SelectButton.Text = ""
	self.SelectButton.AutoButtonColor = false
	self.SelectButton.Parent = self.Frame

	local SelectCorner = Instance.new("UICorner")
	SelectCorner.CornerRadius = UDim.new(0, 3)
	SelectCorner.Parent = self.SelectButton

	self.SelectStroke = Instance.new("UIStroke")
	self.SelectStroke.Color = T.Wire
	self.SelectStroke.Thickness = 1
	self.SelectStroke.Parent = self.SelectButton

	self.SelectedLabel = Instance.new("TextLabel")
	self.SelectedLabel.Name = "SelectedLabel"
	self.SelectedLabel.Size = UDim2.new(1, -28, 1, 0)
	self.SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
	self.SelectedLabel.BackgroundTransparency = 1
	self.SelectedLabel.Text = self:GetDisplayText()
	self.SelectedLabel.TextColor3 = T.White
	self.SelectedLabel.TextSize = 11
	self.SelectedLabel.Font = Enum.Font.GothamBold
	self.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
	self.SelectedLabel.Parent = self.SelectButton

	self.ArrowLabel = Instance.new("TextLabel")
	self.ArrowLabel.Name = "Arrow"
	self.ArrowLabel.Size = UDim2.new(0, 20, 1, 0)
	self.ArrowLabel.Position = UDim2.new(1, -22, 0, 0)
	self.ArrowLabel.BackgroundTransparency = 1
	self.ArrowLabel.Text = "▲"
	self.ArrowLabel.TextColor3 = T.Ghost
	self.ArrowLabel.TextSize = 7
	self.ArrowLabel.Font = Enum.Font.GothamBold
	self.ArrowLabel.Parent = self.SelectButton

	self.OptionsList = Instance.new("Frame")
	self.OptionsList.Name = "OptionsList"
	self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
	self.OptionsList.Position = UDim2.new(0, 0, 0, 32)
	self.OptionsList.BackgroundColor3 = T.Deep
	self.OptionsList.BorderSizePixel = 0
	self.OptionsList.ClipsDescendants = true
	self.OptionsList.ZIndex = 10
	self.OptionsList.Visible = false
	self.OptionsList.Parent = self.Frame

	local ListCorner = Instance.new("UICorner")
	ListCorner.CornerRadius = UDim.new(0, 3)
	ListCorner.Parent = self.OptionsList

	local ListStroke = Instance.new("UIStroke")
	ListStroke.Color = T.Wire
	ListStroke.Thickness = 1
	ListStroke.Parent = self.OptionsList

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.FillDirection = Enum.FillDirection.Vertical
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = self.OptionsList

	self.OptionButtons = {}

	for Index, Option in ipairs(self.Options) do
		local IsSelected = self.Multi and self.Value[Option] or (not self.Multi and self.Value == Option)

		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = "Option_" .. tostring(Option)
		OptionButton.Size = UDim2.new(1, 0, 0, 28)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = IsSelected and 0.92 or 1
		OptionButton.BorderSizePixel = 0
		OptionButton.Text = ""
		OptionButton.AutoButtonColor = false
		OptionButton.LayoutOrder = Index
		OptionButton.ZIndex = 11
		OptionButton.Parent = self.OptionsList

		local ActiveBar = Instance.new("Frame")
		ActiveBar.Name = "ActiveBar"
		ActiveBar.Size = UDim2.new(0, 2, 1, 0)
		ActiveBar.BackgroundColor3 = T.Accent
		ActiveBar.BorderSizePixel = 0
		ActiveBar.BackgroundTransparency = IsSelected and 0 or 1
		ActiveBar.ZIndex = 12
		ActiveBar.Parent = OptionButton

		local OptionLabel = Instance.new("TextLabel")
		OptionLabel.Name = "Label"
		OptionLabel.Size = UDim2.new(1, -36, 1, 0)
		OptionLabel.Position = UDim2.new(0, 12, 0, 0)
		OptionLabel.BackgroundTransparency = 1
		OptionLabel.Text = tostring(Option)
		OptionLabel.TextColor3 = IsSelected and T.White or T.Muted
		OptionLabel.TextSize = 11
		OptionLabel.Font = Enum.Font.GothamBold
		OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
		OptionLabel.ZIndex = 12
		OptionLabel.Parent = OptionButton

		if self.Multi then
			local CheckBox = Instance.new("Frame")
			CheckBox.Name = "CheckBox"
			CheckBox.Size = UDim2.new(0, 10, 0, 10)
			CheckBox.Position = UDim2.new(1, -18, 0.5, -5)
			CheckBox.BackgroundColor3 = IsSelected and T.Accent or T.Lift
			CheckBox.BorderSizePixel = 0
			CheckBox.ZIndex = 12
			CheckBox.Parent = OptionButton

			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(0, 2)
			CheckCorner.Parent = CheckBox

			local CheckStroke = Instance.new("UIStroke")
			CheckStroke.Color = IsSelected and T.Accent or T.Wire
			CheckStroke.Thickness = 1
			CheckStroke.Parent = CheckBox

			local CheckMark = Instance.new("TextLabel")
			CheckMark.Size = UDim2.new(1, 0, 1, 0)
			CheckMark.BackgroundTransparency = 1
			CheckMark.Text = "✓"
			CheckMark.TextColor3 = T.Void
			CheckMark.TextSize = 8
			CheckMark.Font = Enum.Font.GothamBold
			CheckMark.TextTransparency = IsSelected and 0 or 1
			CheckMark.ZIndex = 13
			CheckMark.Parent = CheckBox

			table.insert(self.OptionButtons, {
				Button    = OptionButton,
				Label     = OptionLabel,
				Bar       = ActiveBar,
				CheckBox  = CheckBox,
				CheckStroke = CheckStroke,
				CheckMark = CheckMark,
				Value     = Option,
			})
		else
			table.insert(self.OptionButtons, {
				Button = OptionButton,
				Label  = OptionLabel,
				Bar    = ActiveBar,
				Value  = Option,
			})
		end

		local ClickConn = OptionButton.MouseButton1Click:Connect(function()
			if self.Multi then
				self:ToggleOption(Option)
			else
				self:SetValue(Option)
				self:CloseList()
			end
		end)

		local EnterConn = OptionButton.MouseEnter:Connect(function()
			local Sel = self.Multi and self.Value[Option] or (not self.Multi and self.Value == Option)
			if not Sel then
				self.AnimateModule:Tween(OptionLabel, { TextColor3 = T.Bright }, "Snappy")
				self.AnimateModule:Tween(OptionButton, { BackgroundTransparency = 0.96 }, "Snappy")
			end
		end)

		local LeaveConn = OptionButton.MouseLeave:Connect(function()
			local Sel = self.Multi and self.Value[Option] or (not self.Multi and self.Value == Option)
			if not Sel then
				self.AnimateModule:Tween(OptionLabel, { TextColor3 = T.Muted }, "Snappy")
				self.AnimateModule:Tween(OptionButton, { BackgroundTransparency = 1 }, "Snappy")
			end
		end)

		table.insert(self.Connections, ClickConn)
		table.insert(self.Connections, EnterConn)
		table.insert(self.Connections, LeaveConn)
	end

	self.ListHeight = #self.Options * 28

	local ToggleConn = self.SelectButton.MouseButton1Click:Connect(function()
		if self.Open then
			self:CloseList()
		else
			self:OpenList()
		end
	end)

	local OutsideConn = UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			if self.Open then
				local Pos = self.OptionsList.AbsolutePosition
				local Size = self.OptionsList.AbsoluteSize
				local IPos = Input.Position
				if IPos.X < Pos.X or IPos.X > Pos.X + Size.X
					or IPos.Y < Pos.Y or IPos.Y > Pos.Y + Size.Y then
					self:CloseList()
				end
			end
		end
	end)

	table.insert(self.Connections, ToggleConn)
	table.insert(self.Connections, OutsideConn)
end

function Dropdown:OpenList()
	self.Open = true
	self.OptionsList.Visible = true
	self.OptionsList.Size = UDim2.new(1, 0, 0, 0)
	self.AnimateModule:Tween(self.OptionsList, { Size = UDim2.new(1, 0, 0, self.ListHeight) }, "Reveal")
	self.AnimateModule:Tween(self.ArrowLabel, { Rotation = 180 }, "Snappy")
	self.AnimateModule:Tween(self.SelectStroke, { Color = self.Theme.Bright }, "Snappy")
	self.AnimateModule:Tween(self.SelectButton, { BackgroundColor3 = self.Theme.Edge }, "Snappy")
end

function Dropdown:CloseList()
	self.Open = false
	self.AnimateModule:Tween(self.OptionsList, { Size = UDim2.new(1, 0, 0, 0) }, "Collapse")
	self.AnimateModule:Tween(self.ArrowLabel, { Rotation = 0 }, "Snappy")
	self.AnimateModule:Tween(self.SelectStroke, { Color = self.Theme.Wire }, "Snappy")
	self.AnimateModule:Tween(self.SelectButton, { BackgroundColor3 = self.Theme.Lift }, "Snappy")
	task.delay(0.35, function()
		if not self.Open then
			self.OptionsList.Visible = false
		end
	end)
end

function Dropdown:ToggleOption(Option)
	local T = self.Theme
	self.Value[Option] = not self.Value[Option]

	for _, Entry in ipairs(self.OptionButtons) do
		if Entry.Value == Option then
			local IsSelected = self.Value[Option]
			self.AnimateModule:Tween(Entry.Label, { TextColor3 = IsSelected and T.White or T.Muted }, "Snappy")
			self.AnimateModule:Tween(Entry.Button, { BackgroundTransparency = IsSelected and 0.92 or 1 }, "Snappy")
			self.AnimateModule:Tween(Entry.Bar, { BackgroundTransparency = IsSelected and 0 or 1 }, "Snappy")
			self.AnimateModule:Tween(Entry.CheckBox, { BackgroundColor3 = IsSelected and T.Accent or T.Lift }, "Snappy")
			self.AnimateModule:Tween(Entry.CheckStroke, { Color = IsSelected and T.Accent or T.Wire }, "Snappy")
			self.AnimateModule:Tween(Entry.CheckMark, { TextTransparency = IsSelected and 0 or 1 }, "Snappy")
		end
	end

	self.SelectedLabel.Text = self:GetDisplayText()

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value)
	end

	if self.Callback then
		local Selected = {}
		for _, Opt in ipairs(self.Options) do
			if self.Value[Opt] then
				table.insert(Selected, Opt)
			end
		end
		pcall(self.Callback, Selected)
	end
end

function Dropdown:SetValue(Value)
	local T = self.Theme
	self.Value = Value
	self.SelectedLabel.Text = self:GetDisplayText()

	for _, Entry in ipairs(self.OptionButtons) do
		local IsSelected = Entry.Value == Value
		self.AnimateModule:Tween(Entry.Label, { TextColor3 = IsSelected and T.White or T.Muted }, "Snappy")
		self.AnimateModule:Tween(Entry.Button, { BackgroundTransparency = IsSelected and 0.92 or 1 }, "Snappy")
		self.AnimateModule:Tween(Entry.Bar, { BackgroundTransparency = IsSelected and 0 or 1 }, "Snappy")
	end

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, Value)
	end

	if self.Callback then
		pcall(self.Callback, Value)
	end
end

function Dropdown:GetValue()
	if self.Multi then
		local Selected = {}
		for _, Opt in ipairs(self.Options) do
			if self.Value[Opt] then
				table.insert(Selected, Opt)
			end
		end
		return Selected
	end
	return self.Value
end

function Dropdown:SetOptions(NewOptions)
	self.Options = NewOptions
	for _, Entry in ipairs(self.OptionButtons) do
		Entry.Button:Destroy()
	end
	self.OptionButtons = {}
	for _, Conn in ipairs(self.Connections) do
		if Conn.Connected then Conn:Disconnect() end
	end
	self.Connections = {}
	self:Build(self.Frame.Parent)
end

function Dropdown:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Ghost
	self.SelectedLabel.TextColor3 = T.White
	self.ArrowLabel.TextColor3 = T.Ghost
	self.SelectButton.BackgroundColor3 = T.Lift
	self.SelectStroke.Color = T.Wire
	self.OptionsList.BackgroundColor3 = T.Deep
	for _, Entry in ipairs(self.OptionButtons) do
		local IsSelected = self.Multi and self.Value[Entry.Value] or (not self.Multi and self.Value == Entry.Value)
		Entry.Label.TextColor3 = IsSelected and T.White or T.Muted
		Entry.Bar.BackgroundColor3 = T.Accent
		if self.Multi and Entry.CheckBox then
			Entry.CheckBox.BackgroundColor3 = IsSelected and T.Accent or T.Lift
			Entry.CheckStroke.Color = IsSelected and T.Accent or T.Wire
		end
	end
end

function Dropdown:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Dropdown
