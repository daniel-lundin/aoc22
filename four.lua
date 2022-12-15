io.input('./input-4.txt')

local function range_overlaps(a, b, c, d)
	if a <= c and b >= c then
		return true
	elseif a >= c and a <= d then
		return true
	else
		return false
	end
end

local function parse_section(section)
	local parts = section:gmatch('[^-]+')
	return tonumber(parts()), tonumber(parts())
end

local overlaps = 0
while true do
	local line = io.read("*line")
	if line == nil then
		break
	end

	local sections = line:gmatch('[^,]+')
	local first = sections()
	local second = sections()


	local a,b = parse_section(first)
	local c,d = parse_section(second)

	if range_overlaps(a,b,c,d) then
		overlaps = overlaps +1
	end

end

print('overlaps', overlaps)

