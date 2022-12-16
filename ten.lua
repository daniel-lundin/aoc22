io.input('./input-10.txt')

local cycle = 1
local x = 1
local x_values = {1}

while true do
	local line = io.read("*line")
	if line == nil then
		break
	end
	local parts = line:gmatch('%S+')

	local instruction = parts()
	local arg1 = parts()
	if instruction == 'addx' then
		table.insert(x_values, x)
		cycle = cycle + 2
		x = x + tonumber(arg1)
		table.insert(x_values, x)
	else
		cycle = cycle + 1
		table.insert(x_values, x)
	end
end

local cycles =  { 20, 60, 100, 140, 180, 220 }
local signal_sum = 0
for _, c in ipairs(cycles) do
	signal_sum = signal_sum + c * x_values[c]
end
print('sum', signal_sum)

for i=1,240 do
	local normalized_i = i % 40
	local val = x_values[i]
	if val == normalized_i or val == normalized_i - 1 or val == normalized_i - 2 then
		io.write('#')
	else
		io.write('.')
	end

	if i % 40 == 0 then
		print('')
	end
end
