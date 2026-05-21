local Lifecycle = {}
Lifecycle.__index = Lifecycle

function Lifecycle.new()
	return setmetatable({
		Objects = {}
	}, Lifecycle)
end

function Lifecycle:Add(obj)
	table.insert(self.Objects, obj)
	return obj
end

function Lifecycle:Destroy()
	for _, obj in ipairs(self.Objects) do
		if typeof(obj) == "RBXScriptConnection" then
			obj:Disconnect()
		elseif obj.Destroy then
			obj:Destroy()
		end
	end

	table.clear(self.Objects)
end

return Lifecycle
