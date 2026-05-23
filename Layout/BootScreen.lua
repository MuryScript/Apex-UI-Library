local BootScreen = {}
BootScreen.__index = BootScreen

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

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
	self.Frame.Position = UDim2.new(0, 0, 0, 0)
	self.Frame.AnchorPoint = Vector2.new(0, 0)
	self.Frame.BackgroundColor3 = Color3.fromHex("080809")
	self.Frame.BorderSizePixel = 0
	self.Frame.ZIndex = 99999
	self.Frame.Parent = self.ScreenGui

	local ScanLine = Instance.new("Frame")
	ScanLine.Name = "ScanLine"
	ScanLine.Size = UDim2.new(1, 0, 0, 80)
	ScanLine.Position = UDim2.new(0, 0, 0, -80)
	ScanLine.BorderSizePixel = 0
	ScanLine.BackgroundColor3 = Color3.new(1, 1, 1)
	ScanLine.ZIndex = 99999
	ScanLine.Parent = self.Frame

	local ScanGradient = Instance.new("UIGradient")
	ScanGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.96),
		NumberSequenceKeypoint.new(1, 1),
	})
	ScanGradient.Rotation = 90
	ScanGradient.Parent = ScanLine

	local ScanConn = RunService.Heartbeat:Connect(function()
		local MaxY = self.Frame.AbsoluteSize.Y
		local Y = ScanLine.Position.Y.Offset
		if Y > MaxY then
			ScanLine.Position = UDim2.new(0, 0, 0, -80)
		else
			ScanLine.Position = UDim2.new(0, 0, 0, Y + 2)
		end
	end)

	local CRTOverlay = Instance.new("Frame")
	CRTOverlay.Name = "CRTOverlay"
	CRTOverlay.Size = UDim2.new(1, 0, 1, 0)
	CRTOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
	CRTOverlay.BackgroundTransparency = 0.92
	CRTOverlay.BorderSizePixel = 0
	CRTOverlay.ZIndex = 99999
	CRTOverlay.Parent = self.Frame

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Size = UDim2.new(0, 320, 0, 0)
	Container.AutomaticSize = Enum.AutomaticSize.Y
	Container.Position = UDim2.new(0.5, -160, 0.5, -100)
	Container.BackgroundTransparency = 1
	Container.ZIndex = 99999
	Container.Parent = self.Frame

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.Padding = UDim.new(0, 5)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Container

	local HeaderRow = Instance.new("Frame")
	HeaderRow.Size = UDim2.new(1, 0, 0, 20)
	HeaderRow.BackgroundTransparency = 1
	HeaderRow.LayoutOrder = 1
	HeaderRow.ZIndex = 99999
	HeaderRow.Parent = Container

	local HeaderLayout = Instance.new("UIListLayout")
	HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
	HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	HeaderLayout.Padding = UDim.new(0, 8)
	HeaderLayout.Parent = HeaderRow

	local LogoLabel = Instance.new("TextLabel")
	LogoLabel.Size = UDim2.new(0, 16, 1, 0)
	LogoLabel.BackgroundTransparency = 1
	LogoLabel.Text = "⬡"
	LogoLabel.TextColor3 = Color3.fromHex("d4d4e0")
	LogoLabel.TextSize = 14
	LogoLabel.Font = Enum.Font.GothamBold
	LogoLabel.ZIndex = 99999
	LogoLabel.Parent = HeaderRow

	local HeaderLabel = Instance.new("TextLabel")
	HeaderLabel.Size = UDim2.new(1, -24, 1, 0)
	HeaderLabel.BackgroundTransparency = 1
	HeaderLabel.Text = "APEX UI // SYSTEM BOOT"
	HeaderLabel.TextColor3 = Color3.fromHex("9898aa")
	HeaderLabel.TextSize = 11
	HeaderLabel.Font = Enum.Font.GothamBold
	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
	HeaderLabel.ZIndex = 99999
	HeaderLabel.Parent = HeaderRow

	local ProgressBg = Instance.new("Frame")
	ProgressBg.Size = UDim2.new(1, 0, 0, 2)
	ProgressBg.BackgroundColor3 = Color3.fromHex("18181d")
	ProgressBg.BorderSizePixel = 0
	ProgressBg.LayoutOrder = 2
	ProgressBg.ZIndex = 99999
	ProgressBg.Parent = Container

	local ProgressStroke = Instance.new("UIStroke")
	ProgressStroke.Color = Color3.fromHex("32323e")
	ProgressStroke.Thickness = 1
	ProgressStroke.Parent = ProgressBg

	self.ProgressBar = Instance.new("Frame")
	self.ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	self.ProgressBar.BackgroundColor3 = Color3.fromHex("d4d4e0")
	self.ProgressBar.BorderSizePixel = 0
	self.ProgressBar.ZIndex = 99999
	self.ProgressBar.Parent = ProgressBg

	local ProgressGlow = Instance.new("UIGradient")
	ProgressGlow.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromHex("9898aa")),
		ColorSequenceKeypoint.new(1, Color3.fromHex("eeeef4")),
	})
	ProgressGlow.Parent = self.ProgressBar

	local Spacer = Instance.new("Frame")
	Spacer.Size = UDim2.new(1, 0, 0, 4)
	Spacer.BackgroundTransparency = 1
	Spacer.LayoutOrder = 3
	Spacer.Parent = Container

	self.LinesContainer = Instance.new("Frame")
	self.LinesContainer.Name = "Lines"
	self.LinesContainer.Size = UDim2.new(1, 0, 0, 0)
	self.LinesContainer.AutomaticSize = Enum.AutomaticSize.Y
	self.LinesContainer.BackgroundTransparency = 1
	self.LinesContainer.LayoutOrder = 4
	self.LinesContainer.ZIndex = 99999
	self.LinesContainer.Parent = Container

	local LinesLayout = Instance.new("UIListLayout")
	LinesLayout.FillDirection = Enum.FillDirection.Vertical
	LinesLayout.Padding = UDim.new(0, 4)
	LinesLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LinesLayout.Parent = self.LinesContainer

	self.Container  = Container
	self.ScanConn   = ScanConn
