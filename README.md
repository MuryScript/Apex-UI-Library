# Apex UI Library

A modern, high-performance UI library built for Roblox executors. Designed with a focus on clean aesthetics, smooth animations, and a dead-simple API — so you spend less time building interfaces and more time building features.

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

ApexUI:Init(Options)

Initializes the library. Must be called before anything else.



|Option   |Type  |Default     |Description                  |
|---------|------|------------|-----------------------------|
|Theme    |string|“Monochrome”|Starting theme               |
|ConfigKey|string|nil         |Key used for config file name|

ApexUI:CreateWindow(Options)

Creates and returns a Window.



|Option     |Type   |Default   |Description                 |
|-----------|-------|----------|----------------------------|
|Title      |string |“ApexUI”  |Window title                |
|SubTitle   |string |“v1.0.0”  |Subtitle shown next to title|
|Size       |UDim2  |520x440   |Window size                 |
|Position   |UDim2  |center    |Window position             |
|MinimizeKey|KeyCode|RightShift|Key to toggle window        |

ApexUI:Notify(Options)

Sends a toast notification.



|Option  |Type  |Default       |Description                  |
|--------|------|--------------|-----------------------------|
|Title   |string|“Notification”|Notification title           |
|Content |string|“”            |Body text                    |
|Type    |string|“Info”        |Info, Success, Warning, Error|
|Duration|number|4             |Seconds before dismissing    |

ApexUI:SetTheme(Name)

Switches the active theme and updates all windows.

ApexUI:GetTheme()

Returns the name of the active theme.

ApexUI:GetThemes()

Returns a table of all available theme names.

ApexUI:SaveConfig()

Saves all flagged values to disk. Returns true on success.

ApexUI:LoadConfig()

Loads config from disk and fires all flag callbacks. Returns true on success.

ApexUI:RegisterPlugin(Plugin)

Registers a plugin table with lifecycle hooks.

ApexUI:Destroy()

Destroys all windows and cleans up the ScreenGui.

Window

Window:AddTab(Options)

Adds a tab to the window navbar and returns it.



|Option|Type  |Description                   |
|------|------|------------------------------|
|Name  |string|Tab name shown on hover       |
|Icon  |string|Icon character shown in navbar|

Window:Show()

Shows the window with open animation.

Window:Hide()

Hides the window with close animation.

Window:Toggle()

Toggles window visibility.

Window:ApplyTheme(ThemeTable)

Applies a theme table to the window and all children.

Window:Destroy()

Destroys the window and disconnects all connections.

Tab

Tab:AddSection(Options)

Adds a section to the tab and returns it.



|Option|Type  |Description                       |
|------|------|----------------------------------|
|Name  |string|Section header label              |
|Tag   |string|Optional tag shown at bottom right|

Section

Section:AddToggle(Options)



|Option  |Type    |Default |Description          |
|--------|--------|--------|---------------------|
|Name    |string  |“Toggle”|Label                |
|Sub     |string  |nil     |Subtitle below label |
|Default |boolean |false   |Starting value       |
|Flag    |string  |nil     |Config key           |
|Callback|function|nil     |Called with new value|

Section:AddSlider(Options)



|Option   |Type    |Default |Description                |
|---------|--------|--------|---------------------------|
|Name     |string  |“Slider”|Label                      |
|Min      |number  |0       |Minimum value              |
|Max      |number  |100     |Maximum value              |
|Default  |number  |Min     |Starting value             |
|Increment|number  |1       |Step size                  |
|Unit     |string  |“”      |Unit suffix e.g. “°” or “%”|
|Flag     |string  |nil     |Config key                 |
|Callback |function|nil     |Called with new value      |

Section:AddDropdown(Options)



|Option  |Type        |Default   |Description                  |
|--------|------------|----------|-----------------------------|
|Name    |string      |“Dropdown”|Label                        |
|Options |table       |{}        |List of options              |
|Default |string/table|Options[1]|Starting value               |
|Multi   |boolean     |false     |Allow multiple selections    |
|Flag    |string      |nil       |Config key                   |
|Callback|function    |nil       |Called with selected value(s)|

