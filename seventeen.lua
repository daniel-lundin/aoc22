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

local function draw_chamber(falling_rock, rows)
    local highest_y = 0


    for x in pairs(chamber) do
        for y in pairs(chamber[x]) do
            if y > highest_y then
                highest_y = y
            end
        end
    end

    highest_y = highest_y + 6

    local from = 0
    if rows then
        from = highest_y - rows
    end
    for i=from,highest_y do
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


local function simulate(steps, jet_index_start, shape_index_start, checker_func)
    local jet_index = jet_index_start
    local shape_index = shape_index_start
    for i=1,steps do
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

        local abort = false
        while true do
            local jet = jets[jet_index]
            if jet_index == #jets then
                jet_index = 1
            else
                jet_index = jet_index + 1
            end

            local displaced_rock = jet_displace(falling_rock, jet)
            local fallen_rock = apply_gravity(displaced_rock)

            if not fallen_rock then
                for x in pairs(displaced_rock) do
                    if not chamber[x] then
                        chamber[x] = {}
                    end
                    for y in pairs(displaced_rock[x]) do
                        chamber[x][y] = true
                    end
                end

                if checker_func then
                    if checker_func(i, jet_index, shape_index) then
                        abort = true
                    end
                end
                break
            end
            falling_rock = fallen_rock
        end

        if abort then return end

        if shape_index == #rock_shapes then
            shape_index = 1
        else
            shape_index = shape_index + 1
        end
    end
end

local shape_repeat = -1
local jet_repeat = -1
local repeat_start_y = -1
local repeat_height = -1
local repeat_iteration_start = -1
local repeat_iterations = -1

simulate(10000, 1, 1, function (iteration, jet_index, shape_index)
    -- check for repeat
    local highest_y = 0
    for x in pairs(chamber) do
        for y in pairs(chamber[x]) do
            if y > highest_y then
                highest_y = y
            end
        end
    end
    local fills = 0
    for x=0,6 do
        if chamber[x] and chamber[x][highest_y] then
            fills = fills + 1
        end
    end
    if fills == 7 then
        print('full row at', iteration, jet_index, shape_index)
        if jet_repeat == -1 then
            jet_repeat = jet_index
            shape_repeat = shape_index
            repeat_start_y = highest_y
            repeat_iteration_start = iteration
        else
            if jet_index == jet_repeat and shape_index == shape_repeat then
                print('found repeat at ', iteration)
                print('height', highest_y - repeat_start_y)
                print('repeat iterations', iteration - repeat_iteration_start)
                repeat_iterations = iteration - repeat_iteration_start
                repeat_height = highest_y - repeat_start_y
                return true
            end
        end
    end
end)

local simulations = 1000000000000

local left_overs = (simulations - repeat_iteration_start) % repeat_iterations
local repeats = math.floor((simulations - repeat_iteration_start) / repeat_iterations)

-- simulate rest
chamber = {}
if shape_repeat == #rock_shapes then
    shape_repeat = 1
else
    shape_repeat = shape_repeat + 1
end
simulate(left_overs, jet_repeat, shape_repeat)

local highest_y = 0

for x in pairs(chamber) do
    for y in pairs(chamber[x]) do
        if y > highest_y then
            highest_y = y
        end
    end
end

print('highest_y', highest_y)
print('total height', (repeat_start_y + 1) + repeats * repeat_height + (highest_y + 1))
