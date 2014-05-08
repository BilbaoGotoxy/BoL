function _StringBetween(data, from, to)
	local _, pos1 = data:find(from)
	local pos2 = data:find(to)
	local result = data:sub(pos1+1, pos2-1)
	return result
end
