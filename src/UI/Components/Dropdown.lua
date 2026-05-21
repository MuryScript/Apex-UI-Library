local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, options, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 32)
	btn.Text = "Select"
	btn.Parent = parent

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback(options[1])
		end
	end)

	return btn
end

return Dropdown
