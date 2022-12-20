io.input('input-15.txt')

local sensors = {}
local beacons = {}
while true do
	local line = io.read('*line')

	if line == nil then
		break
	end

	local parts = line:gmatch('[-%d]+')
	local x,y,beacon_x,beacon_y = tonumber(parts()), tonumber(parts()), tonumber(parts()), tonumber(parts())
	local manhattan_distance = math.floor(math.abs(x - beacon_x) + math.abs(y - beacon_y))

	table.insert(sensors, { x, y, manhattan_distance })
	if beacons[beacon_x] == nil then
		beacons[beacon_x] = {}
	end
	beacons[beacon_x][beacon_y] = true
end



local y = 2000000

local non_beacons = {}
for _, sensor in ipairs(sensors) do
	local sx, sy, manhattan_distance = sensor[1], sensor[2], sensor[3]
	for x=sx-manhattan_distance,sx+manhattan_distance do
		if not (beacons[x] and beacons[x][y]) then
			local manhattan = math.abs(sx - x) + math.abs(sy - y)
			if manhattan <= manhattan_distance then
				non_beacons[x] = true
			end
		end
	end
end

local count = 0
for _ in pairs(non_beacons) do
	count = count + 1
end

print('count', count)

