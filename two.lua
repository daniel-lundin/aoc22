io.input('./input-2.txt')

-- Rock paper scissors

local function match_result(opponent_move, my_move)
	if opponent_move == my_move then
		return 3
	elseif opponent_move == 'Rock' and my_move == 'Paper' then
		return 6
	elseif opponent_move == 'Paper' and my_move == 'Scissors' then
		return 6
	elseif opponent_move == 'Scissors' and my_move == 'Rock' then
		return 6
	else
		return 0
	end
end

local function symbol_point(symbol)
	if symbol == 'Rock' then
		return 1
	elseif symbol == 'Paper' then
		return 2
	else
		return 3
	end
end

local function to_symbol(value)
	if value == 'A' or value == 'X' then
		return 'Rock'
	elseif value == 'B' or value == 'Y' then
		return 'Paper'
	else
		return 'Scissors'
	end
end

local function move_needed(opponent_move, result)
	if result == 'Y' then -- Draw
		return opponent_move
	elseif result == 'X' then -- Loose
		if opponent_move == 'Rock' then
			return 'Scissors'
		elseif opponent_move == 'Paper' then
			return 'Rock'
		else
			return 'Paper'
		end
	else -- loose
		if opponent_move == 'Rock' then
			return 'Paper'
		elseif opponent_move == 'Paper' then
			return 'Scissors'
		else
			return 'Rock'
		end
	end
end

local points = 0

while true do
	local line = io.read("*line")
	if line ~= nil then
		local splitter = string.gmatch(line, '%S')
		local opponent_move = to_symbol(splitter())
		local desired_result = splitter()
		local my_move = move_needed(opponent_move, desired_result)
		points = points + match_result(opponent_move, my_move) + symbol_point(my_move)

	else
		break
	end
end

print("Total points", points)
