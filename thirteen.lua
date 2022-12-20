io.input('./input-13.txt')

local function tokenize_line(line)
	local tokens = {}

	while string.len(line) > 0 do
		local char = line:sub(1,1)

		if char == '[' then
			table.insert(tokens, {
				s = char,
				type = 'LIST_START'
			})
			line = line:sub(2)
		elseif char == ',' then
			line = line:sub(2)
		elseif char == ' ' then
			line = line:sub(2)
		elseif char == ']' then
			table.insert(tokens, {
				s = char,
				type = 'LIST_END'
			})
			line = line:sub(2)
		else
			-- only support two digit numbers at max
			local two_digit = line:sub(1, 2)
			if tonumber(two_digit) ~=  nil then

				table.insert(tokens, {
					s = two_digit,
					type = 'NUMBER'
				})
				line = line:sub(3)

			else
				local one_digit = line:sub(1, 1)

				table.insert(tokens, {
					s = one_digit,
					type = 'NUMBER'
				})
				line = line:sub(2)
			end
		end
	end

	return tokens
end


local function parse_packet(tokens, container)

	local token = table.remove(tokens, 1)

	while token do

		if token['type'] == 'NUMBER' then
			table.insert(container, tonumber(token['s']))
		elseif token['type'] == 'LIST_START' then
			local list = {}
			parse_packet(tokens, list)
			table.insert(container, list)
		elseif token['type'] == 'LIST_END' then
			return
		end

		token = table.remove(tokens, 1)
	end
end

local YES = 'YES'
local NO = 'NO'
local UNDECIDED = 'UNDECIDED'

local function is_right_order(packet1, packet2)
	for i in ipairs(packet1) do
		-- Right side ran out of items
		if type(packet2) == 'table' then
			if packet2[i] == nil then
				return NO
			end
		end
		if type(packet1[i]) == 'number' and type(packet2[i]) == 'number' then
			if packet1[i] > packet2[i] then
				return NO
			elseif packet1[i] < packet2[i] then
				return YES
			end
		elseif type(packet1[i]) == 'table' and type(packet2[i]) == 'table' then
			local right_order = is_right_order(packet1[i], packet2[i])
			if right_order == YES then
				return YES
			elseif right_order == NO then
				return NO
			end
		else -- mixed type
			if type(packet1[i]) == 'table' then
				local right_order = is_right_order(packet1[i], {packet2[i]})
				if right_order == YES then
					return YES
				elseif right_order == NO then
					return NO
				end
			else
				local right_order = is_right_order({packet1[i]}, packet2[i])
				if right_order == YES then
					return YES
				elseif right_order == NO then
					return NO
				end
			end
		end
	end
	if #packet1 < #packet2 then
		return YES
	end
	return UNDECIDED
end

local correct_index_sum = 0
local index = 1
while true do
	local line1 = io.read("*line")
	local line2 = io.read('*line')

	local tokens1 = tokenize_line(line1)
	local tokens2 = tokenize_line(line2)

	local packet1 = {}
	local packet2 = {}
	parse_packet(tokens1, packet1)
	parse_packet(tokens2, packet2)

	if is_right_order(packet1, packet2) == YES then
		correct_index_sum = correct_index_sum + index
	end

	local delimiter = io.read('*line')

	if delimiter == nil then
		break
	end
	index = index + 1
end

print('correct index sum', correct_index_sum)
