local Config = {}
Config.__index = Config

local HttpService = game:GetService("HttpService")

local ConfigKey = "ApexUI_Config"
local Data = {}
local Callbacks = {}

local function GetFilePath()
	return ConfigKey .. ".json"
end

local function WriteFile(Content)
	local Success, Err = pcall(function()
		writefile(GetFilePath(), Content)
	end)
	return Success, Err
end

local function ReadFile()
	local Success, Result = pcall(function()
		return readfile(GetFilePath())
	end)
	if Success then return Result end
	return nil
end

local function FileExists()
	local Success, Result = pcall(function()
		return isfile(GetFilePath())
	end)
	return Success and Result
end

function Config:SetKey(Key)
	assert(type(Key) == "string", "[ApexUI] Config key must be a string")
	ConfigKey = Key
end

function Config:GetKey()
	return ConfigKey
end

function Config:Set(Flag, Value)
	Data[Flag] = Value
	if Callbacks[Flag] then
		for _, Fn in ipairs(Callbacks[Flag]) do
			pcall(Fn, Value)
		end
	end
end

function Config:Get(Flag, Default)
	if Data[Flag] ~= nil then
		return Data[Flag]
	end
	return Default
end

function Config:GetAll()
	local Copy = {}
	for K, V in pairs(Data) do
		Copy[K] = V
	end
	return Copy
end

function Config:OnChanged(Flag, Fn)
	if not Callbacks[Flag] then
		Callbacks[Flag] = {}
	end
	table.insert(Callbacks[Flag], Fn)
end

function Config:Save()
	local Success, Encoded = pcall(function()
		return HttpService:JSONEncode(Data)
	end)
	if not Success then
		warn("[ApexUI] Failed to encode config")
		return false
	end
	local Written, Err = WriteFile(Encoded)
	if not Written then
		warn("[ApexUI] Failed to save config: " .. tostring(Err))
		return false
	end
	return true
end

function Config:Load()
	if not FileExists() then
		return false
	end
	local Raw = ReadFile()
	if not Raw then
		return false
	end
	local Success, Decoded = pcall(function()
		return HttpService:JSONDecode(Raw)
	end)
	if not Success or type(Decoded) ~= "table" then
		warn("[ApexUI] Failed to decode config")
		return false
	end
	for K, V in pairs(Decoded) do
		Data[K] = V
		if Callbacks[K] then
			for _, Fn in ipairs(Callbacks[K]) do
				pcall(Fn, V)
			end
		end
	end
	return true
end

function Config:Reset()
	Data = {}
	if FileExists() then
		pcall(function()
			delfile(GetFilePath())
		end)
	end
end

function Config:Delete(Flag)
	Data[Flag] = nil
end

function Config:Has(Flag)
	return Data[Flag] ~= nil
end

return Config
