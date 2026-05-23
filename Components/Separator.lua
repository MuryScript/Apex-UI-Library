local Separator = {}
Separator.__index = Separator

function Separator.New(Options)
	local self = setmetatable({}, Separator)

	self.Theme       = Options.Theme
	self.LayoutOrder = Options.LayoutOrder or 1

	self:Build(Options.Parent)
	return self
end

function Separator:Build(Parent)
	local T = self.Theme

	self.Frame = Instance.new("Frame")
	self.Frame.Name = "Separator"
	self.Frame.Size = UDim2.new(1, 0, 0, 10)
	self.Frame.BackgroundTransparency = 1
	self.Frame.LayoutOrder = self.LayoutOrder
	self.Frame.Parent = Parent

	self.Line = Instance.new("Frame")
	self.Line.Name = "Line"
	self.Line.Size = UDim2.new(1, 0, 0, 1)
	self.Line.Position = UDim2.new(0, 0, 0.5, 0)
	self.Line.BorderSizePixel = 0
	self.Line.Parent = self.Frame

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
		ColorSequenceKeypoint.new(0.2, T.Wire),
		ColorSequenceKeypoint.new(0.8, T.Wire),
		ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
	})
	Gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0),
		NumberSequenceKeypoint.new(0.8, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	Gradient.Parent = self.Line

	self.Line.BackgroundColor3 = T.Wire
end

function Separator:ApplyTheme(T)
	self.Theme = T
	self.Line.BackgroundColor3 = T.Wire
	local Gradient = self.Line:FindFirstChildOfClass("UIGradient")
	if Gradient then
		Gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.2, T.Wire),
			ColorSequenceKeypoint.new(0.8, T.Wire),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
		})
	end
end

function Separator:Destroy()
	self.Frame:Destroy()
end

return Separator
