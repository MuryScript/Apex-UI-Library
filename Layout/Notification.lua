local Notification = {}
Notification.__index = Notification

local TweenService = game:GetService("TweenService")

local ScreenGui = nil
local Container = nil
local Queue = {}
local Active = {}
local MaxVisible = 5

local TypeColors = {
	Info    = Color3.fromHex("d4d4e0"),
	Success = Color3.fromHex("6effc0"),
	Warning = Color3.fromHex("ffd26e"),
	Error   = Color3.fromHex("ff6e7a"),
}

local TypeIcons = {
	Info    = "ℹ",
	Success = "✓",
	Warning = "⚠",
	Error   = "✕",
}

local function BuildContainer(Gui)
	local Frame = Instance.new("Frame")
	Frame.Name = "NotificationContainer"
	Frame.Size = UDim2.new(0, 260, 1, 0)
	Frame.Position = UDim2.new(1, -276, 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.AnchorPoint = Vector2.new(0, 0)
	Frame.Parent = Gui

	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection = Enum.FillDirection.Vertical
	Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	Layout.Padding = UDim.new(0, 6)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Frame

	local Padding = Instance.new("UIPadding")
	Padding.PaddingBottom = UDim.new(0, 16)
	Padding.PaddingRight = UDim.new(0, 0)
	Padding.Parent = Frame

	return Frame
end

local function Dismiss(NotifFrame, OnDone)
	local SlideOut = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = UDim2.new(1, 20, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset),
		BackgroundTransparency = 1,
	})
	local FadeLabel = NotifFrame:FindFirstChildWhichIsA("TextLabel", true)
	SlideOut:Play()
	SlideOut.Completed:Connect(function()
		NotifFrame:Destroy()
		if OnDone then OnDone() end
	end)
end

