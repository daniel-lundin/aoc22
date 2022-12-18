io.input('./input-12-sample.txt')

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

local function copy(t)
	local new = {}
	for i in pairs(t) do
		new[i] = {}
		for j in pairs(t[i]) do
			new[i][j] = t[i][j]
		end
	end
	return new
end

local function debug(t)
	for i in pairs(t) do
		for index, j in pairs(t[i]) do
			io.write(index .. ',' .. i .. ' ')
		end
	end
	print('')
end

local function dump_visits(t)
	for i in ipairs(t) do
		for _, steps in ipairs(t[i]) do
			if steps == 1000000 then
				io.write(' ')
			else
				io.write('x')
			end
		end
		print('')
	end
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

local shortest_path = 10000000
local counter = 1

local function get_altitude(x, y)
	if mountain[y] == nil then
		return -1
	end
	if mountain[y][x] == nil then
		return -1
	end
	return mountain[y][x]
end

local function walk(pos_x, pos_y, steps, visits, path, shortest_paths)
	counter = counter + 1
	if counter % 10000 == 0 then
		dump_visits(shortest_paths)
	end
	if steps > shortest_path then
		return
	end
	if visits[pos_y][pos_x] == true then
		return
	end

	if shortest_paths[pos_y][pos_x] < steps then
		return
	end
	shortest_paths[pos_y][pos_x] = steps

	local new_path  = path .. ' ' .. pos_x .. ',' .. pos_y

	local new_visits = copy(visits)
	new_visits[pos_y][pos_x] = true

	if pos_x == goal_x and pos_y == goal_y then
		if steps < shortest_path then
			shortest_path = steps
		end
		return
	end

	-- prioratize paths with higher altitude
	local directions = {{1,0}, {-1,0}, {0,1}, {0,-1}}

	table.sort(directions, function(d1, d2)
		local altitude1 = get_altitude(pos_x + d1[1], pos_y + d1[2])
		local altitude2 = get_altitude(pos_x + d2[1], pos_y + d2[2])
		return altitude1 > altitude2
	end)

	for _, direction in ipairs(directions) do
		if path_possible(pos_x, pos_y, direction[1], direction[2]) then
			walk(pos_x + direction[1], pos_y + direction[2], steps + 1, new_visits, new_path, shortest_paths)
		end
	end
end

local visited_squares = {}
local shortest_paths = {}
for i in ipairs(mountain) do
	visited_squares[i] = {}
	shortest_paths[i] = {}
	for j in ipairs(mountain[i]) do
		shortest_paths[i][j] = 1000000
		visited_squares[i][j] = false
	end
end

walk(start_position_x, start_position_y, 0, visited_squares, '', shortest_paths)

print('shortest path', shortest_path)
