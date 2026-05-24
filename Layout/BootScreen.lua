local BootScreen = {}
BootScreen.__index = BootScreen

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

function BootScreen.New(Options)
	local self = setmetatable({}, BootScreen)
	self.OnDone   = Options.OnDone or function() end
	self.Window   = Options.Window
	self.Title    = Options.Title or "APEX UI"
	self.SubTitle = Options.SubTitle or "SYSTEM BOOT"
	self.Lines    = Options.Lines or {
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
	self:Build()
	self:Play()
	return self
end

function BootScreen:Build()
	self.Gui = Instance.new("ScreenGui")
	self.Gui.Name = "ApexBoot"
	self.Gui.ResetOnSpawn = false
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.Gui.DisplayOrder = 99999
	self.Gui.IgnoreGuiInset = true

	local Ok = pcall(function()
		self.Gui.Parent = CoreGui
	end)
	if not Ok then
		self.Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "BootFrame"
	self.Frame.Size = UDim2.new(1, 0, 1, 0)
	self.Frame.Position = UDim2.new(0, 0, 0, 0)
	self.Frame.BackgroundColor3 = Color3.fromHex("080809")
	self.Frame.BorderSizePixel = 0
	self.Frame.ZIndex = 1
	self.Frame.Parent = self.Gui

	local ScanLine = Instance.new("Frame")
	ScanLine.Name = "ScanLine"
	ScanLine.Size = UDim2.new(1, 0, 0, 80)
	ScanLine.Position = UDim2.new(0, 0, 0, -80)
	ScanLine.BorderSizePixel = 0
	ScanLine.BackgroundColor3 = Color3.new(1, 1, 1)
	ScanLine.ZIndex = 2
	ScanLine.Parent = self.Frame

	local ScanGradient = Instance.new("UIGradient")
	ScanGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.95),
		NumberSequenceKeypoint.new(1, 1),
	})
	ScanGradient.Rotation = 90
	ScanGradient.Parent = ScanLine

	self.ScanConn = RunService.Heartbeat:Connect(function()
		local MaxY = self.Frame.AbsoluteSize.Y
		local Y = ScanLine.Position.Y.Offset
		ScanLine.Position = UDim2.new(0, 0, 0, Y > MaxY and -80 or Y + 2)
	end)

	local Screen = workspace.CurrentCamera.ViewportSize
	local ContainerWidth = math.min(320, Screen.X * 0.8)

	self.Container = Instance.new("Frame")
	self.Container.Name = "Container"
	self.Container.Size = UDim2.new(0, ContainerWidth, 0, 0)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Container.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.Container.BackgroundTransparency = 1
	self.Container.ZIndex = 3
	self.Container.Parent = self.Frame

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.Padding = UDim.new(0, 6)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	Layout.Parent = self.Container

	local HeaderRow = Instance.new("Frame")
	HeaderRow.Size = UDim2.new(1, 0, 0, 22)
	HeaderRow.BackgroundTransparency = 1
	HeaderRow.LayoutOrder = 1
	HeaderRow.ZIndex = 3
	HeaderRow.Parent = self.Container

	local HeaderLayout = Instance.new("UIListLayout")
	HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
	HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	HeaderLayout.Padding = UDim.new(0, 8)
	HeaderLayout.Parent = HeaderRow

	local LogoLabel = Instance.new("TextLabel")
	LogoLabel.Size = UDim2.new(0, 18, 1, 0)
	LogoLabel.BackgroundTransparency = 1
	LogoLabel.Text = "⬡"
	LogoLabel.TextColor3 = Color3.fromHex("d4d4e0")
	LogoLabel.TextSize = 16
	LogoLabel.Font = Enum.Font.GothamBold
	LogoLabel.ZIndex = 3
	LogoLabel.Parent = HeaderRow

	self.TitleLabel = Instance.new("TextLabel")
	self.TitleLabel.Size = UDim2.new(0, 0, 1, 0)
	self.TitleLabel.AutomaticSize = Enum.AutomaticSize.X
	self.TitleLabel.BackgroundTransparency = 1
	self.TitleLabel.Text = ""
	self.TitleLabel.TextColor3 = Color3.fromHex("eeeef4")
	self.TitleLabel.TextSize = 13
	self.TitleLabel.Font = Enum.Font.GothamBold
	self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TitleLabel.ZIndex = 3
	self.TitleLabel.Parent = HeaderRow

	self.SubTitleLabel = Instance.new("TextLabel")
	self.SubTitleLabel.Size = UDim2.new(1, 0, 0, 13)
	self.SubTitleLabel.BackgroundTransparency = 1
	self.SubTitleLabel.Text = ""
	self.SubTitleLabel.TextColor3 = Color3.fromHex("6e6e82")
	self.SubTitleLabel.TextSize = 10
	self.SubTitleLabel.Font = Enum.Font.GothamBold
	self.SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.SubTitleLabel.LayoutOrder = 2
	self.SubTitleLabel.ZIndex = 3
	self.SubTitleLabel.Parent = self.Container

	local ProgressBg = Instance.new("Frame")
	ProgressBg.Size = UDim2.new(1, 0, 0, 2)
	ProgressBg.BackgroundColor3 = Color3.fromHex("18181d")
	ProgressBg.BorderSizePixel = 0
	ProgressBg.LayoutOrder = 3
	ProgressBg.ZIndex = 3
	ProgressBg.Parent = self.Container

	local ProgressStroke = Instance.new("UIStroke")
	ProgressStroke.Color = Color3.fromHex("32323e")
	ProgressStroke.Thickness = 1
	ProgressStroke.Parent = ProgressBg

	self.ProgressBar = Instance.new("Frame")
	self.ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	self.ProgressBar.BackgroundColor3 = Color3.fromHex("d4d4e0")
	self.ProgressBar.BorderSizePixel = 0
	self.ProgressBar.ZIndex = 4
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
	Spacer.LayoutOrder = 4
	Spacer.Parent = self.Container

	self.LinesContainer = Instance.new("Frame")
	self.LinesContainer.Name = "Lines"
	self.LinesContainer.Size = UDim2.new(1, 0, 0, 0)
	self.LinesContainer.AutomaticSize = Enum.AutomaticSize.Y
	self.LinesContainer.BackgroundTransparency = 1
	self.LinesContainer.LayoutOrder = 5
	self.LinesContainer.ZIndex = 3
	self.LinesContainer.Parent = self.Container

	local LinesLayout = Instance.new("UIListLayout")
	LinesLayout.FillDirection = Enum.FillDirection.Vertical
	LinesLayout.Padding = UDim.new(0, 4)
	LinesLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LinesLayout.Parent = self.LinesContainer

	task.spawn(function()
		task.wait(0.1)
		local FullTitle = self.Title
		for I = 1, #FullTitle do
			task.wait(0.03)
			if self.TitleLabel and self.TitleLabel.Parent then
				self.TitleLabel.Text = FullTitle:sub(1, I)
			end
		end
		task.wait(0.05)
		local FullSub = self.SubTitle
		for I = 1, #FullSub do
			task.wait(0.02)
			if self.SubTitleLabel and self.SubTitleLabel.Parent then
				self.SubTitleLabel.Text = FullSub:sub(1, I)
			end
		end
	end)
