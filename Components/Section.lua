local Section = {}
Section.__index = Section

local ToggleModule = nil
local SliderModule = nil
local DropdownModule = nil
local KeybindModule = nil
local ButtonModule = nil
local TextInputModule = nil
local ColorPickerModule = nil
local LabelModule = nil
local SeparatorModule = nil

local function LazyLoad(Path)
	local Success, Result = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/MuryScript/Apex-UI-Library/main/" .. Path))()
	end)
	assert(Success, "[ApexUI] Failed to load: " .. Path)
	return Result
end

function Section.New(Options)
	local self = setmetatable({}, Section)

	self.Name          = Options.Name or "Section"
	self.Tag           = Options.Tag or nil
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.UtilModule    = Options.UtilModule
	self.ConfigModule  = Options.ConfigModule
	self.LayoutOrder   = Options.LayoutOrder or 1
	self.Elements      = {}
	self.Connections   = {}

	self:Build(Options.Parent)
	return self
end

function Section:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Section_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.Y
	self.Frame.BackgroundColor3 = T.Panel
	self.Frame.BorderSizePixel = 0
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = self.Frame

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = T.Edge
	Stroke.Thickness = 1
	Stroke.Parent = self.Frame

	local TLBracket = Instance.new("Frame")
	TLBracket.Name = "TLBracket"
	TLBracket.Size = UDim2.new(0, 7, 0, 7)
	TLBracket.Position = UDim2.new(0, 0, 0, 0)
	TLBracket.BackgroundTransparency = 1
	TLBracket.BorderSizePixel = 0
	TLBracket.Parent = self.Frame

	local TLH = Instance.new("Frame")
	TLH.Size = UDim2.new(1, 0, 0, 1)
	TLH.BackgroundColor3 = T.Ghost
	TLH.BorderSizePixel = 0
	TLH.Parent = TLBracket

	local TLV = Instance.new("Frame")
	TLV.Size = UDim2.new(0, 1, 1, 0)
	TLV.BackgroundColor3 = T.Ghost
	TLV.BorderSizePixel = 0
	TLV.Parent = TLBracket

	local TRBracket = Instance.new("Frame")
	TRBracket.Name = "TRBracket"
	TRBracket.Size = UDim2.new(0, 7, 0, 7)
	TRBracket.Position = UDim2.new(1, -7, 0, 0)
	TRBracket.BackgroundTransparency = 1
	TRBracket.BorderSizePixel = 0
	TRBracket.Parent = self.Frame

	local TRH = Instance.new("Frame")
	TRH.Size = UDim2.new(1, 0, 0, 1)
	TRH.BackgroundColor3 = T.Ghost
	TRH.BorderSizePixel = 0
	TRH.Parent = TRBracket

	local TRV = Instance.new("Frame")
	TRV.Size = UDim2.new(0, 1, 1, 0)
	TRV.Position = UDim2.new(1, -1, 0, 0)
	TRV.BackgroundColor3 = T.Ghost
	TRV.BorderSizePixel = 0
	TRV.Parent = TRBracket

	local BLBracket = Instance.new("Frame")
	BLBracket.Name = "BLBracket"
	BLBracket.Size = UDim2.new(0, 7, 0, 7)
	BLBracket.Position = UDim2.new(0, 0, 1, -7)
	BLBracket.BackgroundTransparency = 1
	BLBracket.BorderSizePixel = 0
	BLBracket.Parent = self.Frame

	local BLH = Instance.new("Frame")
	BLH.Size = UDim2.new(1, 0, 0, 1)
	BLH.Position = UDim2.new(0, 0, 1, -1)
	BLH.BackgroundColor3 = T.Ghost
	BLH.BorderSizePixel = 0
	BLH.Parent = BLBracket

	local BLV = Instance.new("Frame")
	BLV.Size = UDim2.new(0, 1, 1, 0)
	BLV.BackgroundColor3 = T.Ghost
	BLV.BorderSizePixel = 0
	BLV.Parent = BLBracket

	local BRBracket = Instance.new("Frame")
	BRBracket.Name = "BRBracket"
	BRBracket.Size = UDim2.new(0, 7, 0, 7)
	BRBracket.Position = UDim2.new(1, -7, 1, -7)
	BRBracket.BackgroundTransparency = 1
	BRBracket.BorderSizePixel = 0
	BRBracket.Parent = self.Frame

	local BRH = Instance.new("Frame")
	BRH.Size = UDim2.new(1, 0, 0, 1)
	BRH.Position = UDim2.new(0, 0, 1, -1)
	BRH.BackgroundColor3 = T.Ghost
	BRH.BorderSizePixel = 0
	BRH.Parent = BRBracket

	local BRV = Instance.new("Frame")
	BRV.Size = UDim2.new(0, 1, 1, 0)
	BRV.Position = UDim2.new(1, -1, 0, 0)
	BRV.BackgroundColor3 = T.Ghost
	BRV.BorderSizePixel = 0
	BRV.Parent = BRBracket

	if self.Name then
		local HeaderLabel = Instance.new("TextLabel")
		HeaderLabel.Name = "Header"
		HeaderLabel.Size = UDim2.new(1, -24, 0, 10)
		HeaderLabel.Position = UDim2.new(0, 12, 0, -5)
		HeaderLabel.BackgroundColor3 = T.Panel
		HeaderLabel.BorderSizePixel = 0
		HeaderLabel.Text = self.Name:upper()
		HeaderLabel.TextColor3 = T.Ghost
		HeaderLabel.TextSize = 9
		HeaderLabel.Font = Enum.Font.GothamBold
		HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
		HeaderLabel.ZIndex = 2
		HeaderLabel.Parent = self.Frame
	end

	if self.Tag then
		local TagLabel = Instance.new("TextLabel")
		TagLabel.Name = "Tag"
		TagLabel.Size = UDim2.new(0, 60, 0, 10)
		TagLabel.Position = UDim2.new(1, -72, 1, -5)
		TagLabel.BackgroundColor3 = T.Panel
		TagLabel.BorderSizePixel = 0
		TagLabel.Text = self.Tag
		TagLabel.TextColor3 = T.Edge
		TagLabel.TextSize = 8
		TagLabel.Font = Enum.Font.GothamBold
		TagLabel.TextXAlignment = Enum.TextXAlignment.Right
		TagLabel.ZIndex = 2
		TagLabel.Parent = self.Frame
	end

	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	self.Content.Size = UDim2.new(1, 0, 0, 0)
	self.Content.AutomaticSize = Enum.AutomaticSize.Y
	self.Content.BackgroundTransparency = 1
	self.Content.Parent = self.Frame

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.FillDirection = Enum.FillDirection.Vertical
	ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	ContentLayout.Padding = UDim.new(0, 0)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Parent = self.Content

	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.PaddingTop = UDim.new(0, 10)
	ContentPadding.PaddingBottom = UDim.new(0, 8)
	ContentPadding.PaddingLeft = UDim.new(0, 8)
	ContentPadding.PaddingRight = UDim.new(0, 8)
	ContentPadding.Parent = self.Content
