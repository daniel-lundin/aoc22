io.input('./input-11.txt')

local function parse_starting_items(line)
	local items = {}
	local item_strings = line:gmatch("%d+")
	for item in item_strings do
		table.insert(items, tonumber(item))
	end

	return items
end

local function parse_operation(line)
	local parts = line:gmatch('%S+')
	parts()
	parts()
	parts()
	parts()
	local operations = {}
	for part in parts do
		table.insert(operations, part)
	end
	return operations
end

local function parse_test(line)
	local parts = line:gmatch('%S+$')
	local divider = tonumber(parts())
	return divider
end

local function parse_condition(line)
	local parts = line:gmatch('%S+$')
	local monkey = tonumber(parts())
	return monkey
end

local monkeys = {}
while true do
	io.read("*line") -- Monkey index line
	table.insert(monkeys, {
		items=parse_starting_items(io.read('*line')),
		operation=parse_operation(io.read('*line')),
		test=parse_test(io.read('*line')),
		true_condition=parse_condition(io.read('*line')),
		false_condition=parse_condition(io.read('*line')),
		inspections=0,
	})
	local divider = io.read("*line")
	if divider == nil then
		break
	end
end


local function apply_operation(item, operation)
	local new
	local argument
	if operation[2] == 'old' then
		argument = item
	else
		argument = tonumber(operation[2])
	end
	if operation[1] == '+' then
		new = item + argument
	else
		new = item * argument
	end
	return math.floor(new/3)
end

local round = 0
local worry_level=0
local total_round=20

for i=1,total_round do
	for monkey_index, monkey in ipairs(monkeys) do
		while #monkey['items'] > 0 do
			local item = table.remove(monkey['items'], 1)
			local updated_worry_level = apply_operation(item, monkey['operation'])
			if updated_worry_level % monkey['test'] == 0 then
				table.insert(monkeys[monkey['true_condition'] + 1]['items'], updated_worry_level)
			else
				table.insert(monkeys[monkey['false_condition'] + 1]['items'], updated_worry_level)
			end
			monkey['inspections'] = monkey['inspections'] + 1
		end
	end
end

local inspections = {}
for monkey_index, monkey in ipairs(monkeys) do
	io.write('Monkey '.. monkey_index .. ' items: ')
	for _, item in ipairs(monkey['items']) do
		io.write(item .. ' ')
	end
	print('')
	print('Inspections ', monkey['inspections'])
	table.insert(inspections, monkey['inspections'])
end
table.sort(inspections, function(a, b) return a > b end)

print(inspections[1], inspections[2], inspections[1]*inspections[2])
