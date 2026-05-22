local Theme = {}
Theme.__index = Theme

local Themes = {
	Monochrome = {
		Void   = Color3.fromHex("080809"),
		Deep   = Color3.fromHex("0d0d0f"),
		Panel  = Color3.fromHex("111114"),
		Lift   = Color3.fromHex("18181d"),
		Edge   = Color3.fromHex("272730"),
		Wire   = Color3.fromHex("32323e"),
		Ghost  = Color3.fromHex("4a4a5a"),
		Muted  = Color3.fromHex("6e6e82"),
		Mid    = Color3.fromHex("9898aa"),
		Bright = Color3.fromHex("d4d4e0"),
		White  = Color3.fromHex("eeeef4"),
		Ok     = Color3.fromHex("6effc0"),
		Warn   = Color3.fromHex("ffd26e"),
		Err    = Color3.fromHex("ff6e7a"),
		Accent = Color3.fromHex("d4d4e0"),
	},
	Crimson = {
		Void   = Color3.fromHex("090608"),
		Deep   = Color3.fromHex("100a0b"),
		Panel  = Color3.fromHex("150d0e"),
		Lift   = Color3.fromHex("1e1112"),
		Edge   = Color3.fromHex("2e1a1c"),
		Wire   = Color3.fromHex("3e2224"),
		Ghost  = Color3.fromHex("5a3a3c"),
		Muted  = Color3.fromHex("82565a"),
		Mid    = Color3.fromHex("aa8082"),
		Bright = Color3.fromHex("e0c0c4"),
		White  = Color3.fromHex("f4eeee"),
		Ok     = Color3.fromHex("6effc0"),
		Warn   = Color3.fromHex("ffd26e"),
		Err    = Color3.fromHex("ff6e7a"),
		Accent = Color3.fromHex("ff4e5e"),
	},
	Neon = {
		Void   = Color3.fromHex("060610"),
		Deep   = Color3.fromHex("090918"),
		Panel  = Color3.fromHex("0d0d20"),
		Lift   = Color3.fromHex("121228"),
		Edge   = Color3.fromHex("1e1e3a"),
		Wire   = Color3.fromHex("28285a"),
		Ghost  = Color3.fromHex("3a3a72"),
		Muted  = Color3.fromHex("5858aa"),
		Mid    = Color3.fromHex("8080cc"),
		Bright = Color3.fromHex("c0c0ff"),
		White  = Color3.fromHex("eeeeff"),
		Ok     = Color3.fromHex("6effc0"),
		Warn   = Color3.fromHex("ffd26e"),
		Err    = Color3.fromHex("ff6e7a"),
		Accent = Color3.fromHex("7b6eff"),
	},
	Slate = {
		Void   = Color3.fromHex("070910"),
		Deep   = Color3.fromHex("0c0f18"),
		Panel  = Color3.fromHex("101420"),
		Lift   = Color3.fromHex("161c2c"),
		Edge   = Color3.fromHex("222a3e"),
		Wire   = Color3.fromHex("2e3a52"),
		Ghost  = Color3.fromHex("445070"),
		Muted  = Color3.fromHex("627090"),
		Mid    = Color3.fromHex("8898b0"),
		Bright = Color3.fromHex("c8d8f0"),
		White  = Color3.fromHex("eef2fc"),
		Ok     = Color3.fromHex("6effc0"),
		Warn   = Color3.fromHex("ffd26e"),
		Err    = Color3.fromHex("ff6e7a"),
		Accent = Color3.fromHex("6eaaff"),
	},
	Void = {
		Void   = Color3.fromHex("000000"),
		Deep   = Color3.fromHex("050505"),
		Panel  = Color3.fromHex("080808"),
		Lift   = Color3.fromHex("0e0e0e"),
		Edge   = Color3.fromHex("181818"),
		Wire   = Color3.fromHex("242424"),
		Ghost  = Color3.fromHex("363636"),
		Muted  = Color3.fromHex("525252"),
		Mid    = Color3.fromHex("787878"),
		Bright = Color3.fromHex("c8c8c8"),
		White  = Color3.fromHex("f0f0f0"),
		Ok     = Color3.fromHex("6effc0"),
		Warn   = Color3.fromHex("ffd26e"),
		Err    = Color3.fromHex("ff6e7a"),
		Accent = Color3.fromHex("ffffff"),
	},
}

local Active = "Monochrome"

function Theme:Set(Name)
	assert(Themes[Name], "[ApexUI] Unknown theme: " .. tostring(Name))
	Active = Name
end

function Theme:Get()
	return Themes[Active]
end

function Theme:GetName()
	return Active
end

function Theme:GetAll()
	local Names = {}
	for Name in pairs(Themes) do
		table.insert(Names, Name)
	end
	table.sort(Names)
	return Names
end

function Theme:Register(Name, Colors)
	assert(type(Name) == "string", "[ApexUI] Theme name must be a string")
	assert(type(Colors) == "table", "[ApexUI] Theme colors must be a table")
	local Required = {
		"Void","Deep","Panel","Lift","Edge","Wire",
		"Ghost","Muted","Mid","Bright","White",
		"Ok","Warn","Err","Accent"
	}
	for _, Key in ipairs(Required) do
		assert(Colors[Key], "[ApexUI] Theme missing key: " .. Key)
	end
	Themes[Name] = Colors
end

function Theme:GetColor(Key)
	return Themes[Active][Key]
end

return Theme
