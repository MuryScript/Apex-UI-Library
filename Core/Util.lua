local Util = {}
Util.__index = Util

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

function Util:IsMobile()
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

function Util:IsPC()
	return UserInputService.MouseEnabled
end

function Util:IsConsole()
	return UserInputService.GamepadEnabled and not UserInputService.MouseEnabled
end

function Util:GetDevice()
	if self:IsMobile() then return "Mobile" end
	if self:IsConsole() then return "Console" end
	return "PC"
end

function Util:GetScreenSize()
	return workspace.CurrentCamera.ViewportSize
end

function Util:GetScreenScale()
	local Size = self:GetScreenSize()
	local BaseWidth = 1920
	return math.clamp(Size.X / BaseWidth, 0.5, 1.5)
end

function Util:Lerp(A, B, T)
	return A + (B - A) * T
end

function Util:LerpColor(A, B, T)
	return Color3.new(
		self:Lerp(A.R, B.R, T),
		self:Lerp(A.G, B.G, T),
		self:Lerp(A.B, B.B, T)
	)
end

function Util:Round(Value, Decimal)
	local Factor = 10 ^ (Decimal or 0)
	return math.round(Value * Factor) / Factor
end

function Util:Clamp(Value, Min, Max)
	return math.clamp(Value, Min, Max)
end

function Util:Map(Value, InMin, InMax, OutMin, OutMax)
	return OutMin + ((Value - InMin) / (InMax - InMin)) * (OutMax - OutMin)
end

function Util:PadStart(Str, Length, Char)
	Str = tostring(Str)
	Char = Char or "0"
	while #Str < Length do
		Str = Char .. Str
	end
	return Str
end

function Util:Timestamp()
	local T = os.date("*t")
	return string.format("%s:%s:%s",
		self:PadStart(T.hour, 2),
		self:PadStart(T.min, 2),
		self:PadStart(T.sec, 2)
	)
end

function Util:RandomId(Length)
	Length = Length or 8
	local Chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local Id = ""
	for _ = 1, Length do
		local Index = math.random(1, #Chars)
		Id = Id .. Chars:sub(Index, Index)
	end
	return Id
end

function Util:TableContains(Table, Value)
	for _, V in ipairs(Table) do
		if V == Value then return true end
	end
	return false
end

function Util:TableKeys(Table)
	local Keys = {}
	for K in pairs(Table) do
		table.insert(Keys, K)
	end
	return Keys
end

function Util:DeepCopy(Original)
	local Copy = {}
	for K, V in pairs(Original) do
		if type(V) == "table" then
			Copy[K] = self:DeepCopy(V)
		else
			Copy[K] = V
		end
	end
	return Copy
end

function Util:Debounce(Fn, Wait)
	local LastCall = 0
	return function(...)
		local Now = tick()
		if Now - LastCall >= Wait then
			LastCall = Now
			return Fn(...)
		end
	end
end

function Util:Throttle(Fn, Wait)
	local Waiting = false
	return function(...)
		if Waiting then return end
		Waiting = true
		Fn(...)
		task.delay(Wait, function()
			Waiting = false
		end)
	end
end

function Util:Connect(Signal, Fn)
	local Connection = Signal:Connect(Fn)
	return Connection
end

function Util:DisconnectAll(Connections)
	for _, Connection in ipairs(Connections) do
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
end

function Util:MakeDraggable(Frame, Handle)
	Handle = Handle or Frame
	local Dragging = false
	local DragStart = nil
	local StartPos = nil

	Handle.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPos = Frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then return end
		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then
			local Delta = Input.Position - DragStart
			Frame.Position = UDim2.new(
				StartPos.X.Scale,
				StartPos.X.Offset + Delta.X,
				StartPos.Y.Scale,
				StartPos.Y.Offset + Delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)
end

function Util:Create(ClassName, Properties, Children)
	local Object = Instance.new(ClassName)
	for Key, Value in pairs(Properties or {}) do
		Object[Key] = Value
	end
	for _, Child in ipairs(Children or {}) do
		Child.Parent = Object
	end
	return Object
end

function Util:ApplyCorner(Object, Radius)
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, Radius or 4)
	Corner.Parent = Object
	return Corner
end

function Util:ApplyPadding(Object, Top, Right, Bottom, Left)
	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop    = UDim.new(0, Top    or 0)
	Padding.PaddingRight  = UDim.new(0, Right  or 0)
	Padding.PaddingBottom = UDim.new(0, Bottom or 0)
	Padding.PaddingLeft   = UDim.new(0, Left   or 0)
	Padding.Parent = Object
	return Padding
end

function Util:ApplyStroke(Object, Color, Thickness, Transparency)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color        = Color or Color3.new(1, 1, 1)
	Stroke.Thickness    = Thickness or 1
	Stroke.Transparency = Transparency or 0
	Stroke.Parent = Object
	return Stroke
end

function Util:ApplyListLayout(Object, Direction, Padding, HAlign, VAlign)
	local Layout = Instance.new("UIListLayout")
	Layout.FillDirection       = Direction or Enum.FillDirection.Vertical
	Layout.Padding             = UDim.new(0, Padding or 0)
	Layout.HorizontalAlignment = HAlign or Enum.HorizontalAlignment.Left
	Layout.VerticalAlignment   = VAlign or Enum.VerticalAlignment.Top
	Layout.SortOrder           = Enum.SortOrder.LayoutOrder
	Layout.Parent = Object
	return Layout
end

function Util:GetTextSize(Text, FontSize, Font, FrameSize)
	return game:GetService("TextService"):GetTextSize(
		Text,
		FontSize,
		Font or Enum.Font.GothamMedium,
		FrameSize or Vector2.new(math.huge, math.huge)
	)
end

return Util
