# Apex UI Library

A modern, high-performance UI library built for Roblox executors. Designed with a focus on clean aesthetics, smooth animations, and a dead-simple API.

---

## Features

- Boot screen with typewriter animation
- Smooth window open/close animations
- Animated bracket corners on every section
- Scanline overlay effect
- Toast notification system with queue
- Full theme system with 5 built-in themes
- Custom theme registration
- Config save/load system (JSON to disk)
- Plugin/hook system
- Mobile and PC support
- Touch drag and swipe to close
- All major executors supported

---

## Supported Executors

- Synapse X
- KRNL
- Fluxus
- Celery
- Hydrogen
- Delta
- Arceus X

---

## Quick Start

```lua
local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MuryScript/Apex-UI-Library/main/ApexUI.lua"))()

ApexUI:Init({
   Theme     = "Monochrome",
   ConfigKey = "MyScript_Config",
})

local Window = ApexUI:CreateWindow({
   Title    = "My Script",
   SubTitle = "v1.0.0",
   Size     = UDim2.new(0, 340, 0, 420),
   Position = UDim2.new(0.5, -170, 0.5, -210),
})

local Tab     = Window:AddTab({ Name = "Main", Icon = "⌖" })
local Section = Tab:AddSection({ Name = "Combat" })

Section:AddToggle({
   Name     = "Aimbot",
   Sub      = "lock-on nearest target",
   Default  = false,
   Flag     = "Aimbot",
   Callback = function(Value)
       print("Aimbot:", Value)
   end,
})

Section:AddSlider({
   Name      = "FOV",
   Min       = 1,
   Max       = 360,
   Default   = 90,
   Increment = 1,
   Unit      = "°",
   Flag      = "AimbotFOV",
   Callback  = function(Value)
       print("FOV:", Value)
   end,
})


API Reference

ApexUI



|Method                         |Description                                  |
|-------------------------------|---------------------------------------------|
|`ApexUI:Init(Options)`         |Initializes the library. Must be called first|
|`ApexUI:CreateWindow(Options)` |Creates and returns a Window                 |
|`ApexUI:Notify(Options)`       |Sends a toast notification                   |
|`ApexUI:SetTheme(Name)`        |Switches active theme and updates all windows|
|`ApexUI:GetTheme()`            |Returns active theme name                    |
|`ApexUI:GetThemes()`           |Returns table of all theme names             |
|`ApexUI:SaveConfig()`          |Saves all flagged values to disk             |
|`ApexUI:LoadConfig()`          |Loads config from disk                       |
|`ApexUI:RegisterPlugin(Plugin)`|Registers a plugin                           |
|`ApexUI:Destroy()`             |Destroys all windows and cleans up           |

Init Options



|Option   |Type  |Default     |Description         |
|---------|------|------------|--------------------|
|Theme    |string|“Monochrome”|Starting theme      |
|ConfigKey|string|nil         |Config file name key|

CreateWindow Options



|Option     |Type   |Default   |Description           |
|-----------|-------|----------|----------------------|
|Title      |string |“ApexUI”  |Window title          |
|SubTitle   |string |“v1.0.0”  |Subtitle next to title|
|Size       |UDim2  |520x440   |Window size           |
|Position   |UDim2  |center    |Window position       |
|MinimizeKey|KeyCode|RightShift|Key to toggle window  |

Notify Options



|Option  |Type  |Default       |Description                  |
|--------|------|--------------|-----------------------------|
|Title   |string|“Notification”|Notification title           |
|Content |string|“”            |Body text                    |
|Type    |string|“Info”        |Info, Success, Warning, Error|
|Duration|number|4             |Seconds before dismissing    |

Window



|Method                         |Description                         |
|-------------------------------|------------------------------------|
|`Window:AddTab(Options)`       |Adds a tab and returns it           |
|`Window:Show()`                |Shows window with animation         |
|`Window:Hide()`                |Hides window with animation         |
|`Window:Toggle()`              |Toggles visibility                  |
|`Window:ApplyTheme(ThemeTable)`|Applies theme to window and children|
|`Window:Destroy()`             |Destroys the window                 |

AddTab Options



|Option|Type  |Description                   |
|------|------|------------------------------|
|Name  |string|Tab label                     |
|Icon  |string|Icon character shown in navbar|

Tab



|Method                   |Description                  |
|-------------------------|-----------------------------|
|`Tab:AddSection(Options)`|Adds a section and returns it|

AddSection Options

|Option|Type  |Description              |
|------|------|-------------------------|
|Name  |string|Section header label     |
|Tag   |string|Optional bottom-right tag|

Section

AddToggle

Section:AddToggle({
    Name     = "God Mode",
    Sub      = "disable damage intake",
    Default  = false,
    Flag     = "GodMode",
    Callback = function(Value) end,
})




|Option  |Type    |Default |Description       |
|--------|--------|--------|------------------|
|Name    |string  |“Toggle”|Label             |
|Sub     |string  |nil     |Subtitle          |
|Default |boolean |false   |Starting value    |
|Flag    |string  |nil     |Config key        |
|Callback|function|nil     |fn(Value: boolean)|

AddSlider

Section:AddSlider({
    Name      = "Speed",
    Min       = 0,
    Max       = 100,
    Default   = 50,
    Increment = 1,
    Unit      = "%",
    Flag      = "WalkSpeed",
    Callback  = function(Value) end,
})


|Option   |Type    |Default |Description           |
|---------|--------|--------|----------------------|
|Name     |string  |“Slider”|Label                 |
|Min      |number  |0       |Minimum               |
|Max      |number  |100     |Maximum               |
|Default  |number  |Min     |Starting value        |
|Increment|number  |1       |Step size             |
|Unit     |string  |“”      |Suffix e.g. “°” or “%”|
|Flag     |string  |nil     |Config key            |
|Callback |function|nil     |fn(Value: number)     |

AddDropdown

Section:AddDropdown({
    Name     = "Target Bone",
    Options  = { "Head", "Torso", "Root" },
    Default  = "Head",
    Multi    = false,
    Flag     = "AimbotBone",
    Callback = function(Value) end,
})


|Option  |Type    |Default   |Description               |
|--------|--------|----------|--------------------------|
|Name    |string  |“Dropdown”|Label                     |
|Options |table   |{}        |List of options           |
|Default |any     |Options[1]|Starting value            |
|Multi   |boolean |false     |Multi-select mode         |
|Flag    |string  |nil       |Config key                |
|Callback|function|nil       |fn(Value: string or table)|

AddKeybind

Section:AddKeybind({
    Name     = "Toggle Aimbot",
    Default  = Enum.KeyCode.E,
    Flag     = "AimbotKey",
    Callback = function(Key) end,
})




|Option  |Type    |Default  |Description     |
|--------|--------|---------|----------------|
|Name    |string  |“Keybind”|Label           |
|Default |KeyCode |KeyCode.F|Starting key    |
|Flag    |string  |nil      |Config key      |
|Callback|function|nil      |fn(Key: KeyCode)|

AddButton

Section:AddButton({
    Name     = "Execute",
    Sub      = "runs the action",
    Variant  = "Ok",
    Callback = function() end,
})




|Option  |Type    |Default  |Description                   |
|--------|--------|---------|------------------------------|
|Name    |string  |“Button” |Label                         |
|Sub     |string  |nil      |Subtitle                      |
|Variant |string  |“Default”|Default, Ok, Warn, Err, Accent|
|Callback|function|nil      |fn()                          |

AddTextInput

Section:AddTextInput({
    Name        = "Player Name",
    Placeholder = "Enter name...",
    Default     = "",
    Flag        = "TargetName",
    Callback    = function(Value, EnterPressed) end,
})


|Option     |Type    |Default      |Description                             |
|-----------|--------|-------------|----------------------------------------|
|Name       |string  |“TextInput”  |Label                                   |
|Placeholder|string  |“Enter text…”|Placeholder                             |
|Default    |string  |“”           |Starting value                          |
|Flag       |string  |nil          |Config key                              |
|Callback   |function|nil          |fn(Value: string, EnterPressed: boolean)|

AddColorPicker

Section:AddColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(255, 0, 0),
    Flag     = "EspColor",
    Callback = function(Color) end,
})




|Option  |Type    |Default      |Description      |
|--------|--------|-------------|-----------------|
|Name    |string  |“ColorPicker”|Label            |
|Default |Color3  |white        |Starting color   |
|Flag    |string  |nil          |Config key       |
|Callback|function|nil          |fn(Color: Color3)|

AddLabel

Section:AddLabel({
    Text  = "Some info text.",
    Color = Color3.fromHex("6effc0"),
})


|Option|Type  |Description        |
|------|------|-------------------|
|Text  |string|Label text         |
|Color |Color3|Optional text color|

AddSeparator

Section:AddSeparator()


Themes



|Name      |Description                |
|----------|---------------------------|
|Monochrome|Dark grey palette (default)|
|Crimson   |Deep red accents           |
|Neon      |Electric purple/blue       |
|Slate     |Cool blue-grey             |
|Void      |Pure black minimal         |

Custom Themes

ThemeModule:Register("Toxic", {
    Void   = Color3.fromHex("060a06"),
    Deep   = Color3.fromHex("0a100a"),
    Panel  = Color3.fromHex("0d140d"),
    Lift   = Color3.fromHex("121a12"),
    Edge   = Color3.fromHex("1e2e1e"),
    Wire   = Color3.fromHex("2a3e2a"),
    Ghost  = Color3.fromHex("3a5a3a"),
    Muted  = Color3.fromHex("527052"),
    Mid    = Color3.fromHex("789878"),
    Bright = Color3.fromHex("b0d4b0"),
    White  = Color3.fromHex("e4f4e4"),
    Ok     = Color3.fromHex("6effc0"),
    Warn   = Color3.fromHex("ffd26e"),
    Err    = Color3.fromHex("ff6e7a"),
    Accent = Color3.fromHex("6eff6e"),
})


Config System

Set a Flag on any element to enable auto save/load.

Section:AddToggle({
    Name     = "God Mode",
    Flag     = "GodMode",
    Default  = false,
    Callback = function(Value)
        -- fires on load too
    end,
})

ApexUI:SaveConfig()
ApexUI:LoadConfig()


Config is saved as a JSON file named after your ConfigKey.

Plugin System

ApexUI:RegisterPlugin({
    Name = "MyPlugin",

    OnInit = function(Apex)
        print("Initialized")
    end,

    OnWindowCreated = function(Window)
        print("Window:", Window.Title)
    end,

    OnThemeChanged = function(Theme)
        print("Theme changed")
    end,

    OnConfigSaved = function()
        print("Saved")
    end,

    OnConfigLoaded = function()
        print("Loaded")
    end,

    OnDestroy = function()
        print("Destroyed")
    end,
})


Available Hooks



|Hook            |Arguments |Description                |
|----------------|----------|---------------------------|
|OnInit          |Apex      |After library initializes  |
|OnWindowCreated |Window    |When a window is created   |
|OnTabCreated    |Tab       |When a tab is created      |
|OnSectionCreated|Section   |When a section is created  |
|OnElementCreated|Element   |When any element is created|
|OnThemeChanged  |ThemeTable|When theme changes         |
|OnConfigSaved   |none      |After config saves         |
|OnConfigLoaded  |none      |After config loads         |
|OnDestroy       |none      |Before library destroys    |

File Structure

ApexUI/
├── ApexUI.lua
├── Core/
│   ├── Theme.lua
│   ├── Animate.lua
│   ├── Util.lua
│   └── Config.lua
├── Components/
│   ├── Window.lua
│   ├── Tab.lua
│   ├── Section.lua
│   ├── Toggle.lua
│   ├── Slider.lua
│   ├── Dropdown.lua
│   ├── Keybind.lua
│   ├── Button.lua
│   ├── TextInput.lua
│   ├── ColorPicker.lua
│   ├── Label.lua
│   └── Separator.lua
├── Layout/
│   ├── Topbar.lua
│   ├── Notification.lua
│   ├── BootScreen.lua
│   └── Mobile.lua
├── Plugins/
│   └── PluginHandler.lua
└── Example.lua


License

MIT License — free to use, modify, and distribute.

Built by MuryScript.
