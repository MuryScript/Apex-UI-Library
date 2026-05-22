local PluginHandler = {}
PluginHandler.__index = PluginHandler

local ApexInstance = nil
local Registered = {}
local Hooks = {}

local ValidHooks = {
	"OnInit",
	"OnWindowCreated",
	"OnTabCreated",
	"OnSectionCreated",
	"OnElementCreated",
	"OnThemeChanged",
	"OnConfigSaved",
	"OnConfigLoaded",
	"OnDestroy",
}

local function IsValidHook(Name)
	for _, Hook in ipairs(ValidHooks) do
		if Hook == Name then return true end
	end
	return false
end

local function RunHook(HookName, ...)
	if not Hooks[HookName] then return end
	for _, Fn in ipairs(Hooks[HookName]) do
		local Success, Err = pcall(Fn, ...)
		if not Success then
			warn("[ApexUI] Plugin hook error in " .. HookName .. ": " .. tostring(Err))
		end
	end
end

function PluginHandler:Init(Apex)
	ApexInstance = Apex
end

function PluginHandler:Register(Plugin)
	assert(type(Plugin) == "table", "[ApexUI] Plugin must be a table")
	assert(type(Plugin.Name) == "string", "[ApexUI] Plugin must have a Name field")

	for _, Existing in ipairs(Registered) do
		if Existing.Name == Plugin.Name then
			warn("[ApexUI] Plugin already registered: " .. Plugin.Name)
			return false
		end
	end

	table.insert(Registered, Plugin)

	for HookName, Fn in pairs(Plugin) do
		if IsValidHook(HookName) and type(Fn) == "function" then
			if not Hooks[HookName] then
				Hooks[HookName] = {}
			end
			table.insert(Hooks[HookName], Fn)
		end
	end

	if Plugin.OnInit then
		local Success, Err = pcall(Plugin.OnInit, ApexInstance)
		if not Success then
			warn("[ApexUI] Plugin OnInit failed for " .. Plugin.Name .. ": " .. tostring(Err))
		end
	end

	return true
end

function PluginHandler:Unregister(Name)
	for Index, Plugin in ipairs(Registered) do
		if Plugin.Name == Name then
			table.remove(Registered, Index)
			for HookName, FnList in pairs(Hooks) do
				for I = #FnList, 1, -1 do
					if FnList[I] == Plugin[HookName] then
						table.remove(FnList, I)
					end
				end
			end
			return true
		end
	end
	warn("[ApexUI] Plugin not found: " .. Name)
	return false
end

function PluginHandler:Get(Name)
	for _, Plugin in ipairs(Registered) do
		if Plugin.Name == Name then
			return Plugin
		end
	end
	return nil
end

function PluginHandler:GetAll()
	local List = {}
	for _, Plugin in ipairs(Registered) do
		table.insert(List, Plugin.Name)
	end
	return List
end

function PluginHandler:Fire(HookName, ...)
	assert(IsValidHook(HookName), "[ApexUI] Invalid hook: " .. tostring(HookName))
	RunHook(HookName, ...)
end

function PluginHandler:GetValidHooks()
	return ValidHooks
end

PluginHandler.Fire = function(self, HookName, ...)
	RunHook(HookName, ...)
end

return PluginHandler
