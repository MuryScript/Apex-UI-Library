local Label = {}
Label.__index = Label

function Label.New(Options)
	local self = setmetatable({}, Label)

	self.Text        = Options.Text or ""
	self.Color       = Options.Color or nil
	self.Theme       = Options.Theme
	self.LayoutOrder = Options.LayoutOrder or 1
	self.Connections = {}

	self:Build(Options.Parent)
	return self
end

function Label:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Label"
	self.Frame.Size = UDim2.new(1, 0, 0, 0)
	self.Frame.AutomaticSize = Enum.AutomaticSize.Y
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 4)
	Padding.PaddingBottom = UDim.new(0, 4)
	Padding.PaddingLeft = UDim.new(0, 2)
	Padding.PaddingRight = UDim.new(0, 2)
	Padding.Parent = self.Frame

	self.TextLabel = Instance.new("TextLabel")
	self.TextLabel.Name = "TextLabel"
	self.TextLabel.Size = UDim2.new(1, 0, 0, 0)
	self.TextLabel.AutomaticSize = Enum.AutomaticSize.Y
	self.TextLabel.BackgroundTransparency = 1
	self.TextLabel.Text = self.Text
	self.TextLabel.TextColor3 = self.Color or T.Muted
	self.TextLabel.TextSize = 11
	self.TextLabel.Font = Enum.Font.Gotham
	self.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.TextLabel.TextWrapped = true
	self.TextLabel.Parent = self.Frame
end

function Label:SetText(Text)
	self.Text = Text
	self.TextLabel.Text = Text
end

function Label:SetColor(Color)
	self.Color = Color
	self.TextLabel.TextColor3 = Color
end

function Label:ApplyTheme(T)
	self.Theme = T
	if not self.Color then
		self.TextLabel.TextColor3 = T.Muted
	end
end

function Label:Destroy()
	self.Frame:Destroy()
end

return Label
