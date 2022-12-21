io.input('input-15.txt')

local sensors = {}
local beacons = {}

local max_coord = 4000000

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



local function merge_range(range, ranges)
	for i, other_range in ipairs(ranges) do
		-- my self
		if range[1] == other_range[1] and range[2] == other_range[2] then
		elseif range[2] >= other_range[1] and range[2] <= other_range[2] then
			range[2] = other_range[2]
			table.remove(ranges, i)
			return merge_range(range, ranges)
		elseif range[1] <= other_range[1] and range[2] >= other_range[2] then
			table.remove(ranges, i)
			return merge_range(range, ranges)
		end

	end
end

local function merge_ranges(ranges)
	for _, range in ipairs(ranges) do
		merge_range(range, ranges)
	end
end

local y_candidates = {}


for y=0,max_coord do
	local non_beacon_ranges = {}
	for _, sensor in ipairs(sensors) do
		local sx, sy, manhattan_distance = sensor[1], sensor[2], sensor[3]

		local distance_to_tip = math.abs(sy - y)
		if distance_to_tip <= manhattan_distance then
			local dx = manhattan_distance - math.abs(sy - y)
			table.insert(non_beacon_ranges, {sx-dx, sx+dx})
		end

	end

	table.sort(non_beacon_ranges, function(a, b)
		return a[1] < b[1]
	end)
	merge_ranges(non_beacon_ranges)

	if #non_beacon_ranges > 1 then
		-- clamp ranges
		for _, range in pairs(non_beacon_ranges) do
			range[1] = math.max(range[1], 0)
			range[2] = math.min(range[2], max_coord)
		end
		print('y is candidate', y)
		local possible_beacons = {}
		for i, range in ipairs(non_beacon_ranges) do
			local next_range = non_beacon_ranges[i+1]
			if next_range ~= nil then
				table.insert(possible_beacons, {range[2], next_range[1]})
			end
		end
		for i, possible_beacon_range in ipairs(possible_beacons) do
			for x=possible_beacon_range[1]+1,possible_beacon_range[2]-1 do
				print('beacon', x, y)
				print('tuning frequency', x * 4000000 + y)
			end
		end
	end

end
