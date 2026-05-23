local Mobile = {}
Mobile.__index = Mobile

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Mobile:Adapt(Window)
	if not UserInputService.TouchEnabled then return end

	local Screen = workspace.CurrentCamera.ViewportSize
	local IsSmall = Screen.X < 600

	if IsSmall then
		self:CompactLayout(Window)
	end

	self:AddTouchDrag(Window)
	self:AddSwipeToClose(Window)
	self:ScaleForTouch(Window)
end

function Mobile:CompactLayout(Window)
	local Screen = workspace.CurrentCamera.ViewportSize

	Window.Root.Size = UDim2.new(0, Screen.X * 0.88, 0, Screen.Y * 0.62)
	Window.Root.Position = UDim2.new(0.06, 0, 0.18, 0)
	Window.Size = Window.Root.Size

	Window.NavBar.Size = UDim2.new(1, 0, 0, 36)
	Window.NavBar.Position = UDim2.new(0, 0, 0, 36)

	local NavLayout = Window.NavBar:FindFirstChildOfClass("UIListLayout")
	if NavLayout then
		NavLayout.FillDirection = Enum.FillDirection.Horizontal
		NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		NavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	end

	for _, Button in ipairs(Window.NavBar:GetChildren()) do
		if Button:IsA("TextButton") then
			Button.Size = UDim2.new(0, 36, 1, 0)
		end
	end

	Window.ContentArea.Size = UDim2.new(1, 0, 1, -72)
	Window.ContentArea.Position = UDim2.new(0, 0, 0, 72)
end

function Mobile:ScaleForTouch(Window)
	for _, Tab in ipairs(Window.Tabs) do
		for _, Section in ipairs(Tab.Sections) do
			for _, Element in ipairs(Section.Elements) do
				if Element.Frame then
					local S = Element.Frame.Size
					Element.Frame.Size = UDim2.new(
						S.X.Scale, S.X.Offset,
						S.Y.Scale, math.max(S.Y.Offset, 40)
					)
				end
			end
		end
	end
end

function Mobile:AddTouchDrag(Window)
	local Dragging  = false
	local DragStart = nil
	local StartPos  = nil

	local BeganConn = Window.Topbar.Frame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch then
			Dragging  = true
			DragStart = Input.Position
			StartPos  = Window.Root.Position
		end
	end)

	local ChangedConn = UserInputService.InputChanged:Connect(function(Input)
		if not Dragging then return end
		if Input.UserInputType == Enum.UserInputType.Touch then
			local Delta  = Input.Position - DragStart
			local Screen = workspace.CurrentCamera.ViewportSize
			local NewX = math.clamp(StartPos.X.Offset + Delta.X, 0, Screen.X - Window.Root.AbsoluteSize.X)
			local NewY = math.clamp(StartPos.Y.Offset + Delta.Y, 0, Screen.Y - Window.Root.AbsoluteSize.Y)
			Window.Root.Position = UDim2.new(0, NewX, 0, NewY)
		end
	end)

	local EndedConn = UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)

	table.insert(Window.Connections, BeganConn)
	table.insert(Window.Connections, ChangedConn)
	table.insert(Window.Connections, EndedConn)
end

function Mobile:AddSwipeToClose(Window)
	local SwipeStart    = nil
	local SwipeThreshold = 80

	local BeganConn = Window.Root.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.Touch then
			SwipeStart = Input.Position
		end
	end)

	local EndedConn = Window.Root.InputEnded:Connect(function(Input)
		if Input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not SwipeStart then return end
		local Delta = Input.Position - SwipeStart
		local AbsX  = math.abs(Delta.X)
		local AbsY  = math.abs(Delta.Y)
		if AbsY > SwipeThreshold and AbsY > AbsX and Delta.Y < 0 then
			Window:Hide()
		end
		SwipeStart = nil
	end)

	table.insert(Window.Connections, BeganConn)
	table.insert(Window.Connections, EndedConn)
end

function Mobile:IsTouch()
	return UserInputService.TouchEnabled
end

function Mobile:GetScreenSize()
	return workspace.CurrentCamera.ViewportSize
end

return Mobile
