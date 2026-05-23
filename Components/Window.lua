local Window = {}
Window.__index = Window

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local TabModule = nil
local TopbarModule = nil
local MobileModule = nil

local function LazyLoad(Path)
	local Success, Result = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/MuryScript/Apex-UI-Library/main/" .. Path))()
	end)
	assert(Success, "[ApexUI] Failed to load: " .. Path)
	return Result
end

function Window.New(Options)
	local self = setmetatable({}, Window)

	self.Title             = Options.Title or "ApexUI"
	self.SubTitle          = Options.SubTitle or ""
	self.Theme             = Options.Theme
	self.Size              = Options.Size or UDim2.new(0, 520, 0, 440)
	self.Position          = Options.Position or UDim2.new(0.5, -260, 0.5, -220)
	self.MinimizeKey       = Options.MinimizeKey or Enum.KeyCode.RightShift
	self.ScreenGui         = Options.ScreenGui
	self.ThemeModule       = Options.ThemeModule
	self.AnimateModule     = Options.AnimateModule
	self.UtilModule        = Options.UtilModule
	self.ConfigModule      = Options.ConfigModule
	self.NotificationModule = Options.NotificationModule

	self.Tabs              = {}
	self.ActiveTab         = nil
	self.Visible           = true
	self.Minimized         = false
	self.Connections       = {}

	TabModule    = TabModule    or LazyLoad("Components/Tab.lua")
	TopbarModule = TopbarModule or LazyLoad("Layout/Topbar.lua")
	MobileModule = MobileModule or LazyLoad("Layout/Mobile.lua")

	self:Build()
	self:BindKeys()

	if self.UtilModule:IsMobile() then
		MobileModule:Adapt(self)
	end

	return self
end

function Window:Build()
	local T = self.Theme

	self.Root = Instance.new("Frame")
	self.Root.Name = "ApexWindow"
	self.Root.Size = self.Size
	self.Root.Position = self.Position
	self.Root.BackgroundColor3 = T.Deep
	self.Root.BorderSizePixel = 0
	self.Root.ClipsDescendants = true
	self.Root.Parent = self.ScreenGui

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = self.Root

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = T.Edge
	Stroke.Thickness = 1
	Stroke.Parent = self.Root

	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow.BackgroundTransparency = 1
	Shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
	Shadow.Size = UDim2.new(1, 40, 1, 40)
	Shadow.ZIndex = 0
	Shadow.Image = "rbxassetid://6015897843"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.5
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
	Shadow.Parent = self.Root

	self.Topbar = TopbarModule.New({
	Parent    = self.Root,
	Title     = self.Title,
	SubTitle  = self.SubTitle,
	Theme     = T,
	Window    = self,
	Animate   = self.AnimateModule,
	Util      = self.UtilModule,
	ScreenGui = self.ScreenGui,
})


	self.NavBar = Instance.new("Frame")
	self.NavBar.Name = "NavBar"
	self.NavBar.Size = UDim2.new(0, 40, 1, -36)
	self.NavBar.Position = UDim2.new(0, 0, 0, 36)
	self.NavBar.BackgroundColor3 = T.Void
	self.NavBar.BorderSizePixel = 0
	self.NavBar.Parent = self.Root

	local NavStroke = Instance.new("UIStroke")
	NavStroke.Color = T.Edge
	NavStroke.Thickness = 1
	NavStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	NavStroke.Parent = self.NavBar

	local NavLayout = Instance.new("UIListLayout")
	NavLayout.FillDirection = Enum.FillDirection.Vertical
	NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	NavLayout.Padding = UDim.new(0, 2)
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Parent = self.NavBar

	local NavPadding = Instance.new("UIPadding")
	NavPadding.PaddingTop = UDim.new(0, 8)
	NavPadding.Parent = self.NavBar

	self.ContentArea = Instance.new("Frame")
	self.ContentArea.Name = "ContentArea"
	self.ContentArea.Size = UDim2.new(1, -40, 1, -36)
	self.ContentArea.Position = UDim2.new(0, 40, 0, 36)
	self.ContentArea.BackgroundColor3 = T.Panel
	self.ContentArea.BorderSizePixel = 0
	self.ContentArea.ClipsDescendants = true
	self.ContentArea.Parent = self.Root

	self.AnimateModule:Tween(self.Root, { BackgroundTransparency = 0 }, "Reveal")

	self.UtilModule:MakeDraggable(self.Root, self.Topbar.Frame)
end

