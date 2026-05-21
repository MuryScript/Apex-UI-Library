local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, default, callback)
	local state = default or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 32)
	btn.Text = tostring(state)
	btn.Parent = parent

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = tostring(state)

		if callback then
			callback(state)
		end
	end)

	return btn
end

return Toggle
