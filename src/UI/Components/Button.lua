local Button = {}
Button.__index = Button

function Button.new(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 32)
	btn.Text = text
	btn.Parent = parent

	btn.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	return btn
end

return Button
