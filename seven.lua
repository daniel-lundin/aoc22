io.input('./input-7.txt')
total_disk_space = 70000000
space_needed = 30000000

function create_directory(name, parent)
	return {
		['name']=name,
		['files'] = {},
		['directories'] = {},
		['parent'] = parent
	}
end

pwd = create_directory("/")
root = pwd


function execute_cd(line)
	if line == '$ cd ..' then
		pwd = pwd['parent']
	else
		dir = line:gmatch('%S+$')()
		pwd = pwd['directories'][dir]

		print('pwd is set', pwd)
	end
end

function populate_directory(ls_entry)
	if ls_entry:sub(1,3) == 'dir' then
		local name = ls_entry:gmatch('%S+$')()
		pwd['directories'][name] = create_directory(name, pwd)

	else
		local size = tonumber(ls_entry:gmatch('%d+')())
		local name = ls_entry:gmatch('%S+$')()
		pwd['files'][name] = size
	end
end

while true do
	local line = io.read('*line')
	if line == nil then
		break
	elseif line == "$ cd /" then
		pwd = root
	elseif string.sub(line, 1, 4) == '$ ls' then
	elseif string.sub(line, 1, 4) == '$ cd' then 
		execute_cd(line)
	else
		populate_directory(line)
	end
end

function dump_dir(dir, indent_size)
	local indent = string.rep(' ', indent_size)
	print(indent .. '- ' .. dir.name .. ' (dir)')
	for key, value in pairs(dir['directories']) do
		dump_dir(value, indent_size + 2)
	end
	for key, value in pairs(dir['files']) do
		local indent_length = string.len('  ' .. indent)
		print('  ' .. indent .. '- ' .. key .. ' (file size=' .. value ..')')
	end
end

function sum_file_sizes(dir)
	local file_size = 0
	for key, value in pairs(dir['directories']) do
		file_size = file_size + sum_file_sizes(value)
	end

	for key, value in pairs(dir['files']) do
		file_size = file_size + value
	end
	return file_size

end

function directory_walk(dir, visitor)
	for key, value in pairs(dir['directories']) do
		visitor(value)
		directory_walk(value, visitor)
	end

end

dump_dir(root, 0)



disk_usage =  sum_file_sizes(root)
print('total file size ', disk_usage)
free_space = total_disk_space - disk_usage 
print('free space ', free_space)
space_to_free = space_needed - free_space
print('space to free ', space_to_free)

smallest_directory_big_enough = total_disk_space
directory_walk(root, function(dir) 
	directory_size = sum_file_sizes(dir)
	if directory_size >= space_to_free and directory_size < smallest_directory_big_enough then
		smallest_directory_big_enough = directory_size
	end
end)

print('size of dir',  smallest_directory_big_enough)
