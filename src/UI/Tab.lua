local Tab = {}
Tab.__index = Tab

function Tab.new()
	return setmetatable({}, Tab)
end

function Tab:CreateSection(name)
	local Section = {
		Title = name,
		Tab = self
	}

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 40)
	frame.BackgroundTransparency = 0.2
	frame.Parent = self.Page

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = name
	label.Parent = frame

	return Section
end

return Tab
