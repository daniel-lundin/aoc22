io.input('./input-12.txt')

local mountain = {}

local start_position_x = 0
local start_position_y = 0
local goal_x = 0
local goal_y = 0

local row = 1

while true do
	local line = io.read("*line")

	if line == nil then
		break
	end

	local column = 1
	local height_line = {}
	for char in line:gmatch("%S") do
		if char == 'S' then
			table.insert(height_line, 1)
			start_position_x = column
			start_position_y = row
		elseif char == 'E' then
			table.insert(height_line, 26)
			goal_x = column
			goal_y = row
		else
			table.insert(height_line, string.byte(char) - 96)
		end
		column = column + 1
	end
	table.insert(mountain, height_line)
	row = row + 1
end


local function path_possible(x, y, dx, dy)
	local altitude = mountain[y][x]
	local new_x = x + dx
	local new_y = y + dy
	if mountain[new_y] == nil then
		return false
	end
	if mountain[new_y][new_x] == nil then
		return false
	end
	if mountain[new_y][new_x] <= altitude + 1  then
		return true
	end
	return false
end



local shortest_paths = {}
local unvisited = {}
for i in ipairs(mountain) do
	shortest_paths[i] = {}
	for j in ipairs(mountain[i]) do
		if i == start_position_y and j == start_position_x then
			shortest_paths[i][j] = 0
		else
			shortest_paths[i][j] = 1000000
		end
		table.insert(unvisited, {j, i})
	end
end

local pos_x = start_position_x
local pos_y = start_position_y

local function find_tuple_index(t, x, y)
	for i, value in ipairs(t) do
		if x == value[1] and y == value[2] then
			return i
		end
	end
end

while not (pos_x == goal_x and pos_y == goal_y) do

	local directions = {{1,0}, {-1,0}, {0,1}, {0,-1}}

	-- update neighbours tentative distances
	for _, direction in ipairs(directions) do
		if path_possible(pos_x, pos_y, direction[1], direction[2]) then
			local distance = shortest_paths[pos_y][pos_x] + 1
			if distance < shortest_paths[pos_y+direction[2]][pos_x+direction[1]] then
				shortest_paths[pos_y+direction[2]][pos_x+direction[1]] = distance
			end
		end
	end

	-- remove from unvisited set
	local unvisited_index = find_tuple_index(unvisited, pos_x, pos_y)
	table.remove(unvisited, unvisited_index)

	-- find unvisited node with lowest tentative distance
	local next_node
	local lowest_distance=100000
	for _, node in ipairs(unvisited) do
		if shortest_paths[node[2]][node[1]] < lowest_distance then
			next_node = node
			lowest_distance = shortest_paths[node[2]][node[1]]
		end
	end

	if next_node == nil then
		break
	end
	pos_x = next_node[1]
	pos_y = next_node[2]
end

print('shortest path', shortest_paths[goal_y][goal_x])
