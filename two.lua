io.input('./input-2.txt')

-- Rock paper scissors

function match_result(opponent_move, my_move)
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

function symbol_point(symbol)
	if symbol == 'Rock' then
		return 1
	elseif symbol == 'Paper' then
		return 2
	else
		return 3
	end
end

function to_symbol(value)
	if value == 'A' or value == 'X' then
		return 'Rock'
	elseif value == 'B' or value == 'Y' then
		return 'Paper'
	else 
		return 'Scissors'
	end
end

points = 0

while true do
	local line = io.read("*line")
	if line ~= nil then
		splitter = string.gmatch(line, '%S')
		opponent_move = to_symbol(splitter())
		my_move = to_symbol(splitter())

		points = points + match_result(opponent_move, my_move) + symbol_point(my_move)

	else
		break 
	end
end

print("Total points", points)
