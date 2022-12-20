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

local function packet_to_string(packet)
	local s = ''
	for index, part in ipairs(packet) do
		if type(part) == 'number' then
			s = s .. part
		elseif type(part) == 'table' then

			s = s .. '[' .. packet_to_string(part) .. ']'
		end

		if index ~= #packet then
			s = s .. ', '
		end
	end
	return s
end

local packets = {}

while true do
	local line = io.read("*line")
	if line == nil then
		break
	elseif line == '' then
	else
		local tokens = tokenize_line(line)

		local packet = {}
		parse_packet(tokens, packet)
		table.insert(packets, packet)
	end


end

-- insert delimiters
local delimiter1 = {}
parse_packet(tokenize_line('[[2]]'), delimiter1)
local delimiter2 = {}
parse_packet(tokenize_line('[[6]]'), delimiter2)
table.insert(packets, delimiter1)
table.insert(packets, delimiter2)

table.sort(packets, function (packet1, packet2)
	return is_right_order(packet1, packet2) == YES
end)

local delimiter1_index
local delimiter2_index
for index, packet in ipairs(packets) do
	local as_string = packet_to_string(packet)
	if as_string == '[[2]]' then
		delimiter1_index = index
	end
	if as_string == '[[6]]' then
		delimiter2_index = index
	end
end

print('indices', delimiter1_index, delimiter2_index, delimiter1_index * delimiter2_index)