end

function BootScreen:AddLine(Text, Index, Total)
	local IsLast = Index == Total

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 12)
	Row.BackgroundTransparency = 1
	Row.LayoutOrder = Index
	Row.ZIndex = 3
	Row.Parent = self.LinesContainer

	local Arrow = Instance.new("TextLabel")
	Arrow.Size = UDim2.new(0, 14, 1, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Text = ">"
	Arrow.TextColor3 = Color3.fromHex("272730")
	Arrow.TextSize = 9
	Arrow.Font = Enum.Font.GothamBold
	Arrow.ZIndex = 3
	Arrow.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -16, 1, 0)
	Label.Position = UDim2.new(0, 16, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = ""
	Label.TextColor3 = IsLast and Color3.fromHex("eeeef4") or Color3.fromHex("6e6e82")
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 3
	Label.Parent = Row

	for I = 1, #Text do
		task.delay(I * 0.016, function()
			if Label and Label.Parent then
				Label.Text = Text:sub(1, I)
			end
		end)
	end

	TweenService:Create(self.ProgressBar, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(Index / Total, 0, 1, 0),
	}):Play()
end

function BootScreen:Play()
	local Total = #self.Lines
	local Index = 0

	local function Next()
		if Index >= Total then
			task.wait(0.5)
			self:Dismiss()
			return
		end
		Index = Index + 1
		self:AddLine(self.Lines[Index], Index, Total)
		task.delay(0.22 + math.random() * 0.14, Next)
	end

	task.delay(0.5, Next)
end

function BootScreen:Dismiss()
	if self.ScanConn then
		self.ScanConn:Disconnect()
	end

	if not self.Window then
		TweenService:Create(self.Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1,
		}):Play()
		for _, Child in ipairs(self.Frame:GetDescendants()) do
			if Child:IsA("TextLabel") then
				TweenService:Create(Child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 1,
				}):Play()
			elseif Child:IsA("Frame") and Child ~= self.Frame then
				TweenService:Create(Child, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1,
				}):Play()
			end
		end
		task.delay(0.65, function()
			self.Gui:Destroy()
			self.OnDone()
		end)
		return
	end

	local Screen = workspace.CurrentCamera.ViewportSize
	local WinSize = self.Window.Size
	local WinPos = UDim2.new(0.5, -WinSize.X.Offset / 2, 0.5, -WinSize.Y.Offset / 2)

	self.Window.Root.Position = UDim2.new(0.5, -WinSize.X.Offset / 2, 0.5, -WinSize.Y.Offset / 2)

	local ContainerSize = self.Container.AbsoluteSize
	local TargetSize = UDim2.new(0, WinSize.X.Offset, 0, WinSize.Y.Offset)
	local TargetPos = UDim2.new(0.5, 0, 0.5, 0)

	for _, Child in ipairs(self.LinesContainer:GetChildren()) do
		if Child:IsA("Frame") then
			TweenService:Create(Child, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
			}):Play()
			for _, Label in ipairs(Child:GetChildren()) do
				if Label:IsA("TextLabel") then
					TweenService:Create(Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						TextTransparency = 1,
					}):Play()
				end
			end
		end
	end

	TweenService:Create(self.TitleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 1,
	}):Play()

	TweenService:Create(self.SubTitleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 1,
	}):Play()

	TweenService:Create(self.ProgressBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()

	task.wait(0.25)

	self.Container.AnchorPoint = Vector2.new(0.5, 0.5)

	TweenService:Create(self.Container, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size     = TargetSize,
		Position = TargetPos,
	}):Play()

	TweenService:Create(self.Frame, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()

	task.delay(0.4, function()
		self.Window.Root.Visible = true
		self.Window.Root.Size = TargetSize
		self.Window.Root.BackgroundTransparency = 0
	end)

	task.delay(0.6, function()
		self.Gui:Destroy()
		self.OnDone()
	end)
end

return BootScreen
