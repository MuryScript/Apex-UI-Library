local ThemeManager = {}
ThemeManager.__index = ThemeManager

local Themes = {
	Dark = {
		Background = Color3.fromRGB(16, 18, 22),
		Surface = Color3.fromRGB(24, 27, 33),
		SurfaceLight = Color3.fromRGB(34, 38, 46),

		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(170, 170, 170),

		Accent = Color3.fromRGB(88, 101, 242),

		Outline = Color3.fromRGB(42, 46, 54)
	},

	Light = {
		Background = Color3.fromRGB(245, 245, 245),
		Surface = Color3.fromRGB(255, 255, 255),
		SurfaceLight = Color3.fromRGB(235, 235, 235),

		Text = Color3.fromRGB(20, 20, 20),
		SubText = Color3.fromRGB(100, 100, 100),

		Accent = Color3.fromRGB(88, 101, 242),

		Outline = Color3.fromRGB(220, 220, 220)
	}
}

function ThemeManager.new()
	return setmetatable({
		Current = Themes.Dark
	}, ThemeManager)
end

function ThemeManager:SetTheme(name)
	if Themes[name] then
		self.Current = Themes[name]
	end
end

function ThemeManager:GetTheme()
	return self.Current
end

function ThemeManager:Register(name, data)
	Themes[name] = data
end

return ThemeManager