end

function Section:AddToggle(Options)
	ToggleModule = ToggleModule or LazyLoad("Components/Toggle.lua")
	local Element = ToggleModule.New({
		Name          = Options.Name,
		Sub           = Options.Sub,
		Default       = Options.Default,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddSlider(Options)
	SliderModule = SliderModule or LazyLoad("Components/Slider.lua")
	local Element = SliderModule.New({
		Name          = Options.Name,
		Min           = Options.Min,
		Max           = Options.Max,
		Default       = Options.Default,
		Increment     = Options.Increment,
		Unit          = Options.Unit,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddDropdown(Options)
	DropdownModule = DropdownModule or LazyLoad("Components/Dropdown.lua")
	local Element = DropdownModule.New({
		Name          = Options.Name,
		Options       = Options.Options,
		Default       = Options.Default,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddKeybind(Options)
	KeybindModule = KeybindModule or LazyLoad("Components/Keybind.lua")
	local Element = KeybindModule.New({
		Name          = Options.Name,
		Default       = Options.Default,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddButton(Options)
	ButtonModule = ButtonModule or LazyLoad("Components/Button.lua")
	local Element = ButtonModule.New({
		Name          = Options.Name,
		Sub           = Options.Sub,
		Variant       = Options.Variant,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddTextInput(Options)
	TextInputModule = TextInputModule or LazyLoad("Components/TextInput.lua")
	local Element = TextInputModule.New({
		Name          = Options.Name,
		Placeholder   = Options.Placeholder,
		Default       = Options.Default,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddColorPicker(Options)
	ColorPickerModule = ColorPickerModule or LazyLoad("Components/ColorPicker.lua")
	local Element = ColorPickerModule.New({
		Name          = Options.Name,
		Default       = Options.Default,
		Flag          = Options.Flag,
		Callback      = Options.Callback,
		Parent        = self.Content,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddLabel(Options)
	LabelModule = LabelModule or LazyLoad("Components/Label.lua")
	local Element = LabelModule.New({
		Text          = Options.Text,
		Color         = Options.Color,
		Parent        = self.Content,
		Theme         = self.Theme,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:AddSeparator()
	SeparatorModule = SeparatorModule or LazyLoad("Components/Separator.lua")
	local Element = SeparatorModule.New({
		Parent        = self.Content,
		Theme         = self.Theme,
		LayoutOrder   = #self.Elements + 1,
	})
	table.insert(self.Elements, Element)
	return Element
end

function Section:ApplyTheme(T)
	self.Theme = T
	self.Frame.BackgroundColor3 = T.Panel
	for _, Element in ipairs(self.Elements) do
		if Element.ApplyTheme then
			Element:ApplyTheme(T)
		end
	end
end

function Section:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Section
