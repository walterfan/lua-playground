-- Basics: variables, strings, format, loops
local name = "Lua"
print(string.format("Hello, %s! %d + %d = %d", name, 2, 3, 2 + 3))

for i = 1, 3 do
  print(string.rep("-", i * 2))
end
