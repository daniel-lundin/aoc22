io.input('./input-19-sample.txt')

local blueprints = {}
while true do
    local line = io.read('*line')

    if line == nil then
        break
    end

    local blueprint_id = line:gmatch('Blueprint (%d+):')()
    local ore_robot_cost = line:gmatch('ore robot costs (%d+) ore')()
    local clay_robot_cost = line:gmatch('clay robot costs (%d+) ore')()
    local obsidian_robot_match = line:gmatch('obsidian robot costs (%d+) ore and (%d+) clay')
    local obsidian_robot_cost_ore, obsidian_robot_cost_clay = obsidian_robot_match()
    local geode_robot_ore_cost, geode_robot_obsidian_cost = line:gmatch('geode robot costs (%d+) ore and (%d+) obsidian')()

    table.insert(blueprints, {
        blueprint_id = blueprint_id,
        ore_robot_cost = tonumber(ore_robot_cost),
        clay_robot_cost = tonumber(clay_robot_cost),
        obsidian_robot_cost_ore = tonumber(obsidian_robot_cost_ore),
        obsidian_robot_cost_clay = tonumber(obsidian_robot_cost_clay),
        geode_robot_ore_cost=tonumber(geode_robot_ore_cost),
        geode_robot_obsidian_cost=tonumber(geode_robot_obsidian_cost)
    })
end


local function copy_state(state)
    local new_state = {}
    for key, value in pairs(state) do
        new_state[key] = value
    end
    return new_state
end

local function afford_ore_robot(blueprint, state)
    return state['ore'] >= blueprint['ore_robot_cost']
end

local function buy_ore_robot(blueprint, state)
    local new_state = copy_state(state)
    new_state['ore_robots'] = new_state['ore_robots'] + 1
    new_state['ore'] = new_state['ore'] - blueprint['ore_robot_cost']
    return new_state
end

local function afford_clay_robot(blueprint, state)
    return state['ore'] >= blueprint['clay_robot_cost']
end

local function buy_clay_robot(blueprint, state)
    local new_state = copy_state(state)
    new_state['clay_robots'] = new_state['clay_robots'] + 1
    new_state['ore'] = new_state['ore'] - blueprint['clay_robot_cost']
    return new_state
end

local function afford_obsidian_robot(blueprint, state)
    return state['ore'] >= blueprint['obsidian_robot_cost_ore'] and state['clay'] >= blueprint['obsidian_robot_cost_clay']
end

local function buy_obsidian_robot(blueprint, state)
    local new_state = copy_state(state)
    new_state['obsidian_robots'] = new_state['obsidian_robots'] + 1
    new_state['ore'] = new_state['ore'] - blueprint['obsidian_robot_cost_ore']
    new_state['clay'] = new_state['clay'] - blueprint['obsidian_robot_cost_clay']
    return new_state
end

local function afford_geode_robot(blueprint, state)
    return state['ore'] >= blueprint['geode_robot_ore_cost'] and state['obsidian'] >= blueprint['geode_robot_obsidian_cost']
end

local function buy_geode_robot(blueprint, state)
    local new_state = copy_state(state)
    new_state['geode_robots'] = new_state['geode_robots'] + 1
    new_state['obsidian'] = new_state['obsidian'] - blueprint['geode_robot_obsidian_cost']
    new_state['ore'] = new_state['ore'] - blueprint['geode_robot_ore_cost']
    return new_state
end

local max_geodes_opened = -1

local function step(minute, blueprint, state)
    if max_geodes_opened > -1 then
        if state['geode'] + 24 - minute < max_geodes_opened then
            return
        end
    end
    if minute >= 24 then
        for k,v in pairs(state) do
            print(k,v)
        end

        if state['geode'] > max_geodes_opened then
            max_geodes_opened = state['geode']
            print('new max', max_geodes_opened)
        end
        return
    end


    -- Machine yields
    state['ore'] = state['ore'] + state['ore_robots']
    state['clay'] = state['clay'] + state['clay_robots']
    state['obsidian'] = state['obsidian'] + state['obsidian_robots']
    state['geode'] = state['geode'] + state['geode_robots']


    local new_state = copy_state(state)


    if afford_geode_robot(blueprint, new_state) then
        new_state = buy_geode_robot(blueprint, new_state)
    end

    if afford_obsidian_robot(blueprint, new_state) then
        new_state = buy_obsidian_robot(blueprint, new_state)
    end

    if afford_clay_robot(blueprint, new_state) then
        new_state = buy_clay_robot(blueprint, new_state)
    end

    if new_state['ore_robots'] < 2 and afford_ore_robot(blueprint, new_state) then
        new_state = buy_ore_robot(blueprint, new_state)
    end

    step(minute+1, blueprint, new_state)
end

step(1, blueprints[1], {
    ore = 0,
    clay = 0,
    obsidian = 0,
    geode = 0,
    ore_robots = 1,
    clay_robots = 0,
    obsidian_robots = 0,
    geode_robots = 0
})


print(max_geodes_opened)
