local Section = {}
Section.__index = Section

function Section.new()
	return setmetatable({}, Section)
end

return Section
