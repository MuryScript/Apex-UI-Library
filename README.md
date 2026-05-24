--[[
   ___                      __  ______
  /   |  ____  ___  _  __  / / / /  _/
 / /| | / __ \/ _ \| |/_/ / / / // /  
/ ___ |/ /_/ /  __/>  <  / /_/ // /   
/_/  |_/ .___/\___/_/|_|  \____/___/   
      /_/                              

   Apex UI Library
   Version: 1.0.0
   Author: MuryScript
   License: MIT
   GitHub: github.com/MuryScript/Apex-UI-Library
]]

--[[

QUICK START
===========

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

   Section:AddDropdown({
       Name     = "Target Bone",
       Options  = { "Head", "Torso", "Root" },
       Default  = "Head",
       Flag     = "AimbotBone",
       Callback = function(Value)
           print("Bone:", Value)
       end,
   })

   Section:AddDropdown({
       Name     = "Active Players",
       Options  = { "Player1", "Player2", "Player3" },
       Multi    = true,
       Default  = { "Player1" },
       Flag     = "TargetPlayers",
       Callback = function(Values)
           print("Players:", Values)
       end,
   })

   Section:AddKeybind({
       Name     = "Toggle Aimbot",
       Default  = Enum.KeyCode.E,
       Flag     = "AimbotKey",
       Callback = function(Key)
           print("Key:", Key.Name)
       end,
   })

   Section:AddButton({
       Name     = "Fire",
       Sub      = "executes the action",
       Variant  = "Ok",
       Callback = function()
           print("Fired")
       end,
   })

   Section:AddTextInput({
       Name        = "Player Name",
       Placeholder = "Enter name...",
       Default     = "",
       Flag        = "TargetName",
       Callback    = function(Value, EnterPressed)
           print("Name:", Value, EnterPressed)
       end,
   })

   Section:AddColorPicker({
       Name     = "ESP Color",
       Default  = Color3.fromRGB(255, 0, 0),
       Flag     = "EspColor",
       Callback = function(Color)
           print("Color:", Color)
       end,
   })

   Section:AddLabel({ Text = "Some info text here." })
   Section:AddSeparator()


API REFERENCE
=============

   ApexUI:Init(Options)
       Options.Theme       string      Starting theme name. Default: "Monochrome"
       Options.ConfigKey   string      Config file name key. Default: nil

   ApexUI:CreateWindow(Options)
       Options.Title       string      Window title
       Options.SubTitle    string      Subtitle next to title
       Options.Size        UDim2       Window size. Default: 520x440
       Options.Position    UDim2       Window position. Default: center
       Options.MinimizeKey KeyCode     Toggle key. Default: RightShift

   ApexUI:Notify(Options)
       Options.Title       string      Notification title
       Options.Content     string      Body text
       Options.Type        string      Info | Success | Warning | Error
       Options.Duration    number      Seconds. Default: 4

   ApexUI:SetTheme(Name)               Switch active theme
   ApexUI:GetTheme()                   Returns active theme name
   ApexUI:GetThemes()                  Returns table of all theme names
   ApexUI:SaveConfig()                 Save flags to disk
   ApexUI:LoadConfig()                 Load flags from disk
   ApexUI:RegisterPlugin(Plugin)       Register a plugin
   ApexUI:Destroy()                    Destroy all windows and clean up

   Window:AddTab(Options)
       Options.Name        string      Tab label
       Options.Icon        string      Icon character

   Window:Show()                       Show window with animation
   Window:Hide()                       Hide window with animation
   Window:Toggle()                     Toggle visibility
   Window:ApplyTheme(ThemeTable)       Apply theme to window and children
   Window:Destroy()                    Destroy window

   Tab:AddSection(Options)
       Options.Name        string      Section header
       Options.Tag         string      Optional bottom-right tag

   Section:AddToggle(Options)
       Options.Name        string      Label
       Options.Sub         string      Subtitle
       Options.Default     boolean     Starting value. Default: false
       Options.Flag        string      Config key
       Options.Callback    function    fn(Value: boolean)

   Section:AddSlider(Options)
       Options.Name        string      Label
       Options.Min         number      Minimum. Default: 0
       Options.Max         number      Maximum. Default: 100
       Options.Default     number      Starting value
       Options.Increment   number      Step size. Default: 1
       Options.Unit        string      Suffix e.g. "°" or "%"
       Options.Flag        string      Config key
       Options.Callback    function    fn(Value: number)

   Section:AddDropdown(Options)
       Options.Name        string      Label
       Options.Options     table       List of options
       Options.Default     any         Starting value
       Options.Multi       boolean     Multi-select mode. Default: false
       Options.Flag        string      Config key
       Options.Callback    function    fn(Value: string | table)

   Section:AddKeybind(Options)
       Options.Name        string      Label
       Options.Default     KeyCode     Starting key
       Options.Flag        string      Config key
       Options.Callback    function    fn(Key: KeyCode)

   Section:AddButton(Options)
       Options.Name        string      Label
       Options.Sub         string      Subtitle
       Options.Variant     string      Default | Ok | Warn | Err | Accent
       Options.Callback    function    fn()

   Section:AddTextInput(Options)
       Options.Name        string      Label
       Options.Placeholder string      Placeholder text
       Options.Default     string      Starting value
       Options.Flag        string      Config key
       Options.Callback    function    fn(Value: string, EnterPressed: boolean)

   Section:AddColorPicker(Options)
       Options.Name        string      Label
       Options.Default     Color3      Starting color
       Options.Flag        string      Config key
       Options.Callback    function    fn(Color: Color3)

   Section:AddLabel(Options)
       Options.Text        string      Label text
       Options.Color       Color3      Optional text color

   Section:AddSeparator()              Gradient divider


THEMES
======

   Built-in themes:
       Monochrome      Dark grey palette (default)
       Crimson         Deep red accents
       Neon            Electric purple/blue
       Slate           Cool blue-grey
       Void            Pure black minimal

   Custom theme example:
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


CONFIG SYSTEM
=============

   Set Flag on any element to enable auto save/load:

       Section:AddToggle({
           Name    = "God Mode",
           Flag    = "GodMode",
           Default = false,
           Callback = function(Value)
               -- fires on load too
           end,
       })

       ApexUI:SaveConfig()
       ApexUI:LoadConfig()

   Config is saved as JSON named after your ConfigKey.


PLUGIN SYSTEM
=============

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

   Available hooks:
       OnInit              fn(Apex)        After library initializes
       OnWindowCreated     fn(Window)      When a window is created
       OnTabCreated        fn(Tab)         When a tab is created
       OnSectionCreated    fn(Section)     When a section is created
       OnElementCreated    fn(Element)     When any element is created
       OnThemeChanged      fn(ThemeTable)  When theme changes
       OnConfigSaved       fn()            After config saves
       OnConfigLoaded      fn()            After config loads
       OnDestroy           fn()            Before library destroys


FILE STRUCTURE
==============

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


SUPPORTED EXECUTORS
===================

   Synapse X
   KRNL
   Fluxus
   Celery
   Hydrogen
   Delta
   Arceus X


LICENSE
=======

   MIT License — free to use, modify, and distribute.
   Built by MuryScript.

]]
