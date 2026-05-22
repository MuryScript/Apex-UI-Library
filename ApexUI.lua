local ApexUI = {}
ApexUI.__index = ApexUI

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Version = "1.0.0"
local Initialized = false
local Windows = {}
local LoadedModules = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ApexUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local GuiSuccess = pcall(function()
	ScreenGui.Parent = CoreGui
end)

if not GuiSuccess then
	ScreenGui.Parent = PlayerGui
end

local BaseUrl = "https://raw.githubusercontent.com/MuryScript/Apex-UI-Library/main/"

local function Fetch(Path)
	if LoadedModules[Path] then
		return LoadedModules[Path]
	end
	local Success, Result = pcall(function()
		return loadstring(game:HttpGet(BaseUrl .. Path))()
	end)
	assert(Success, "[ApexUI] Failed to load: " .. Path)
	LoadedModules[Path] = Result
	return Result
end

local ThemeModule
local AnimateModule
local UtilModule
local ConfigModule
local NotificationModule
local PluginModule

function ApexUI:Init(Options)
	if Initialized then return self end
	Options = Options or {}

	ThemeModule       = Fetch("Core/Theme.lua")
	AnimateModule     = Fetch("Core/Animate.lua")
	UtilModule        = Fetch("Core/Util.lua")
	ConfigModule      = Fetch("Core/Config.lua")
	NotificationModule = Fetch("Layout/Notification.lua")
	PluginModule      = Fetch("Plugins/PluginHandler.lua")

	if Options.Theme then
		ThemeModule:Set(Options.Theme)
	end

	if Options.ConfigKey then
		ConfigModule:SetKey(Options.ConfigKey)
		ConfigModule:Load()
	end

	NotificationModule:Init(ScreenGui)
	PluginModule:Init(self)

	Initialized = true
	return self
end

function ApexUI:CreateWindow(Options)
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before CreateWindow()")
	Options = Options or {}

	local WindowModule = Fetch("Components/Window.lua")
	local Window = WindowModule.New({
		Title          = Options.Title or "ApexUI",
		SubTitle       = Options.SubTitle or "v" .. Version,
		Theme          = ThemeModule:Get(),
		Size           = Options.Size or UDim2.new(0, 520, 0, 440),
		Position       = Options.Position or UDim2.new(0.5, -260, 0.5, -220),
		MinimizeKey    = Options.MinimizeKey or Enum.KeyCode.RightShift,
		ScreenGui      = ScreenGui,
		ThemeModule    = ThemeModule,
		AnimateModule  = AnimateModule,
		UtilModule     = UtilModule,
		ConfigModule   = ConfigModule,
		NotificationModule = NotificationModule,
	})

	table.insert(Windows, Window)
	return Window
end

function ApexUI:Notify(Options)
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before Notify()")
	Options = Options or {}
	NotificationModule:Send({
		Title    = Options.Title or "Notification",
		Content  = Options.Content or "",
		Duration = Options.Duration or 4,
		Type     = Options.Type or "Info",
	})
end

function ApexUI:SetTheme(Name)
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before SetTheme()")
	ThemeModule:Set(Name)
	for _, Window in ipairs(Windows) do
		Window:ApplyTheme(ThemeModule:Get())
	end
end

function ApexUI:GetTheme()
	return ThemeModule:GetName()
end

function ApexUI:GetThemes()
	return ThemeModule:GetAll()
end

function ApexUI:SaveConfig()
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before SaveConfig()")
	ConfigModule:Save()
end

function ApexUI:LoadConfig()
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before LoadConfig()")
	ConfigModule:Load()
end

function ApexUI:RegisterPlugin(Plugin)
	assert(Initialized, "[ApexUI] Call ApexUI:Init() before RegisterPlugin()")
	PluginModule:Register(Plugin)
end

function ApexUI:GetVersion()
	return Version
end

function ApexUI:Destroy()
	for _, Window in ipairs(Windows) do
		Window:Destroy()
	end
	Windows = {}
	ScreenGui:Destroy()
	Initialized = false
end

return ApexUI
