local Tab = {}
Tab.__index = Tab

local SectionModule = nil

local function LazyLoad(Path)
	local Success, Result = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/MuryScript/Apex-UI-Library/main/" .. Path))()
	end)
	assert(Success, "[ApexUI] Failed to load: " .. Path)
	return Result
end

function Tab.New(Options)
	local self = setmetatable({}, Tab)

	self.Name          = Options.Name or "Tab"
	self.Icon          = Options.Icon or "◈"
	self.Theme         = Options.Theme
	self.AnimateModule = Options.AnimateModule
	self.UtilModule    = Options.UtilModule
	self.ConfigModule  = Options.ConfigModule
	self.NavButton     = Options.NavButton
	self.ActiveBar     = Options.ActiveBar
	self.Sections      = {}
	self.Connections   = {}

	SectionModule = SectionModule or LazyLoad("Components/Section.lua")

	self:Build(Options.Parent)
	return self
end

function Tab:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Tab_" .. self.Name
	self.Frame.Size = UDim2.new(1, 0, 1, 0)
	self.Frame.Position = UDim2.new(0, 0, 0, 0)
	self.Frame.BackgroundTransparency = 1
	self.Frame.Visible = false
	self.Frame.ClipsDescendants = true
	self.Frame.Parent = Parent

	self.ScrollFrame = Instance.new("ScrollingFrame")
	self.ScrollFrame.Name = "ScrollFrame"
	self.ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
	self.ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
	self.ScrollFrame.BackgroundTransparency = 1
	self.ScrollFrame.BorderSizePixel = 0
	self.ScrollFrame.ScrollBarThickness = 2
	self.ScrollFrame.ScrollBarImageColor3 = T.Wire
	self.ScrollFrame.ScrollBarImageTransparency = 0
	self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	self.ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	self.ScrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	self.ScrollFrame.Parent = self.Frame

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	Layout.Padding = UDim.new(0, 6)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = self.ScrollFrame

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 8)
	Padding.PaddingBottom = UDim.new(0, 8)
	Padding.PaddingLeft = UDim.new(0, 8)
	Padding.PaddingRight = UDim.new(0, 8)
	Padding.Parent = self.ScrollFrame
end

function Tab:AddSection(Options)
	Options = Options or {}

	local Section = SectionModule.New({
		Name          = Options.Name or "Section",
		Tag           = Options.Tag or nil,
		Parent        = self.ScrollFrame,
		Theme         = self.Theme,
		AnimateModule = self.AnimateModule,
		UtilModule    = self.UtilModule,
		ConfigModule  = self.ConfigModule,
		LayoutOrder   = #self.Sections + 1,
	})

	table.insert(self.Sections, Section)
	return Section
end

function Tab:ApplyTheme(T)
	self.Theme = T
	self.ScrollFrame.ScrollBarImageColor3 = T.Wire
	for _, Section in ipairs(self.Sections) do
		Section:ApplyTheme(T)
	end
end

function Tab:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Frame:Destroy()
end

return Tab
