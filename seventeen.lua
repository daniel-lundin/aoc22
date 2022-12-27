io.input('./input-17.txt')

local line = io.read('*line')
local parts = line:gmatch('.')
local jets = {}
for part in parts do
    if part == '<' then
        table.insert(jets, -1)
    else
        table.insert(jets, 1)
    end
end

local rock_shapes = {
    {
        [0] = {
            [0] = true
        },
        [1] = {
            [0] = true
        },
        [2] = {
            [0] = true
        },
        [3] = {
            [0] = true
        },
    },
    {
        [0] = {
            [1] = true
        },
        [1] = {
            [0] = true,
            [1] = true,
            [2] = true
        },
        [2] = {
            [1] = true
        }
    },
    {
        [0] = {
            [0] = true,
        },
        [1] = {
            [0] = true
        },
        [2] = {
            [0] = true,
            [1] = true,
            [2] = true
        }
    },
    {
        [0] = {
            [0] = true,
            [1] = true,
            [2] = true,
            [3] = true
        }
    },
    {
        [0] = {
            [0] = true,
            [1] = true
        },
        [1] = {
            [0] = true,
            [1] = true,
        },
    },
}

local function shape_height(shape)
    local max_height = 0
    for x in pairs(shape) do
        if shape[x] then
            for y in pairs(shape[x]) do
                if y + 1 > max_height then
                    max_height = y + 1
                end
            end
        end
    end
    return max_height
end

local chamber = {}

print('1', shape_height(rock_shapes[1]))
print('2', shape_height(rock_shapes[2]))
print('3', shape_height(rock_shapes[3]))
print('4', shape_height(rock_shapes[4]))
print('5', shape_height(rock_shapes[5]))

local function draw_chamber(falling_rock)
    local highest_y = 0


    for x in pairs(chamber) do
        for y in pairs(chamber[x]) do
            if y > highest_y then
                highest_y = y
            end
        end
    end

    highest_y = highest_y + 6

    for i=0,highest_y do
        local y = highest_y - i
        local row_string = '|'
        for x=0,6 do
            if falling_rock and falling_rock[x] and falling_rock[x][y] then
                row_string = row_string .. '@'
            elseif chamber[x] and chamber[x][y] then
                row_string = row_string .. '#'
            else
                row_string = row_string .. '.'
            end
        end
        print(row_string .. '|')
     end
     print('+-------+')
    -- draw falling rock
    -- draw stopped rocks
end

local function jet_displace(shape, direction)
    local new_shape = {}
    for x in pairs(shape) do
        for y in pairs(shape[x]) do
            local new_x = x + direction
            if new_x < 0 or new_x > 6 then
                return shape
            end
            if chamber[new_x] and chamber[new_x][y] then
                return shape
            end
            if not new_shape[new_x] then
                new_shape[new_x] = {}
            end
            new_shape[new_x][y] = shape[x][y]
        end
    end
    return new_shape
end

local function apply_gravity(shape)
    local new_shape = {}
    for x in pairs(shape) do
        new_shape[x] = {}
        for y in pairs(shape[x]) do
            local new_y = y - 1
            if new_y < 0 then
                return nil
            end
            if chamber[x] and chamber[x][new_y] then
                return nil
            end
            new_shape[x][new_y] = true
        end
    end
    return new_shape
end

local shape_index = 1
local jetindex = 1

for _=1,2022 do
    -- heighest rock
    local highest_ground = 0
    for x in pairs(chamber) do
        for y in pairs(chamber[x]) do
            if y >= highest_ground then
                highest_ground = y + 1
            end
        end
    end
    local spawn_y = highest_ground + 3

    -- spawn rock
    local falling_rock = {}
    for x in pairs(rock_shapes[shape_index]) do
        for y in pairs(rock_shapes[shape_index][x]) do
            if not falling_rock[x + 2] then
               falling_rock[x + 2] = {}
            end
            falling_rock[x + 2][y + spawn_y] = true
        end
    end

    -- draw_chamber(falling_rock)
    while true do
        local jet = jets[jetindex]
        if jetindex == #jets then
            jetindex = 1
        else
            jetindex = jetindex + 1
        end

        -- displace
        -- print('jet push:')
        local displaced_rock = jet_displace(falling_rock, jet)
        -- draw_chamber(displaced_rock)
        -- gravity
        -- print('falls 1 unit:')
        local fallen_rock = apply_gravity(displaced_rock)
        -- draw_chamber(falling_rock)
        if not fallen_rock then
            for x in pairs(displaced_rock) do
                if not chamber[x] then
                    chamber[x] = {}
                end
                for y in pairs(displaced_rock[x]) do
                    chamber[x][y] = true
                end
            end
            -- draw_chamber()
            break
        end
        falling_rock = fallen_rock
        -- draw_chamber(falling_rock)
    end

    if shape_index == #rock_shapes then
        shape_index = 1
    else
        shape_index = shape_index + 1
    end
end

local highest_ground = 0
for x in pairs(chamber) do
    for y in pairs(chamber[x]) do
        if y >= highest_ground then
            highest_ground = y + 1
        end
    end
end

print('highest ground', highest_ground)
