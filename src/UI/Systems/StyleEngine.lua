local StyleEngine = {}
StyleEngine.__index = StyleEngine

function StyleEngine.new(themeManager)
	return setmetatable({
		ThemeManager = themeManager
	}, StyleEngine)
end

function StyleEngine:Get(property)
	local theme = self.ThemeManager:GetTheme()
	return theme[property]
end

function StyleEngine:Apply(instance, map)
	local theme = self.ThemeManager:GetTheme()

	for prop, key in pairs(map) do
		instance[prop] = theme[key]
	end
end

return StyleEngine
