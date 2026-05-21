local Registry = {}
Registry.__index = Registry

function Registry.new()
	return setmetatable({
		Components = {}
	}, Registry)
end

function Registry:Register(name, component)
	self.Components[name] = component
end

function Registry:Get(name)
	return self.Components[name]
end

return Registry
