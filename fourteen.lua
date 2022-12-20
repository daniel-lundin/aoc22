io.input('./input-14.txt')


local rocks = {}
local SAND = 'SAND'
local ROCK = 'ROCK'

local function get_max_y()
  local max_y = 0
  for i in pairs(rocks) do
	  for j in pairs(rocks[i]) do
		  if j > max_y then
			  max_y = j
		  end
	  end
  end
  return max_y
end

local function print_rocks()
  local min_x = 1000
  local max_x = 0
  local max_y = 0
  for i in pairs(rocks) do
	  if i < min_x then
		  min_x = i
	  end
	  if i > max_x then
		  max_x = i
	  end
	  for j in pairs(rocks[i]) do
		  if j > max_y then
			  max_y = j
		  end
	  end
  end

  print(min_x, max_x)

  for y=0, max_y+1 do
	  if y < 10 then
		  io.write(y .. '  ')
	  else
		  io.write(y .. ' ')
	  end
	  for x=min_x, max_x do
		  if rocks[x] and rocks[x][y] == ROCK then
			  io.write('#')
		  elseif rocks[x] and rocks[x][y] == SAND then
			  io.write('o')
		  else
			  io.write('.')
		  end
	  end
	  print('')
  end
end

while true do
	local line = io.read('*line')
	if line == nil then
		break
	end

	local parts = line:gmatch('[^-> ]+')
	local coords = {}
	for part in parts do
		local coord = part:gmatch('[^,]+')
		local x = tonumber(coord())
		local y = tonumber(coord())
		table.insert(coords, {x, y})
	end

	for i, coord in ipairs(coords) do
		local next_coord = coords[i+1]
		if next_coord == nil then
			break
		end

		local dx = 0
		local dy = 0
		if next_coord[1] > coord[1] then
			dx = 1
		elseif coord[1] > next_coord[1] then
			dx = -1
		end
		if next_coord[2] > coord[2] then
			dy = 1
		elseif coord[2] > next_coord[2] then
			dy = -1
		end


		local length = math.max(math.abs(next_coord[1] - coord[1]), math.abs(next_coord[2] - coord[2]))

		-- fill rock lines
		local x = coord[1]
		local y = coord[2]
		for _=1,length+1 do
			if rocks[x] == nil then
				rocks[x] = {}
			end
			rocks[x][y] = ROCK
			x = x + dx
			y = y + dy
		end
	end
end

local floor_y = get_max_y() + 2

local inf = 500
for x=500-inf,500+inf do
	if rocks[x] == nil then
		rocks [x] = {}
	end

	rocks[x][floor_y] = ROCK
end

-- print_rocks()
local sand_in_abyss = false
local sands_at_rest = 0

while not sand_in_abyss do
	-- spawn sand
	local sand_x = 500
	local sand_y = 0

	local at_rest = false
	while not at_rest do
		if rocks[sand_x][sand_y+1] == nil then
			sand_y = sand_y + 1
		elseif rocks[sand_x-1] == nil then
			print('abyss for wrong reasons')
			sand_in_abyss = true
			break
		elseif rocks[sand_x-1][sand_y+1] == nil then
			sand_x = sand_x - 1
			sand_y = sand_y + 1
		elseif rocks[sand_x+1] == nil then
			print('abyss for wrong reasons')
			sand_in_abyss = true
			break
	        elseif rocks[sand_x+1][sand_y+1] == nil then
			sand_x = sand_x + 1
			sand_y = sand_y + 1
	        else
			-- print('at rest', sand_x, sand_y)
			sands_at_rest = sands_at_rest + 1
			at_rest = true
			rocks[sand_x][sand_y] = SAND
			if sand_x == 500 and sand_y == 0 then
				sand_in_abyss = true
			end
		end
	end
	-- print_rocks()
end
-- print_rocks()
print('sands at rest', sands_at_rest)

-- local Bitmap = require("bitmap")
--
-- local function write_map_to_file(path)
-- 	local bmp = Bitmap.empty_bitmap(width, height, false)
-- 	bmp:set_pixel(x,height-1,grey,grey,grey,255)
--
-- 	local output_file = io.open(path, "wb")
-- 	local bmp_data = bmp:tostring()
-- 	output_file:write(bmp_data)
-- end
