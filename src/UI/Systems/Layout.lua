local Layout = {}

function Layout.ApplyList(frame, padding)
	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, padding or 6)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = frame

	return list
end

return Layout
