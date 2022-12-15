io.input('./input-3.txt')

local function three_way_intersection(a, b, c)
	local intersecting_keys = {}
	for a_key in pairs(a) do
		for b_key in pairs(b) do
			for c_key in pairs(c) do
				if a_key == b_key and b_key == c_key then
					intersecting_keys[a_key] = true
				end
			end
		end
	end

	return intersecting_keys
end

local function get_item_prio(item)
	local ascii_value = string.byte(item)
	if ascii_value >= 97 then
		return ascii_value - 96
	else
		return ascii_value - 38
	end
end


local function tokenize_line(line)
	local letters = {}
	for letter in line:gmatch(".") do
		letters[letter] = true
	end
	return letters
end

local item_prio_sum = 0
while true do
	local lines = {io.read("*line"), io.read("*line"),  io.read("*line")}
	if lines[1] == nil then
		break
	end
	local tokenized_lines = {tokenize_line(lines[1]), tokenize_line(lines[2]), tokenize_line(lines[3])}
	local common_items = three_way_intersection(tokenized_lines[1], tokenized_lines[2], tokenized_lines[3])
	for key in pairs(common_items) do
		item_prio_sum = item_prio_sum + get_item_prio(key)
	end
end

print("Total item prio sum", item_prio_sum)
