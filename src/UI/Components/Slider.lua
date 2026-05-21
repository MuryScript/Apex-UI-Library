local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, min, max, default, callback)
	local value = default or min

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -10, 0, 20)
	bar.Parent = parent

	local dragging = false

	local function set(v)
		value = math.clamp(v, min, max)
		if callback then callback(value) end
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			set(value + 1)
		end
	end)

	return bar
end

return Slider
