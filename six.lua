io.input('./input-6.txt')

local line = io.read("*line")

function count_letters(letters) 
	local count = 0
	for key,value in pairs(letters) do
		count = count + 1
	end
	return count
end

function first_start_marker(line)
	print('trying out', line)
	max = string.len(line) - 14
	for i=1,max do
		local letters = {}
		for j=1,14 do
			letters[string.sub(line, i+j, i+j)] = true
		end
		if count_letters(letters) == 14 then
			return i + 14
		end
	end
end

print(first_start_marker(line))
