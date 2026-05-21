local Core = script:WaitForChild("Core")
local UI = script:WaitForChild("UI")

local ThemeManager = require(Core.ThemeManager)
local ConfigManager = require(Core.ConfigManager)
local Animator = require(Core.Animator)
local State = require(Core.State)
local Signal = require(Core.Signal)

local Window = require(UI.Window)
local Notification = require(UI.Notification)
local Dialog = require(UI.Dialog)

local Apex = {}
Apex.__index = Apex

Apex.Version = "0.1.0"

function Apex.new(options)
	local self = setmetatable({}, Apex)

	options = options or {}

	self.ThemeManager = ThemeManager.new()
	self.ConfigManager = ConfigManager.new()
	self.Animator = Animator.new()

	self.Windows = {}
	self.States = {}
	self.Signals = {}

	self.Options = {
		Name = options.Name or "Apex",
		Theme = options.Theme or "Dark",
		AutoSave = options.AutoSave or false,
	}

	self.ThemeManager:SetTheme(self.Options.Theme)

	return self
end

function Apex:CreateWindow(options)
	local Instance = Window.new(self, options or {})

	table.insert(self.Windows, Instance)

	return Instance
end

function Apex:Notify(options)
	return Notification.new(self, options or {})
end

function Apex:Dialog(options)
	return Dialog.new(self, options or {})
end

function Apex:CreateState(value)
	local Instance = State.new(value)

	table.insert(self.States, Instance)

	return Instance
end

function Apex:CreateSignal()
	local Instance = Signal.new()

	table.insert(self.Signals, Instance)

	return Instance
end

function Apex:SetTheme(theme)
	return self.ThemeManager:SetTheme(theme)
end

function Apex:GetTheme()
	return self.ThemeManager:GetTheme()
end

function Apex:SaveConfig(name, data)
	return self.ConfigManager:Save(name, data)
end

function Apex:LoadConfig(name)
	return self.ConfigManager:Load(name)
end

function Apex:GetVersion()
	return self.Version
end

function Apex:Destroy()
	for _, WindowInstance in ipairs(self.Windows) do
		if WindowInstance.Destroy then
			WindowInstance:Destroy()
		end
	end

	for _, StateInstance in ipairs(self.States) do
		if StateInstance.Destroy then
			StateInstance:Destroy()
		end
	end

	for _, SignalInstance in ipairs(self.Signals) do
		if SignalInstance.Destroy then
			SignalInstance:Destroy()
		end
	end

	table.clear(self.Windows)
	table.clear(self.States)
	table.clear(self.Signals)
end

return setmetatable(Apex, {
	__call = function(_, ...)
		return Apex.new(...)
	end
})
