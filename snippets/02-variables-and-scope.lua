-- @category: 01 基础语法
-- @title: 02. 变量与作用域
-- Variables, multiple assignment, and scope
x = 10                -- global (stored in the sandbox environment table)
local y = 20          -- local to this chunk

local a, b, c = 1, 2  -- multiple assignment; extra variables get nil
print(x, y, a, b, c)

a, b = b, a           -- swap without a temporary
print("swapped:", a, b)

do
  local x = "shadow"  -- shadows the outer x inside this block
  print("inner:", x)
end
print("outer:", x)

print("types:", type(nil), type(missing_variable))
