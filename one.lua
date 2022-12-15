io.input('./input-1.txt')

local calories = 0
local elf_calories = {}

while true do
  local line = io.read("*line")
  if line == nil then
    table.insert(elf_calories, calories)
    break
  elseif line == '' then
    table.insert(elf_calories, calories)
    calories = 0
  else
    local number = tonumber(line)
    calories = calories + number
  end
end

table.sort(elf_calories, function(a, b) return a > b end);

print('top three total', elf_calories[1] + elf_calories[2] + elf_calories[3])
