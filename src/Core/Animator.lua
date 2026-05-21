local TweenService = game:GetService("TweenService")

local Animator = {}
Animator.__index = Animator

function Animator.new()
	return setmetatable({}, Animator)
end

function Animator:Tween(object, properties, duration, style, direction)
	local Tween = TweenService:Create(
		object,
		TweenInfo.new(
			duration or 0.25,
			style or Enum.EasingStyle.Quint,
			direction or Enum.EasingDirection.Out
		),
		properties
	)

	Tween:Play()

	return Tween
end

return Animator