end

function BootScreen:AddLine(Text, Index, Total)
	local IsLast = Index == Total

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 12)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = Index
	Row.ZIndex = 99999
	Row.Parent = self.LinesContainer

	local Arrow = Instance.new("TextLabel")
	Arrow.Size = UDim2.new(0, 14, 1, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Text = ">"
	Arrow.TextColor3 = Color3.fromHex("272730")
	Arrow.TextSize = 9
	Arrow.Font = Enum.Font.GothamBold
	Arrow.ZIndex = 99999
	Arrow.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -16, 1, 0)
	Label.Position = UDim2.new(0, 16, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = IsLast and Color3.fromHex("eeeef4") or Color3.fromHex("4a4a5a")
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextTransparency = 1
	Label.ZIndex = 99999
	Label.Parent = Row

	if not IsLast then
		for I = 1, #Text do
			task.delay(I * 0.018, function()
				if Label and Label.Parent then
					Label.Text = Text:sub(1, I)
					Label.TextTransparency = 0
				end
			end)
		end
	else
		TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0,
		}):Play()
	end

	TweenService:Create(self.ProgressBar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(Index / Total, 0, 1, 0),
	}):Play()
end

function BootScreen:Play()
	local Total = #BootLines
	local Index = 0

	local function Next()
		if Index >= Total then
			task.wait(0.5)
			self:Dismiss()
			return
		end
		Index = Index + 1
		self:AddLine(BootLines[Index], Index, Total)
		task.delay(0.22 + math.random() * 0.14, Next)
	end

	task.delay(0.3, Next)
end

function BootScreen:Dismiss()
	if self.ScanConn then
		self.ScanConn:Disconnect()
	end

	TweenService:Create(self.Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()

	for _, Child in ipairs(self.Frame:GetDescendants()) do
		if Child:IsA("TextLabel") then
			TweenService:Create(Child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextTransparency = 1,
			}):Play()
		elseif Child:IsA("Frame") then
			TweenService:Create(Child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
			}):Play()
		end
	end

	task.delay(0.65, function()
		self.Frame:Destroy()
		self.OnDone()
	end)
end

return BootScreen