local function BuildNotif(Options, Theme)
	local AccentColor = TypeColors[Options.Type] or TypeColors.Info
	local Icon = TypeIcons[Options.Type] or TypeIcons.Info

	local Outer = Instance.new("Frame")
	Outer.Name = "Notification"
	Outer.Size = UDim2.new(1, 0, 0, 0)
	Outer.AutomaticSize = Enum.AutomaticSize.Y
	Outer.BackgroundColor3 = Color3.fromHex("0d0d0f")
	Outer.BorderSizePixel = 0
	Outer.ClipsDescendants = true
	Outer.Position = UDim2.new(1, 20, 0, 0)

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = Outer

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromHex("272730")
	Stroke.Thickness = 1
	Stroke.Parent = Outer

	local AccentBar = Instance.new("Frame")
	AccentBar.Name = "AccentBar"
	AccentBar.Size = UDim2.new(0, 2, 1, 0)
	AccentBar.Position = UDim2.new(0, 0, 0, 0)
	AccentBar.BackgroundColor3 = AccentColor
	AccentBar.BorderSizePixel = 0
	AccentBar.Parent = Outer

	local AccentGlow = Instance.new("Frame")
	AccentGlow.Name = "AccentGlow"
	AccentGlow.Size = UDim2.new(0, 60, 1, 0)
	AccentGlow.Position = UDim2.new(0, 2, 0, 0)
	AccentGlow.BackgroundColor3 = AccentColor
	AccentGlow.BackgroundTransparency = 0.88
	AccentGlow.BorderSizePixel = 0
	AccentGlow.Parent = Outer

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, 0, 0, 0)
	Content.AutomaticSize = Enum.AutomaticSize.Y
	Content.BackgroundTransparency = 1
	Content.Parent = Outer

	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.PaddingTop = UDim.new(0, 10)
	ContentPadding.PaddingBottom = UDim.new(0, 10)
	ContentPadding.PaddingLeft = UDim.new(0, 14)
	ContentPadding.PaddingRight = UDim.new(0, 10)
	ContentPadding.Parent = Content

	local ContentLayout = Instance.new("UIListLayout")
	ContentLayout.FillDirection = Enum.FillDirection.Vertical
	ContentLayout.Padding = UDim.new(0, 3)
	ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentLayout.Parent = Content

	local HeaderRow = Instance.new("Frame")
	HeaderRow.Name = "HeaderRow"
	HeaderRow.Size = UDim2.new(1, 0, 0, 16)
	HeaderRow.BackgroundTransparency = 1
	HeaderRow.LayoutOrder = 1
	HeaderRow.Parent = Content

	local HeaderLayout = Instance.new("UIListLayout")
	HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
	HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	HeaderLayout.Padding = UDim.new(0, 6)
	HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
	HeaderLayout.Parent = HeaderRow

	local IconLabel = Instance.new("TextLabel")
	IconLabel.Name = "Icon"
	IconLabel.Size = UDim2.new(0, 12, 1, 0)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text = Icon
	IconLabel.TextColor3 = AccentColor
	IconLabel.TextSize = 11
	IconLabel.Font = Enum.Font.GothamBold
	IconLabel.TextXAlignment = Enum.TextXAlignment.Left
	IconLabel.LayoutOrder = 1
	IconLabel.Parent = HeaderRow

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(1, -18, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Options.Title or ""
	TitleLabel.TextColor3 = Color3.fromHex("eeeef4")
	TitleLabel.TextSize = 12
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TitleLabel.LayoutOrder = 2
	TitleLabel.Parent = HeaderRow

	if Options.Content and Options.Content ~= "" then
		local BodyLabel = Instance.new("TextLabel")
		BodyLabel.Name = "Body"
		BodyLabel.Size = UDim2.new(1, 0, 0, 0)
		BodyLabel.AutomaticSize = Enum.AutomaticSize.Y
		BodyLabel.BackgroundTransparency = 1
		BodyLabel.Text = Options.Content
		BodyLabel.TextColor3 = Color3.fromHex("6e6e82")
		BodyLabel.TextSize = 10
		BodyLabel.Font = Enum.Font.Gotham
		BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
		BodyLabel.TextWrapped = true
		BodyLabel.LayoutOrder = 2
		BodyLabel.Parent = Content
	end

	local Duration = Options.Duration or 4
	local ProgressBar = Instance.new("Frame")
	ProgressBar.Name = "ProgressBar"
	ProgressBar.Size = UDim2.new(1, 0, 0, 1)
	ProgressBar.Position = UDim2.new(0, 0, 1, -1)
	ProgressBar.BackgroundColor3 = AccentColor
	ProgressBar.BackgroundTransparency = 0.4
	ProgressBar.BorderSizePixel = 0
	ProgressBar.ZIndex = 5
	ProgressBar.Parent = Outer

	return Outer, ProgressBar, Duration
end

local function ProcessQueue()
	if #Active >= MaxVisible then return end
	if #Queue == 0 then return end

	local Options = table.remove(Queue, 1)
	local NotifFrame, ProgressBar, Duration = BuildNotif(Options, nil)
	NotifFrame.Parent = Container
	table.insert(Active, NotifFrame)

	local SlideIn = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
	})
	SlideIn:Play()

	local ProgressTween = TweenService:Create(ProgressBar, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 0, 1),
	})
	ProgressTween:Play()

	task.delay(Duration, function()
		local Index = table.find(Active, NotifFrame)
		if Index then table.remove(Active, Index) end
		Dismiss(NotifFrame, function()
			ProcessQueue()
		end)
	end)
end

function Notification:Init(Gui)
	ScreenGui = Gui
	Container = BuildContainer(Gui)
end

function Notification:Send(Options)
	table.insert(Queue, Options)
	ProcessQueue()
end

function Notification:SetMax(Count)
	MaxVisible = Count
end

function Notification:ClearAll()
	for _, Frame in ipairs(Active) do
		Frame:Destroy()
	end
	Active = {}
	Queue = {}
end

return Notification
