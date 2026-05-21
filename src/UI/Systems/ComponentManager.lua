local Components = require(script.Parent.Components)

local ComponentManager = {}
ComponentManager.__index = ComponentManager

function ComponentManager.new(Library)
	return setmetatable({
		Library = Library
	}, ComponentManager)
end

function ComponentManager:Create(name, parent, props)
	return Components:Create(name, parent, props)
end

return ComponentManager
