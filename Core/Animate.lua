local Animate = {}
Animate.__index = Animate

local TweenService = game:GetService("TweenService")

local Easings = {
	Linear      = Enum.EasingStyle.Linear,
	Quad        = Enum.EasingStyle.Quad,
	Cubic       = Enum.EasingStyle.Cubic,
	Quart       = Enum.EasingStyle.Quart,
	Quint       = Enum.EasingStyle.Quint,
	Sine        = Enum.EasingStyle.Sine,
	Back        = Enum.EasingStyle.Back,
	Bounce      = Enum.EasingStyle.Bounce,
	Elastic     = Enum.EasingStyle.Elastic,
	Exponential = Enum.EasingStyle.Exponential,
	Circular    = Enum.EasingStyle.Circular,
}

local Directions = {
	In    = Enum.EasingDirection.In,
	Out   = Enum.EasingDirection.Out,
	InOut = Enum.EasingDirection.InOut,
}

local Presets = {
	Instant  = { Time = 0,    Style = Enum.EasingStyle.Linear,  Direction = Enum.EasingDirection.Out  },
	Snappy   = { Time = 0.12, Style = Enum.EasingStyle.Quart,   Direction = Enum.EasingDirection.Out  },
	Default  = { Time = 0.22, Style = Enum.EasingStyle.Quart,   Direction = Enum.EasingDirection.Out  },
	Smooth   = { Time = 0.35, Style = Enum.EasingStyle.Cubic,   Direction = Enum.EasingDirection.Out  },
	Fluid    = { Time = 0.45, Style = Enum.EasingStyle.Quint,   Direction = Enum.EasingDirection.Out  },
	Spring   = { Time = 0.5,  Style = Enum.EasingStyle.Back,    Direction = Enum.EasingDirection.Out  },
	Bounce   = { Time = 0.6,  Style = Enum.EasingStyle.Bounce,  Direction = Enum.EasingDirection.Out  },
	Elastic  = { Time = 0.55, Style = Enum.EasingStyle.Elastic, Direction = Enum.EasingDirection.Out  },
	SlideIn  = { Time = 0.3,  Style = Enum.EasingStyle.Quart,   Direction = Enum.EasingDirection.Out  },
	SlideOut = { Time = 0.22, Style = Enum.EasingStyle.Quart,   Direction = Enum.EasingDirection.In   },
	FadeIn   = { Time = 0.25, Style = Enum.EasingStyle.Sine,    Direction = Enum.EasingDirection.Out  },
	FadeOut  = { Time = 0.18, Style = Enum.EasingStyle.Sine,    Direction = Enum.EasingDirection.In   },
	Reveal   = { Time = 0.55, Style = Enum.EasingStyle.Quint,   Direction = Enum.EasingDirection.Out  },
	Collapse = { Time = 0.35, Style = Enum.EasingStyle.Quint,   Direction = Enum.EasingDirection.In   },
}

local function BuildInfo(Preset, Overrides)
	Overrides = Overrides or {}
	local Base = Presets[Preset] or Presets.Default
	return TweenInfo.new(
		Overrides.Time      or Base.Time,
		Overrides.Style     or Base.Style,
		Overrides.Direction or Base.Direction,
		Overrides.RepeatCount or 0,
		Overrides.Reverses    or false,
		Overrides.DelayTime   or 0
	)
end

function Animate:Tween(Object, Properties, Preset, Overrides)
	assert(Object, "[ApexUI] Animate:Tween() requires an Object")
	assert(Properties, "[ApexUI] Animate:Tween() requires Properties")
	local Info = BuildInfo(Preset or "Default", Overrides)
	local TweenObj = TweenService:Create(Object, Info, Properties)
	TweenObj:Play()
	return TweenObj
end

function Animate:TweenAsync(Object, Properties, Preset, Overrides)
	local TweenObj = self:Tween(Object, Properties, Preset, Overrides)
	TweenObj.Completed:Wait()
	return TweenObj
end

function Animate:FadeIn(Object, Duration)
	Object.Visible = true
	Object.BackgroundTransparency = 1
	return self:Tween(Object, { BackgroundTransparency = 0 }, "FadeIn", { Time = Duration })
end

function Animate:FadeOut(Object, Duration, Hide)
	local TweenObj = self:Tween(Object, { BackgroundTransparency = 1 }, "FadeOut", { Time = Duration })
	if Hide then
		TweenObj.Completed:Connect(function()
			Object.Visible = false
		end)
	end
	return TweenObj
end

function Animate:SlideIn(Object, Axis, StartOffset, Duration)
	Axis = Axis or "X"
	StartOffset = StartOffset or 20
	local OriginalPos = Object.Position
	if Axis == "X" then
		Object.Position = UDim2.new(
			OriginalPos.X.Scale,
			OriginalPos.X.Offset + StartOffset,
			OriginalPos.Y.Scale,
			OriginalPos.Y.Offset
		)
	else
		Object.Position = UDim2.new(
			OriginalPos.X.Scale,
			OriginalPos.X.Offset,
			OriginalPos.Y.Scale,
			OriginalPos.Y.Offset + StartOffset
		)
	end
	Object.Visible = true
	return self:Tween(Object, { Position = OriginalPos }, "SlideIn", { Time = Duration })
end

function Animate:SlideOut(Object, Axis, EndOffset, Duration, Hide)
	Axis = Axis or "X"
	EndOffset = EndOffset or 20
	local OriginalPos = Object.Position
	local TargetPos
	if Axis == "X" then
		TargetPos = UDim2.new(
			OriginalPos.X.Scale,
			OriginalPos.X.Offset + EndOffset,
			OriginalPos.Y.Scale,
			OriginalPos.Y.Offset
		)
	else
		TargetPos = UDim2.new(
			OriginalPos.X.Scale,
			OriginalPos.X.Offset,
			OriginalPos.Y.Scale,
			OriginalPos.Y.Offset + EndOffset
		)
	end
	local TweenObj = self:Tween(Object, { Position = TargetPos }, "SlideOut", { Time = Duration })
	if Hide then
		TweenObj.Completed:Connect(function()
			Object.Visible = false
			Object.Position = OriginalPos
		end)
	end
	return TweenObj
end

function Animate:Scale(Object, TargetSize, Preset, Overrides)
	return self:Tween(Object, { Size = TargetSize }, Preset or "Spring", Overrides)
end

function Animate:Color(Object, Property, TargetColor, Preset, Overrides)
	return self:Tween(Object, { [Property] = TargetColor }, Preset or "Smooth", Overrides)
end

function Animate:Transparency(Object, Property, TargetValue, Preset, Overrides)
	return self:Tween(Object, { [Property] = TargetValue }, Preset or "Default", Overrides)
end

function Animate:Sequence(Steps)
	for _, Step in ipairs(Steps) do
		local TweenObj = self:Tween(Step.Object, Step.Properties, Step.Preset, Step.Overrides)
		if Step.Await then
			TweenObj.Completed:Wait()
		end
		if Step.Delay then
			task.wait(Step.Delay)
		end
	end
end

function Animate:GetPreset(Name)
	return Presets[Name]
end

function Animate:RegisterPreset(Name, Data)
	assert(type(Name) == "string", "[ApexUI] Preset name must be a string")
	assert(Data.Time and Data.Style and Data.Direction, "[ApexUI] Preset missing required fields")
	Presets[Name] = Data
end

function Animate:StopAll(Object)
	TweenService:Create(Object, TweenInfo.new(0), {}):Play()
end

return Animate