Section:AddKeybind(Options)



|Option  |Type    |Default  |Description            |
|--------|--------|---------|-----------------------|
|Name    |string  |“Keybind”|Label                  |
|Default |KeyCode |KeyCode.F|Starting key           |
|Flag    |string  |nil      |Config key             |
|Callback|function|nil      |Called with new KeyCode|

Section:AddButton(Options)



|Option  |Type    |Default  |Description                   |
|--------|--------|---------|------------------------------|
|Name    |string  |“Button” |Label                         |
|Sub     |string  |nil      |Subtitle below label          |
|Variant |string  |“Default”|Default, Ok, Warn, Err, Accent|
|Callback|function|nil      |Called on click               |

Section:AddTextInput(Options)



|Option     |Type    |Default      |Description                           |
|-----------|--------|-------------|--------------------------------------|
|Name       |string  |“TextInput”  |Label                                 |
|Placeholder|string  |“Enter text…”|Placeholder text                      |
|Default    |string  |“”           |Starting value                        |
|Flag       |string  |nil          |Config key                            |
|Callback   |function|nil          |Called with new value and EnterPressed|

Section:AddColorPicker(Options)



|Option  |Type    |Default      |Description           |
|--------|--------|-------------|----------------------|
|Name    |string  |“ColorPicker”|Label                 |
|Default |Color3  |white        |Starting color        |
|Flag    |string  |nil          |Config key            |
|Callback|function|nil          |Called with new Color3|

Section:AddLabel(Options)



|Option|Type  |Description        |
|------|------|-------------------|
|Text  |string|Label text         |
|Color |Color3|Optional text color|

Section:AddSeparator()

Adds a horizontal gradient divider.

Themes

Five built-in themes available out of the box:



|Name      |Description              |
|----------|-------------------------|
|Monochrome|Default dark grey palette|
|Crimson   |Deep red accents         |
|Neon      |Electric purple/blue     |
|Slate     |Cool blue-grey           |
|Void      |Pure black minimal       |

Custom Themes

ApexUI:Init({ Theme = "Monochrome" })

-- After init, register via ThemeModule directly or use a plugin
local ThemeModule = -- your reference
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

Flags automatically save and load values per element. Just set a Flag on any element and call ApexUI:SaveConfig() / ApexUI:LoadConfig().

Section:AddToggle({
    Name    = "God Mode",
    Flag    = "GodMode",
    Default = false,
    Callback = function(Value)
        -- fires on load too
    end,
})

-- Save
ApexUI:SaveConfig()

-- Load
ApexUI:LoadConfig()


Config is saved as a JSON file named after your ConfigKey.

Plugin System

Plugins hook into the library lifecycle via named events.

ApexUI:RegisterPlugin({
    Name = "MyPlugin",

    OnInit = function(Apex)
        print("Library initialized")
    end,

    OnWindowCreated = function(Window)
        print("Window created:", Window.Title)
    end,

    OnThemeChanged = function(Theme)
        print("Theme changed")
    end,

    OnConfigSaved = function()
        print("Config saved")
    end,

    OnConfigLoaded = function()
        print("Config loaded")
    end,

    OnDestroy = function()
        print("Library destroyed")
    end,
})


Available Hooks



|Hook            |Arguments |Description                      |
|----------------|----------|---------------------------------|
|OnInit          |Apex      |Fires after library initializes  |
|OnWindowCreated |Window    |Fires when a window is created   |
|OnTabCreated    |Tab       |Fires when a tab is created      |
|OnSectionCreated|Section   |Fires when a section is created  |
|OnElementCreated|Element   |Fires when any element is created|
|OnThemeChanged  |ThemeTable|Fires when theme is changed      |
|OnConfigSaved   |none      |Fires after config is saved      |
|OnConfigLoaded  |none      |Fires after config is loaded     |
|OnDestroy       |none      |Fires before library is destroyed|

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

Credits

Built by MuryScript.
