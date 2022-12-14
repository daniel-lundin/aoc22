io.input('./input-3.txt')

function dump(obj)
	for key,value in pairs(obj) do
		print(key, value)
	end
end

function intersection(a, b) 
	intersecting_keys = {}
	for a_key in pairs(a) do
		for b_key in pairs(b) do
			if a_key == b_key then
				intersecting_keys[a_key] = true
			end
		end
	end

	return intersecting_keys
end

function get_item_prio(item)
	ascii_value = string.byte(item)
	if ascii_value >= 97 then
		return ascii_value - 96
	else
		return ascii_value - 38
	end
end


item_prio_sum = 0
while true do
	local line = io.read("*line")
	if line ~= nil then
		len = string.len(line)
		letters = {}
		for letter in line:gmatch(".") do
			table.insert(letters, letter)
		end
		left_compartment = {}
		right_compartment = {}
		for i=1,len/2 do
			left_compartment[letters[i]] = true
		end
		for i=len/2+1,len do
			right_compartment[letters[i]] = true
		end


		common = intersection(left_compartment, right_compartment)
		for key in pairs(common) do
			item_prio_sum = item_prio_sum + get_item_prio(key)
		end
	else
		break 
	end
end

print("Total item prio sum", item_prio_sum)
