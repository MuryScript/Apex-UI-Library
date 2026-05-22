local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")

local IgnoredKeys = {
	[Enum.KeyCode.Unknown]   = true,
	[Enum.KeyCode.W]         = true,
	[Enum.KeyCode.A]         = true,
	[Enum.KeyCode.S]         = true,
	[Enum.KeyCode.D]         = true,
	[Enum.KeyCode.Space]     = true,
	[Enum.KeyCode.LeftShift] = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.LeftAlt]   = true,
}

local function KeyName(KeyCode)
	local Name = KeyCode.Name
	local Replacements = {
		LeftBracket    = "[",
		RightBracket   = "]",
		Semicolon      = ";",
		Quote          = "'",
		Backslash      = "\\",
		Comma          = ",",
		Period         = ".",
		Slash          = "/",
		BackQuote      = "`",
		Minus          = "-",
		Equals         = "=",
		RightShift     = "RSHFT",
		LeftShift      = "LSHFT",
		RightControl   = "RCTRL",
		LeftControl    = "LCTRL",
		RightAlt       = "RALT",
		LeftAlt        = "LALT",
		CapsLock       = "CAPS",
		Tab            = "TAB",
		Backspace      = "BKSP",
		Return         = "ENTER",
		Insert         = "INS",
		Delete         = "DEL",
		Home           = "HOME",
		End            = "END",
		PageUp         = "PGUP",
		PageDown       = "PGDN",
		Up             = "↑",
		Down           = "↓",
		Left           = "←",
		Right          = "→",
	}
	return Replacements[Name] or Name:upper()
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
			local Success, Result = pcall(function()
				return Enum.KeyCode[Saved]
			end)
			if Success and Result then
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

	local Padding = Instance
