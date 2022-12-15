io.input('./input-8.txt')

FOREST = {}
while true do
	local line = io.read('*line')
	if line == nil then break end
	table.insert(FOREST, line)
end


TREES_VISIBLE = 0

local function tree_sight(height, x, y, dx, dy)
	local row = FOREST[y]
	if row == nil then return 0 end

	local tree = tonumber(row:sub(x,x))
	if tree == nil then return 0 end
	if tree >= height then return 1 end

	return 1 + tree_sight(height, x+dx, y+dy, dx, dy)
end

HIGHEST_SCENIC_SCORE = 0
for row, value in ipairs(FOREST) do
	for column = 1, #value do
		local tree = tonumber(value:sub(column, column))
		local sight_up = tree_sight(tree, column, row-1, 0, -1)
		local sight_down = tree_sight(tree, column, row+1, 0, 1)
		local sight_left = tree_sight(tree, column-1, row, -1, 0)
		local sight_right = tree_sight(tree, column+1, row, 1, 0)
		local scenic_score = sight_up * sight_down * sight_left * sight_right

		if scenic_score > HIGHEST_SCENIC_SCORE then
			HIGHEST_SCENIC_SCORE = scenic_score
		end
	end

end

print('highest scenic score', HIGHEST_SCENIC_SCORE)
