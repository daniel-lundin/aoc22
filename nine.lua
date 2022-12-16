io.input('./input-9.txt')

local head = {
	x = 0,
	y = 0,
}
local tails = {}

for _=1,9 do
	table.insert(tails, { x = 0, y = 0 })
end

local tail_visits = {
}

local function mark_tail_visit(x,y)
	if tail_visits[x] == nil then
		tail_visits[x] = { [y] = true }
	else
		tail_visits[x][y] = true
	end
end

local function decrease(x)
	if x > 0 then
		return x - 1
	else
		return x + 1
	end
end

local function move_tail(head_x, head_y, tail_x, tail_y)
	local xdiff = head_x - tail_x
	local ydiff = head_y - tail_y
	local new_x = tail_x
	local new_y = tail_y

	if math.abs(xdiff) > 1 or math.abs(ydiff) > 1 then
		local far_away = math.abs(xdiff) > 0 and math.abs(ydiff) > 0

		if math.abs(xdiff) > 0 then
			if far_away and math.abs(xdiff) == 1 then
				new_x = new_x + xdiff
			else
				new_x = new_x + decrease(xdiff)
			end
		end
		if math.abs(ydiff) > 0 then
			if far_away and math.abs(ydiff) == 1 then
				new_y = new_y + ydiff
			else
				new_y = new_y + decrease(ydiff)
			end
		end
	end
	return new_x, new_y
end

local function move_rope(dx, dy)
	head['x'] = head['x'] + dx
	head['y'] = head['y'] + dy

	local front_x = head['x']
	local front_y = head['y']

	for i in ipairs(tails) do
		local new_x, new_y = move_tail(front_x, front_y, tails[i]['x'], tails[i]['y'])

		tails[i]['x'] = new_x
		tails[i]['y'] = new_y
		front_x = new_x
		front_y = new_y
	end
	mark_tail_visit(front_x, front_y)
end

local function draw_rope(width, height)
	for row=math.floor(-width/2),math.floor(width/2) do
		for column=-math.floor(height/2),math.floor(height/2) do
			local square_painted = false
			if head['x'] == column and head['y'] == row then
				io.write('h')
				square_painted = true
			end
			if not square_painted then
				for tail_index, tail in ipairs(tails) do
					if tail['x'] == column and tail['y'] == row then
						io.write(tail_index)
						square_painted = true
						break
					end
				end
			end
			if not square_painted then
				io.write('.')
			end
		end
		print('')
	end
end
while true do
	local line = io.read("*line")
	if line == nil then
		break
	end
	local parts = line:gmatch("%S+")
	local direction, steps = parts(), parts()
	local dx = 0
	local dy = 0
	if direction == 'R' then
		dx = 1
		dy = 0
	elseif direction =='L' then
		dx = -1
		dy = 0
	elseif direction =='U' then
		dx = 0
		dy = 1
	else
		dx = 0
		dy = -1
	end

	for _=1, tonumber(steps) do
		move_rope(dx, dy)
	end
end

local tail_visit_count = 0

for x, value in pairs(tail_visits) do
	for y, _ in pairs(value) do
		tail_visit_count = tail_visit_count + 1
	end
end

draw_rope(40, 40)
print('tail visit count', tail_visit_count)
