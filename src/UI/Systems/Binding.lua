local Binding = {}
Binding.__index = Binding

function Binding.new(state, callback)
	local self = setmetatable({}, Binding)

	self.State = state
	self.Callback = callback

	state.Changed:Connect(function(v)
		if self.Callback then
			self.Callback(v)
		end
	end)

	return self
end

return Binding
