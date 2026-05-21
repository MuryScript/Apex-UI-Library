local HttpService = game:GetService("HttpService")

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new()
	return setmetatable({}, ConfigManager)
end

function ConfigManager:Encode(data)
	return HttpService:JSONEncode(data)
end

function ConfigManager:Decode(data)
	return HttpService:JSONDecode(data)
end

function ConfigManager:Save(name, data)
	if writefile then
		writefile(
			("Apex/%s.json"):format(name),
			HttpService:JSONEncode(data)
		)
	end
end

function ConfigManager:Load(name)
	if readfile and isfile then
		local Path = ("Apex/%s.json"):format(name)

		if isfile(Path) then
			return HttpService:JSONDecode(
				readfile(Path)
			)
		end
	end
end

return ConfigManager