function Window:AddTab(Options)
	Options = Options or {}
	local T = self.Theme

	local NavButton = Instance.new("TextButton")
	NavButton.Name = "Tab_" .. (Options.Name or "Tab")
	NavButton.Size = UDim2.new(1, 0, 0, 36)
	NavButton.BackgroundTransparency = 1
	NavButton.Text = Options.Icon or "◈"
	NavButton.TextColor3 = T.Ghost
	NavButton.TextSize = 14
	NavButton.Font = Enum.Font.GothamBold
	NavButton.BorderSizePixel = 0
	NavButton.LayoutOrder = #self.Tabs + 1
	NavButton.Parent = self.NavBar

	local ActiveBar = Instance.new("Frame")
	ActiveBar.Name = "ActiveBar"
	ActiveBar.Size = UDim2.new(0, 2, 0, 0)
	ActiveBar.Position = UDim2.new(0, 0, 0.5, 0)
	ActiveBar.AnchorPoint = Vector2.new(0, 0.5)
	ActiveBar.BackgroundColor3 = T.Accent
	ActiveBar.BorderSizePixel = 0
	ActiveBar.Parent = NavButton

	local Tab = TabModule.New({
		Name          = Options.Name or "Tab",
		Icon          = Options.Icon or "◈",
		Parent        = self.ContentArea,
		Theme         = T,
		AnimateModule = self.AnimateModule,
		UtilModule    = self.UtilModule,
		ConfigModule  = self.ConfigModule,
		NavButton     = NavButton,
		ActiveBar     = ActiveBar,
	})

	table.insert(self.Tabs, Tab)

	NavButton.MouseButton1Click:Connect(function()
		self:SelectTab(Tab)
	end)

	NavButton.MouseEnter:Connect(function()
		if self.ActiveTab ~= Tab then
			self.AnimateModule:Tween(NavButton, { TextColor3 = T.Mid }, "Snappy")
		end
	end)

	NavButton.MouseLeave:Connect(function()
		if self.ActiveTab ~= Tab then
			self.AnimateModule:Tween(NavButton, { TextColor3 = T.Ghost }, "Snappy")
		end
	end)

	if #self.Tabs == 1 then
		self:SelectTab(Tab)
	end

	return Tab
end

function Window:SelectTab(Tab)
	if self.ActiveTab == Tab then return end

	if self.ActiveTab then
		local PrevButton = self.ActiveTab.NavButton
		local PrevBar = self.ActiveTab.ActiveBar
		self.AnimateModule:Tween(PrevButton, { TextColor3 = self.Theme.Ghost }, "Snappy")
		self.AnimateModule:Tween(PrevBar, { Size = UDim2.new(0, 2, 0, 0) }, "Snappy")
		self.ActiveTab.Frame.Visible = false
	end

	self.ActiveTab = Tab
	Tab.Frame.Visible = true

	self.AnimateModule:Tween(Tab.NavButton, { TextColor3 = self.Theme.White }, "Snappy")
	self.AnimateModule:Tween(Tab.ActiveBar, { Size = UDim2.new(0, 2, 0, 18) }, "Spring")
	self.AnimateModule:SlideIn(Tab.Frame, "X", -12, 0.3)
end

function Window:BindKeys()
	local Connection = UserInputService.InputBegan:Connect(function(Input, Processed)
		if Processed then return end
		if Input.KeyCode == self.MinimizeKey then
			self:Toggle()
		end
	end)
	table.insert(self.Connections, Connection)
end

function Window:Toggle()
	if self.Visible then
		self:Hide()
	else
		self:Show()
	end
end

function Window:Show()
	self.Root.Visible = true
	self.Visible = true
	self.AnimateModule:Tween(self.Root, {
		Size = self.Size,
		BackgroundTransparency = 0,
	}, "Spring")
end

function Window:Hide()
	self.Visible = false
	local Tween = self.AnimateModule:Tween(self.Root, {
		Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 0),
		BackgroundTransparency = 1,
	}, "Collapse")
	Tween.Completed:Connect(function()
		if not self.Visible then
			self.Root.Visible = false
		end
	end)
end

function Window:ApplyTheme(T)
	self.Theme = T
	self.Root.BackgroundColor3 = T.Deep
	self.NavBar.BackgroundColor3 = T.Void
	self.ContentArea.BackgroundColor3 = T.Panel
	self.Topbar:ApplyTheme(T)
	for _, Tab in ipairs(self.Tabs) do
		Tab:ApplyTheme(T)
	end
end

function Window:Destroy()
	for _, Connection in ipairs(self.Connections) do
		if Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.Root:Destroy()
end

return Window
