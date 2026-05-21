local Utility = {}

function Utility:Create(class, properties)
	local Object = Instance.new(class)

	for Property, Value in pairs(properties) do
		if Property ~= "Parent" then
			Object[Property] = Value
		end
	end

	if properties.Parent then
		Object.Parent = properties.Parent
	end

	return Object
end

function Utility:Round(number, places)
	local multiplier = 10 ^ (places or 0)

	return math.floor(number * multiplier + 0.5) / multiplier
end

function Utility:Clamp(value, min, max)
	return math.clamp(value, min, max)
end

function Utility:Lerp(a, b, t)
	return a + (b - a) * t
end

function Utility:UUID()
	return game:GetService("HttpService"):GenerateGUID(false)
end

return Utility
