-- @category: 07 常见错误·高级（21–30）
-- @title: 44. [坑 26] 位运算与版本
print("错误写法：把 Lua 5.3+ 运算符直接粘贴到 LuaJIT")
print("print(5 & 3) -- Lua 5.3+ 输出 1，LuaJIT 不接受此语法")

print("正确写法：按宿主能力选择实现")
print([[-- 原生 Lua 5.3+：print(5 & 3)
-- OpenResty/LuaJIT（沙箱外）：local bit = require("bit"); print(bit.band(5, 3))]])
-- 网页没有开放 bit/require；这里给出小型非负整数按位与的可运行替代。
-- 只用于教学，不替代完整 32/64 位、有符号、移位语义。
local function small_band(a, b)
  assert(a >= 0 and a <= 65535 and a % 1 == 0)
  assert(b >= 0 and b <= 65535 and b % 1 == 0)
  local result, place = 0, 1
  for _ = 1, 16 do
    if a % 2 == 1 and b % 2 == 1 then result = result + place end
    a, b, place = math.floor(a / 2), math.floor(b / 2), place * 2
  end
  return result
end
print("5 AND 3 =", small_band(5, 3)) -- 1
