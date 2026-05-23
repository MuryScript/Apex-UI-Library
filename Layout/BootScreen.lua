local BootScreen = {}
BootScreen.__index = BootScreen

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local BootLines = {
	"INITIALIZING APEX RUNTIME...",
	"LOADING MODULE :: core/renderer",
	"LOADING MODULE :: core/input",
	"LOADING MODULE :: core/theme",
	"LOADING MODULE :: core/animate",
	"LOADING MODULE :: components/ui",
	"ATTACHING TO PROCESS...",
	"BYPASS ACTIVE // STEALTH MODE ON",
	"STATUS: READY",
}

function BootScreen.New(Options)
	local self = setmetatable({}, BootScreen)
	self.ScreenGui = Options.ScreenGui
	self.OnDone    = Options.OnDone or function() end
	self:Build()
	self:Play()
	return self
end

function BootScreen:Build()
	self.Frame = Instance.new("Frame")
	self.Frame.Name = "BootScreen"
	self.Frame.Size = UDim2.new(1, 0, 1, 0)
	self.Frame.BackgroundColor3 = Color3.fromHex("080809")
	self.Frame.BorderSizePixel = 0
	self.Frame.ZIndex = 9999
	self.Frame.Parent = self.ScreenGui

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(0, 300, 0, 0)
	Container.AutomaticSize = Enum.AutomaticSize.Y
	Container.Position = UDim2.new(0.5, -150, 0.5, -80)
	Container.BackgroundTransparency = 1
	Container.ZIndex = 9999
	Container.Parent = self.Frame

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.Padding = UDim.new(0, 3)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Container

	local Header = Instance.new("TextLabel")
	Header.Size = UDim2.new(1, 0, 0, 14)
	Header.BackgroundTransparency = 1
	Header.Text = "APEX UI // SYSTEM BOOT"
	Header.TextColor3 = Color3.fromHex("9898aa")
	Header.TextSize = 11
	Header.Font = Enum.Font.GothamBold
	Header.TextXAlignment = Enum.TextXAlignment.Left
	Header.LayoutOrder = 1
	Header.ZIndex = 9999
	Header.Parent = Container

	local ProgressContainer = Instance.new("Frame")
	ProgressContainer.Size = UDim2.new(1, 0, 0, 3)
	ProgressContainer.BackgroundColor3 = Color3.fromHex("18181d")
	ProgressContainer.BorderSizePixel = 0
	ProgressContainer.LayoutOrder = 2
	ProgressContainer.ZIndex = 9999
	ProgressContainer.Parent = Container

	local ProgressStroke = Instance.new("UIStroke")
	ProgressStroke.Color = Color3.fromHex("32323e")
	ProgressStroke.Thickness = 1
	ProgressStroke.Parent = ProgressContainer

	self.ProgressBar = Instance.new("Frame")
	self.ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	self.ProgressBar.BackgroundColor3 = Color3.fromHex("d4d4e0")
	self.ProgressBar.BorderSizePixel = 0
	self.ProgressBar.ZIndex = 9999
	self.ProgressBar.Parent = ProgressContainer

	local Spacer = Instance.new("Frame")
	Spacer.Size = UDim2.new(1, 0, 0, 6)
	Spacer.BackgroundTransparency = 1
	Spacer.LayoutOrder = 3
	Spacer.Parent = Container

	self.LinesContainer = Instance.new("Frame")
	self.LinesContainer.Name = "Lines"
	self.LinesContainer.Size = UDim2.new(1, 0, 0, 0)
	self.LinesContainer.AutomaticSize = Enum.AutomaticSize.Y
	self.LinesContainer.BackgroundTransparency = 1
	self.LinesContainer.LayoutOrder = 4
	self.LinesContainer.ZIndex = 9999
	self.LinesContainer.Parent = Container

	local LinesLayout = Instance.new("UIListLayout")
	LinesLayout.FillDirection = Enum.FillDirection.Vertical
	LinesLayout.Padding = UDim.new(0, 3)
	LinesLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LinesLayout.Parent = self.LinesContainer

	self.Container = Container
end

function BootScreen:AddLine(Text, Index, Total)
	local IsLast = Index == Total

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 12)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = Index
	Row.ZIndex = 9999
	Row.Parent = self.LinesContainer

	local Arrow = Instance.new("TextLabel")
	Arrow.Size = UDim2.new(0, 12, 1, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Text = ">"
	Arrow.TextColor3 = Color3.fromHex("272730")
	Arrow.TextSize = 9
	Arrow.Font = Enum.Font.GothamBold
	Arrow.ZIndex = 9999
	Arrow.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -14, 1, 0)
	Label.Position = UDim2.new(0, 14, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = IsLast and Color3.fromHex("eeeef4") or Color3.fromHex("4a4a5a")
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 9999
	Label.Parent = Row

	Label.TextTransparency = 1
	TweenService:Create(Label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0,
	}):Play()

	local Pct = Index / Total
	TweenService:Create(self.ProgressBar, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(Pct, 0, 1, 0),
	}):Play()
end

function BootScreen:Play()
	local Total = #BootLines
	local Index = 0

	local function Next()
		if Index >= Total then
			task.wait(0.3)
			self:Dismiss()
			return
		end
		Index = Index + 1
		self:AddLine(BootLines[Index], Index, Total)
		task.delay(0.16 + math.random() * 0.12, Next)
	end

	task.delay(0.2, Next)
end

function BootScreen:Dismiss()
	TweenService:Create(self.Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()

	for _, Child in ipairs(self.Frame:GetDescendants()) do
		if Child:IsA("TextLabel") then
			TweenService:Create(Child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 1,
			}):Play()
		end
	end

	task.delay(0.5, function()
		self.Frame:Destroy()
		self.OnDone()
	end)
end

return BootScreen
