io.input('./input-6.txt')

local line = io.read("*line")


function first_start_marker(line)
	print('trying out', line)
	max = string.len(line)-4
	for i=1,max do
		local a = string.sub(line, i, i)
		local b = string.sub(line, i+1, i+1)
		local c = string.sub(line, i+2, i+2)
		local d = string.sub(line, i+3, i+3)
		print('chars', a,b,c,d)

		if a ~= b and a ~= c and a ~= d and b ~= c and b ~= d and c ~= d then
			return i + 3
		end
	end
end

print(first_start_marker(line))
