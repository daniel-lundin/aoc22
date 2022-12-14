io.input('./input-5.txt')

--     [D]    
-- [N] [C]    
-- [Z] [M] [P]
--  1   2   3 

stacks = {
	'DLJRVGF',
	'TPMBVHJS',
	'VHMFDGPC',
	'MDPNGQ',
	'JLHNF',
	'NFVQDGTZ',
	'FDBL',
	'MJBSVDN',
	'GLD',
}

--     [S] [C]         [Z]            
-- [F] [J] [P]         [T]     [N]    
-- [G] [H] [G] [Q]     [G]     [D]    
-- [V] [V] [D] [G] [F] [D]     [V]    
-- [R] [B] [F] [N] [N] [Q] [L] [S]    
-- [J] [M] [M] [P] [H] [V] [B] [B] [D]
-- [L] [P] [H] [D] [L] [F] [D] [J] [L]
-- [D] [T] [V] [M] [J] [N] [F] [M] [G]
--  1   2   3   4   5   6   7   8   9 

function print_stacks()
	print("DUMPTED STACKS")
	for key, value in ipairs(stacks) do
		print(value)
	end
end

function apply_procedure(amount, from, to)
	local popped_stacks = string.sub(stacks[from], string.len(stacks[from]) - amount + 1, string.len(stacks[from]))
	local left_in_stack = string.sub(stacks[from], 1, string.len(stacks[from]) - amount)

	stacks[to] = stacks[to] .. string.reverse(popped_stacks)
	stacks[from] = left_in_stack
end

while true do
	local line = io.read("*line")
	if line == nil then
		break
	end

	parts = line:gmatch('%d+')
	local amount, from, to = tonumber(parts()), tonumber(parts()), tonumber(parts())

	apply_procedure(amount, from, to)
end

for key, value in ipairs(stacks) do
	print(string.sub(value, string.len(value)))
end

