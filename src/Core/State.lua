local Signal = require(script.Parent.Signal)

local State = {}
State.__index = State

function State.new(value)
	return setmetatable({
		Value = value,
		Changed = Signal.new()
	}, State)
end

function State:Get()
	return self.Value
end

function State:Set(value)
	if self.Value == value then
		return
	end

	self.Value = value
	self.Changed:Fire(value)
end

function State:Destroy()
	self.Changed:Destroy()
end

return State
