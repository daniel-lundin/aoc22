io.input('./input-21.txt')


local monkeys = {}

while true do
    local line = io.read('*line')

    if line == nil then
        break
    end

    local parts = line:gmatch('%S+')

    local tokens = {}

    for part in parts do
        table.insert(tokens, part)
    end

    local label = string.sub(tokens[1], 1, 4)
    if #tokens == 2 then
        monkeys[label] = {
            label = label,
            job = 'YELL',
            value = tonumber(tokens[2])
        }
    else
        monkeys[label] = {
            label = label,
            job = 'MATH',
            left = tokens[2],
            operation = tokens[3],
            right = tokens[4]
        }

    end
end

local function perform_operator(operator, left, right)
    if operator == '+' then
        return left + right
    elseif operator == '-' then
        return left - right
    elseif operator == '*' then
        return left * right
    else
        return left / right
    end
end


local function evaluate_monkey(monkey, my_number)
    if monkey['label'] == 'humn' then
        return my_number
    end
    if monkey['job'] == 'YELL' then
        return tonumber(monkey['value'])
    end


    return perform_operator(
      monkey['operation'],
      evaluate_monkey(monkeys[monkey['left']], my_number),
      evaluate_monkey(monkeys[monkey['right']], my_number)
    )
end


local target = evaluate_monkey(monkeys[monkeys['root']['right']])


local my_number = 10000000000000000
local current = evaluate_monkey(monkeys[monkeys['root']['left']], my_number)
local diff = target - current


while true do
    for pow=50,0,-1 do
        local new_number = my_number - 10 ^ pow

        local new_value = evaluate_monkey(monkeys[monkeys['root']['left']], new_number)
        local new_diff = target - new_value

        if new_diff >= 0 and new_diff <= diff then
            current = new_value
            diff = new_diff
            my_number = new_number
            break
        end
    end

    if diff == 0 then
        break
    end
end


print('my number', math.floor(my_number))
print('diff ', diff)

current = evaluate_monkey(monkeys[monkeys['root']['left']], my_number)
target = evaluate_monkey(monkeys[monkeys['root']['right']], my_number)
print('diff', current, target - current)
print('target', target)


