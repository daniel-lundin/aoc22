io.input('./input-9.txt')

local head = {
	x = 0,
	y = 0,
}
local tail = {
	x = 0,
	y = 0,
}

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

local function move(dx, dy)
	head['x'] = head['x'] + dx
	head['y'] = head['y'] + dy

	local xdiff = head['x'] - tail['x']
	local ydiff = head['y'] - tail['y']

	if math.abs(xdiff) > 1 or math.abs(ydiff) > 1 then
		local far_away = math.abs(xdiff) > 0 and math.abs(ydiff) > 0

		if math.abs(xdiff) > 0 then
			if far_away and math.abs(xdiff) == 1 then
				tail['x'] = tail['x'] + xdiff
			else
				tail['x'] = tail['x'] + decrease(xdiff)
			end
		end
		if math.abs(ydiff) > 0 then
			if far_away and math.abs(ydiff) == 1 then
				tail['y'] = tail['y'] + ydiff
			else
				tail['y'] = tail['y'] + decrease(ydiff)
			end
		end
	end
	mark_tail_visit(tail['x'], tail['y'])
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
		move(dx, dy)
	end
end

local tail_visit_count = 0

for x, value in pairs(tail_visits) do
	for y, _ in pairs(value) do
		tail_visit_count = tail_visit_count + 1
	end
end

print('tail visit count', tail_visit_count)
