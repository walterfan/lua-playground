-- @category: 01 基础语法
-- @title: 01. Hello Lua
-- Basics: variables, strings, format, loops
local name = "Lua"
print(string.format("Hello, %s! %d + %d = %d", name, 2, 3, 2 + 3))

for i = 1, 3 do
  print(string.rep("-", i * 2))
end
