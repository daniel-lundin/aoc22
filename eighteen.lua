io.input('./input-18.txt')

local cubes = {}
while true do
    local line = io.read('*line')
    if line == nil then
        break
    end

    local parts = line:gmatch('%d+')
    local x, y, z = tonumber(parts()), tonumber(parts()), tonumber(parts())
    if not x or not y or not z then
        print('parse error')
        break
    end
    if not cubes[x] then
        cubes[x] = {}
    end
    if not cubes[x][y] then
        cubes[x][y] = {}
    end
    if not cubes[x][y][z] then
        cubes[x][y][z] = {}
    end
    cubes[x][y][z] = 0
end

local function has_cube(x, y, z)
    return cubes[x] and cubes[x][y] and cubes[x][y][z] and cubes[x][y][z] >= 0
end

local function mark_visit(visits, x, y, z)
    if not visits[x] then
        visits[x] = {}
    end
    if not visits[x][y] then
        visits[x][y] = {}
    end
    if not visits[x][y][z] then
        visits[x][y][z] = true
    end
end

local function has_visit(visits, x, y, z)
  return visits[x] and visits[x][y] and visits[x][y][z]
end

local directions = {
    { 1,  0,  0},
    {-1,  0,  0},
    { 0,  1,  0},
    { 0, -1,  0},
    { 0,  0,  1},
    { 0,  0, -1}
}

local function walk(coord, visits, steps_without_hits)
    if has_visit(visits, coord[1], coord[2], coord[3]) then
        return
    end

    if steps_without_hits > 1 then
        return
    end


    local neighbours = 0
    for _, dir in ipairs(directions) do
        local x = coord[1] + dir[1]
        local y = coord[2] + dir[2]
        local z = coord[3] + dir[3]

        if has_cube(x, y, z) then
            -- increase exposed sides of cube
            cubes[x][y][z] = cubes[x][y][z] + 1
            neighbours = neighbours + 1
        end
    end

    if neighbours > 0 then
        mark_visit(visits, coord[1], coord[2], coord[3])
    end

    local walks = 0
    for _, dir in ipairs(directions) do
        local x = coord[1] + dir[1]
        local y = coord[2] + dir[2]
        local z = coord[3] + dir[3]
        if not has_cube(x, y, z) then
            walks  = walks + 1
            if neighbours == 0 then
                walk({x, y, z}, visits, steps_without_hits + 1)
            else
                walk({x, y, z}, visits, 0)
            end
        end
    end
end


local smallest_x = -100
for x in pairs(cubes) do
    if smallest_x == -100 or x < smallest_x then
        smallest_x = x
    end
end

local y = pairs(cubes[smallest_x])(cubes[smallest_x], nil)
local z = pairs(cubes[smallest_x][y])(cubes[smallest_x][y], nil)

walk({smallest_x - 1, y, z}, {} , 0)

local exposed_sides = 0
for x in pairs(cubes) do
    for y in pairs(cubes[x]) do
        for z in pairs(cubes[x][y]) do
            exposed_sides = exposed_sides + cubes[x][y][z]
        end
    end
end

print('exposed sides', exposed_sides)
