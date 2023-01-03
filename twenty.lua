io.input('./input-20.txt')


local encrypted = {}
local decryption_key = 811589153


while true do
    local line = io.read('*line')

    if line == nil then
        break
    end

    table.insert(encrypted, tonumber(line) * decryption_key)
end


local nodes = {}
local indices = {}

local zero_position = -1
for i in ipairs(encrypted) do
    local node = {
        value = encrypted[i],
        prev = nodes[i - 1],
        next = nil
    }
    if encrypted[i] == 0 then
        zero_position = i
    end
    table.insert(nodes, node)
    table.insert(indices, node)
end

for i, node in ipairs(nodes) do
    if i == 1 then
        node['prev'] = nodes[#nodes]
    end
    if nodes[i + 1] == nil then
        node['next'] = nodes[1]
    end
    if i ~= 1 then
        nodes[i - 1]['next'] = node
    end
end
-- tie ends
nodes[#nodes]['next'] = nodes[1]
nodes[1]['prev'] = nodes[#nodes]



local function mix_list() 
    for i, num in ipairs(encrypted) do
        local node = indices[i]

        local direction = 1
        if num < 0 then
            direction = -1
        end

        local moves = math.abs(num) % (#encrypted - 1)
        for _=1,moves do
            if direction == 1 then
                local next_node = node['next']
                node['prev']['next'] = next_node
                next_node['prev'] = node['prev']
                node['prev'] = next_node
                node['next'] = next_node['next']
                next_node['next']['prev'] = node
                next_node['next'] = node
            else
                local prev_node = node['prev']
                node['prev'] = prev_node['prev']
                prev_node['prev']['next'] = node

                node['next']['prev'] = prev_node
                prev_node['next'] = node['next']

                node['next'] = prev_node
                prev_node['prev'] = node
            end
        end
    end
end

for i=1,10 do
    mix_list()
end

local function calculate_groove_coordinate()
    local groove_coordinate = 0
    local node = indices[zero_position]
    for _=1,1000 do
        node = node['next']
    end
    groove_coordinate = groove_coordinate + node['value']

    node = indices[zero_position]
    for _=1,2000 do
        node = node['next']
    end
    groove_coordinate = groove_coordinate + node['value']
    node = indices[zero_position]
    for _=1,3000 do
        node = node['next']
    end
    groove_coordinate = groove_coordinate + node['value']

    return groove_coordinate
end

print('groove', calculate_groove_coordinate())
