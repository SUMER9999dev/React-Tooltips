--! native
--! optimize 2

local function LengthTable(t: {[any]: any})
	local length = 0

	for _, _ in pairs(t) do
		length += 1
	end

	return length
end


local function DeepEqual(first: any, second: any)
	if typeof(first) ~= typeof(second) then
		return false
	end

	if typeof(first) ~= 'table' then
		return first == second
	end

	if LengthTable(first) ~= LengthTable(second) then
		return false
	end

	for key, first_value in pairs(first) do
		local second_value = second[key]

		if not DeepEqual(first_value, second_value) then
			return false
		end
	end

	return true
end


return DeepEqual