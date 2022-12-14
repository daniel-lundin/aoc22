io.input('./input-16.txt')

local valves = {}
local valve_count = 0

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

	valves[valve] = {
		flow_rate,
		paths
	}
	valve_count = valve_count + 1
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


-- calculate shortest path from all valves to each other
local shortest_paths = {}
for valve in pairs(valves) do

    shortest_paths[valve] = {}

    for destination in pairs(valves) do
        if destination ~= valve and valves[destination][1] > 0 then

            local unvisited_nodes = {}
            local tentative_distances = {}
            for node in pairs(valves) do
                unvisited_nodes[node] = true
                tentative_distances[node] = 100000
            end
            tentative_distances[valve] = 0

            local current_node = valve

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

                -- unvisisted with lowest distance 
                local lowest = 10000
                for unvisited in pairs(unvisited_nodes) do
                    if unvisited_nodes[unvisited] and tentative_distances[unvisited] < lowest then
                        lowest = tentative_distances[unvisited]
                        current_node = unvisited
                    end
                end
            end

            shortest_paths[valve][destination] = tentative_distances[destination]
        end
    end
end

local max_pressure = 0
local total_minutes = 26

local function visit(valve, unvisited, minute, total_pressure, is_elephant)
    local new_pressure = total_pressure
    local pressure_addition = (total_minutes - minute) * valves[valve][1]
    if pressure_addition > 0 then
        new_pressure = new_pressure + pressure_addition
        minute = minute + 1 -- spend one minute to open valve
    end

    if #unvisited == 0 or minute >= total_minutes then
        if new_pressure > max_pressure then
            max_pressure = new_pressure
        end
        return
    end

    if max_pressure > 0 then
        local potential_pressure_left = 0
        for _, node in pairs(unvisited) do
            if is_elephant then
                potential_pressure_left = potential_pressure_left + valves[node][1] * (total_minutes - minute)
            else
                potential_pressure_left = potential_pressure_left + valves[node][1] * (total_minutes)
            end
        end
        -- is this a dead end?
        if max_pressure > new_pressure + potential_pressure_left then
            -- print('giving up, max potential', new_pressure + potential_pressure_left, potential_pressure_left, max_pressure)
            return
        end
    end

    for _, node in pairs(unvisited) do
        local distance = shortest_paths[valve][node]

        local left_to_visit = {}
        for _, node_left in pairs(unvisited) do
            if node_left ~= node then
                table.insert(left_to_visit, node_left)
            end
        end

        table.sort(left_to_visit, function(a, b)
            return valves[a][1] > valves[b][1]
        end)

        if not is_elephant and #left_to_visit > 6 and #left_to_visit < 9 then
            local new_pressure_addition = math.floor(math.max((total_minutes - minute - distance) * valves[node][1], 0))
            visit('AA', left_to_visit, 1, new_pressure + new_pressure_addition, true)

        end
        -- regular walk
        visit(node, left_to_visit, minute + distance, new_pressure, is_elephant)
    end
end

local unvisited = {}
for valve in pairs(valves) do
     if valve ~= 'AA' and valves[valve][1] > 0 then
         table.insert(unvisited, valve)
     end
end

visit('AA', unvisited, 1, 0, false)
print('max pressure', max_pressure)
