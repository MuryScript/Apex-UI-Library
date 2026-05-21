local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		Connections = {},
	}, Signal)
end

function Signal:Connect(callback)
	local Connection = {
		Connected = true
	}

	function Connection:Disconnect()
		self.Connected = false
	end

	table.insert(self.Connections, {
		Callback = callback,
		Connection = Connection
	})

	return Connection
end

function Signal:Fire(...)
	for _, Item in ipairs(self.Connections) do
		if Item.Connection.Connected then
			task.spawn(Item.Callback, ...)
		end
	end
end

function Signal:Destroy()
	table.clear(self.Connections)
end

return Signal
