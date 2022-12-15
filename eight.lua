io.input('./input-8.txt')

forest = {}
while true do
	local line = io.read('*line')
	if line == nil then break end
	table.insert(forest, line)
end


trees_visible = 0

function free_sight(height, x, y, dx, dy)
	local row = forest[y]
	if row == nil then return true end

	tree = tonumber(row:sub(x,x))
	if tree == nil then return true end
	if tree >= height then return false end

	return free_sight(height, x+dx, y+dy, dx, dy)
end

for row, value in ipairs(forest) do

	for column = 1, #value do
		local tree = tonumber(value:sub(column, column))
		if column == 1 or column == #value then
			trees_visible = trees_visible + 1
		elseif row == 1 or row == #value then
			trees_visible = trees_visible + 1
		else
			free_sight_up = free_sight(tree, column, row-1, 0, -1)
			free_sight_down = free_sight(tree, column, row+1, 0, 1)
			free_sight_left = free_sight(tree, column-1, row, -1, 0)
			free_sight_right = free_sight(tree, column+1, row, 1, 0)
			if free_sight_up or free_sight_down or free_sight_left or free_sight_right then
				trees_visible = trees_visible + 1
			end
		end
	end

end

print('trees visible', trees_visible)
