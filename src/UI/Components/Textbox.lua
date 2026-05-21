local Textbox = {}
Textbox.__index = Textbox

function Textbox.new(parent, callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -10, 0, 32)
	box.Parent = parent

	box.FocusLost:Connect(function()
		if callback then
			callback(box.Text)
		end
	end)

	return box
end

return Textbox
