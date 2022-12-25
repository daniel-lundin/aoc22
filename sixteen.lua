io.input('./input-16-sample.txt')

local valves = {}
local valve_count = 0
local start_valve = nil

while true do
	local line = io.read('*line')
	if line == nil then
		break
	end

	-- Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
	local parts = line:gmatch('[^%s=;,]+')
	parts()
	local valve = parts()
	parts()
	parts()
	parts()
	local flow_rate = tonumber(parts())
	parts()
	parts()
	parts()
	parts()
	local paths = {}
	for path in parts do
		table.insert(paths, path)
	end

	if start_valve == nil then
		start_valve = valve
	end
	valves[valve] = {
		flow_rate,
		paths
	}
	valve_count = valve_count + 1
end

local function length(t)
	local l = 0
	for _ in pairs(t) do
		l = l + 1
	end
	return l
end

local function list_includes(list, element)
	for _, key in pairs(list) do
		if key == element then
			return true
		end
	end
	return false
end

local function list_position(list, element)
	for index, key in ipairs(list) do
		if key == element then
			return index
		end
	end
	return -1
end

local function unvisited_neighbours(valve, steps, neighbours, visits, unvisited_valves)
	if list_includes(visits, valve) then
		return
	end
	table.insert(visits, valve)

	for _, path in pairs(valves[valve][2]) do
		if list_includes(unvisited_valves, path) and valves[path][1] ~= 0 then
			table.insert(neighbours, { steps + 1, path})
		else
			unvisited_neighbours(path, steps + 1, neighbours, visits, unvisited_valves)
		end
	end
end

local unvisited_valves = {}
local tentative_pressures = {}
local minutes_spent = {}
for valve in pairs(valves) do
	table.insert(unvisited_valves, valve)
	tentative_pressures[valve] = 0
	minutes_spent[valve] = 0
end

local current_valve = start_valve;

local minute = 1
local total_minutes = 30
local steps = 1

print('unvisited length is', length(unvisited_valves))

while length(unvisited_valves) > 0 and current_valve do
    steps = steps + 1
    if steps > 20 then
        break
    end
	-- go in all paths
	local neighbours = {}
    print('starting at valve', current_valve)

	unvisited_neighbours(current_valve, 0, neighbours, {}, unvisited_valves)

	for _, neighbour in pairs(neighbours) do
		local steps, path = neighbour[1], neighbour[2]
        if path ~= current_valve then

            local time_left = total_minutes - steps - minute
            print('neighbour', path, ' steps', steps, minute, time_left)
            if time_left > 0 then
                local valve_pressure = (time_left) * valves[path][1] + tentative_pressures[current_valve]
                print('valve pressure', (time_left) * valves[path][1])
                if tentative_pressures[path] < valve_pressure then
                    tentative_pressures[path] = valve_pressure
                    minutes_spent[path] = minute + steps + 1
                end
            end
    end
	end

    -- remove from unvisited set
    local index = list_position(unvisited_valves, current_valve)
    print('index of current valve', index)
    if index ~= -1 then
        table.remove(unvisited_valves, index)
    end

    -- find unvisited node with highest tentative pressure
    current_valve = nil
    local highest_pressure = 0
    for _, valve in pairs(unvisited_valves) do
        if tentative_pressures[valve] > highest_pressure then
            highest_pressure = tentative_pressures[valve]
            current_valve = valve
            minute = minutes_spent[valve]
        end
    end

    print('best neighbour is', current_valve, ' minutes spent', minute)
    print('unvisited length is', length(unvisited_valves))
    print('')
    for key in pairs(valves) do
        print(key, tentative_pressures[key])
    end
    print('')
end

for key in pairs(valves) do
    print(key, tentative_pressures[key])
end


