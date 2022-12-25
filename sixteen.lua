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

local function set_length(s)
    local l = 0
	for _, value in pairs(s) do
		if value == true then
            l = l +1
		end
	end
	return l
end

local function print_set(s)
	for _, value in pairs(s) do
        print(_, value)
	end
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

local function copy_set(set)
    local copy = {}
    for key, value in pairs(set) do
        copy[key] = value
    end
    return copy
end

local function unvisited_neighbours(valve, steps, neighbours, visits, opened_valves)
	if visits[valve] then
		return
	end

    local updated_visits = copy_set(visits)
	updated_visits[valve] = true

	for _, path in pairs(valves[valve][2]) do
		if not opened_valves[path] then
			table.insert(neighbours, { steps + 1, path})
			unvisited_neighbours(path, steps + 1, neighbours, updated_visits, opened_valves)
		else
			unvisited_neighbours(path, steps + 1, neighbours, updated_visits, opened_valves)
		end
	end
end




-- calculate shortest path from all valves to each other
local shortest_paths = {}
for valve in pairs(valves) do

    shortest_paths[valve] = {}

    for destination in pairs(valves) do
        if destination ~= valve then

            local unvisited_nodes = {}
            local tentative_distances = {}
            for node in pairs(valves) do
                unvisited_nodes[node] = true
                tentative_distances[node] = 100000
            end
            tentative_distances[valve] = 0

            local current_node = valve
            -- print('current_node', current_node)

            while set_length(unvisited_nodes) > 0 do
                for _, path in pairs(valves[current_node][2]) do
                    if unvisited_nodes[path] then
                        if tentative_distances[path] > tentative_distances[current_node] + 1 then
                            tentative_distances[path] = tentative_distances[current_node] + 1
                        end
                    end
                end

                -- mark node as visited
                unvisited_nodes[current_node] = false
                -- print(current_node)
                -- print_set(unvisited_nodes)

                -- unvisisted with lowest distance 
                local lowest = 10000
                for unvisited in pairs(unvisited_nodes) do
                    if unvisited_nodes[unvisited] and tentative_distances[unvisited] < lowest then
                        lowest = tentative_distances[unvisited]
                        current_node = unvisited
                    end
                end
                -- print('unvisited nodes length', set_length(unvisited_nodes))
                -- print('next node', current_node)
                -- break
            end

            print('shortest distance '.. valve .. ' to ' .. destination .. ' ' .. tentative_distances[destination])
            shortest_paths[valve][destination] = tentative_distances[destination]
        end
    end
end

local max_pressure = 0

local function visit(valve, unvisited, minute, total_pressure, depth)
    if minute >= 30 or #unvisited == 0 or total_pressure > max_pressure then
        if total_pressure > max_pressure then
            print('setting max_pressure to', max_pressure)
            max_pressure = total_pressure
        end
        return
    end


    local new_pressure = total_pressure + (30 - minute) * valves[valve][1]
    minute = minute + 1

    for _, node in pairs(unvisited) do
        local distance = shortest_paths[valve][node]

        if depth == 0 then
            print('node', node)
        end
        local left_to_visit = {}
        for _, node_left in  pairs(unvisited) do
            if node_left ~= node then
                table.insert(left_to_visit, node_left)
            end
        end
        if depth == 0 then
            print('left_to_visit', left_to_visit[1])
        end
        table.sort(left_to_visit, function(a, b)
            return valves[a][1] > valves[b][1]
        end)
        visit(node, left_to_visit, minute + distance, new_pressure, depth + 1)
    end
end

local unvisited = {}
for valve in pairs(valves) do
    if valve ~= start_valve then
        table.insert(unvisited, valve)
    end
end
visit(start_valve, unvisited, 0, 0, 0)
print('max pressure', max_pressure)

-- local function walk(valve, minute, total_pressure, opened_valves, path, depth)
--     if total_pressure > max_pressure then
--         max_pressure = total_pressure
--     end
-- 
--     if minute > 30 then
--         -- print('time up', total_pressure)
--         -- if path:find('DD') == 1 then
--         --     print('path', path, total_pressure, minute)
--         -- end
--         return
--     end
-- 
--     -- if depth > 2 then
--     --     return
--     -- end
-- 
-- 
--     local pressure_flow = valves[valve][1]
--     if not opened_valves[valve] and pressure_flow > 0 then
--         local updated_opened = copy_set(opened_valves)
--         updated_opened[valve] = true
--         local time_left = 30 - minute
--         local pressure_release = time_left * valves[valve][1]
--         -- print('opened', valve, pressure_release)
--         walk(valve, minute + 1, total_pressure + pressure_release, updated_opened, path .. 'Opened ' .. valve .. ', ', depth + 1)
--     else
--         -- local directions = {}
-- 
-- 
--         local directions = valves[valve][2]
--         for _, next_valve in pairs(directions) do
-- 
--             walk(next_valve, minute + 1, total_pressure, opened_valves, path .. next_valve  .. ', ', depth + 1)
--         end
--         -- unvisited_neighbours(valve, minute, directions, {}, opened_valves)
--         -- table.sort(directions, function(a, b)
--         --     return valves[a[2]][1] > valves[b[2]][1]
--         -- end)
-- 
--         -- for _, direction in pairs(directions) do
--         --     local steps, neighbour_valve = direction[1], direction[2]
--         --     if neighbour_valve ~= valve then
--         --         -- print(steps, neighbour_valve)
--         --         walk(neighbour_valve, minute + steps, total_pressure, opened_valves, path .. neighbour_valve  .. ', ', depth + 1)
--         --     end
--         -- end
--     end
-- end
-- 
-- walk(start_valve, 1, 0, {}, '', 0)
-- print('max', max_pressure)
-- end
