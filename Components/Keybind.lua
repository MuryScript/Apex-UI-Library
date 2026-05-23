local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")

local IgnoredKeys = {
	[Enum.KeyCode.Unknown]      = true,
	[Enum.KeyCode.W]            = true,
	[Enum.KeyCode.A]            = true,
	[Enum.KeyCode.S]            = true,
	[Enum.KeyCode.D]            = true,
	[Enum.KeyCode.Space]        = true,
	[Enum.KeyCode.LeftShift]    = true,
	[Enum.KeyCode.LeftControl]  = true,
	[Enum.KeyCode.LeftAlt]      = true,
}

local function KeyName(KeyCode)
	local Replacements = {
		LeftBracket   = "[",  RightBracket  = "]",
		Semicolon     = ";",  Quote         = "'",
		Backslash     = "\\", Comma         = ",",
		Period        = ".",  Slash         = "/",
		BackQuote     = "`",  Minus         = "-",
		Equals        = "=",  RightShift    = "RSHFT",
		LeftShift     = "LSHFT", RightControl = "RCTRL",
		LeftControl   = "LCTRL", RightAlt    = "RALT",
		LeftAlt       = "LALT",  CapsLock    = "CAPS",
		Tab           = "TAB",   Backspace   = "BKSP",
		Return        = "ENTER", Insert      = "INS",
		Delete        = "DEL",   Home        = "HOME",
		End           = "END",   PageUp      = "PGUP",
		PageDown      = "PGDN",  Up          = "↑",
		Down          = "↓",     Left        = "←",
		Right         = "→",
	}
	return Replacements[KeyCode.Name] or KeyCode.Name:upper()
end

function Keybind.New(Options)
	local self = setmetatable({}, Keybind)

	self.Name          = Options.Name or "Keybind"
	self.Value         = Options.Default or Enum.KeyCode.F
	self.Flag          = Options.Flag or nil
	self.Callback      = Options.Callback or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Connections   = {}
	self.Listening     = false

	if self.Flag and self.ConfigModule then
		local Saved = self.ConfigModule:Get(self.Flag)
		if Saved ~= nil then
			local Ok, Result = pcall(function()
				return Enum.KeyCode[Saved]
			end)
			if Ok and Result then
				self.Value = Result
			end
		end
	end

	self:Build(Options.Parent)

	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, self.Value.Name)
	end

	return self
end

function Keybind:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Keybind_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 36)
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop    = UDim.new(0, 6)
	Padding.PaddingBottom = UDim.new(0, 6)
	Padding.PaddingLeft   = UDim.new(0, 2)
	Padding.PaddingRight  = UDim.new(0, 2)
	Padding.Parent = self.Frame

	self.NameLabel = Instance.new("TextLabel")
	self.NameLabel.Size = UDim2.new(1, -70, 1, 0)
	self.NameLabel.BackgroundTransparency = 1
	self.NameLabel.Text = self.Name
	self.NameLabel.TextColor3 = T.Bright
	self.NameLabel.TextSize = 12
	self.NameLabel.Font = Enum.Font.GothamBold
	self.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.NameLabel.Parent = self.Frame

	self.KeyButton = Instance.new("TextButton")
	self.KeyButton.Size = UDim2.new(0, 62, 0, 22)
	self.KeyButton.Position = UDim2.new(1, -62, 0.5, -11)
	self.KeyButton.BackgroundColor3 = T.Lift
	self.KeyButton.BorderSizePixel = 0
	self.KeyButton.Text = KeyName(self.Value)
	self.KeyButton.TextColor3 = T.Mid
	self.KeyButton.TextSize = 10
	self.KeyButton.Font = Enum.Font.GothamBold
	self.KeyButton.AutoButtonColor = false
	self.KeyButton.Parent = self.Frame

	local KeyCorner = Instance.new("UICorner")
	KeyCorner.CornerRadius = UDim.new(0, 3)
	KeyCorner.Parent = self.KeyButton

	self.KeyStroke = Instance.new("UIStroke")
	self.KeyStroke.Color = T.Wire
	self.KeyStroke.Thickness = 1
	self.KeyStroke.Parent = self.KeyButton

	local ClickConn = self.KeyButton.MouseButton1Click:Connect(function()
		if self.Listening then
			self:StopListening()
		else
			self:StartListening()
		end
	end)

	local EnterConn = self.KeyButton.MouseEnter:Connect(function()
		if not self.Listening then
			self.AnimateModule:Tween(self.KeyStroke, { Color = self.Theme.Mid }, "Snappy")
			self.AnimateModule:Tween(self.KeyButton, { TextColor3 = self.Theme.Bright }, "Snappy")
		end
	end)

	local LeaveConn = self.KeyButton.MouseLeave:Connect(function()
		if not self.Listening then
			self.AnimateModule:Tween(self.KeyStroke, { Color = self.Theme.Wire }, "Snappy")
			self.AnimateModule:Tween(self.KeyButton, { TextColor3 = self.Theme.Mid }, "Snappy")
		end
	end)

	table.insert(self.Connections, ClickConn)
	table.insert(self.Connections, EnterConn)
	table.insert(self.Connections, LeaveConn)
end

function Keybind:StartListening()
	self.Listening = true
	self.KeyButton.Text = "···"
	self.AnimateModule:Tween(self.KeyButton, { TextColor3 = self.Theme.White }, "Snappy")
	self.AnimateModule:Tween(self.KeyStroke, { Color = self.Theme.Accent }, "Snappy")
	self.AnimateModule:Tween(self.KeyButton, { BackgroundColor3 = self.Theme.Edge }, "Snappy")

	local InputConn
	InputConn = UserInputService.InputBegan:Connect(function(Input, Processed)
		if not self.Listening then return end
		if Input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if IgnoredKeys[Input.KeyCode] then return end
		self:SetValue(Input.KeyCode)
		self:StopListening()
		InputConn:Disconnect()
	end)

	table.insert(self.Connections, InputConn)
end

function Keybind:StopListening()
	self.Listening = false
	self.KeyButton.Text = KeyName(self.Value)
	self.AnimateModule:Tween(self.KeyButton, { TextColor3 = self.Theme.Mid }, "Snappy")
	self.AnimateModule:Tween(self.KeyStroke, { Color = self.Theme.Wire }, "Snappy")
	self.AnimateModule:Tween(self.KeyButton, { BackgroundColor3 = self.Theme.Lift }, "Snappy")
end

function Keybind:SetValue(KeyCode)
	self.Value = KeyCode
	self.KeyButton.Text = KeyName(KeyCode)
	if self.Flag and self.ConfigModule then
		self.ConfigModule:Set(self.Flag, KeyCode.Name)
	end
	if self.Callback then
		pcall(self.Callback, KeyCode)
	end
end

function Keybind:GetValue()
	return self.Value
end

function Keybind:ApplyTheme(T)
	self.Theme = T
	self.NameLabel.TextColor3 = T.Bright
	self.KeyButton.BackgroundColor3 = T.Lift
	self.KeyButton.TextColor3 = T.Mid
	self.KeyStroke.Color = T.Wire
end

function Keybind:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Keybind
