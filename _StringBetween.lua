--[[
Example:
local data = "ABCDEF"
local result = _StringBetween(data, "AB", "EF")
The variable result will now have the value "CD".
]]--

function _StringBetween(data, from, to)
	local _, pos1 = data:find(from)
	local pos2 = data:find(to)
	return data:sub(pos1+1, pos2-1)
end
