-- @category: 06 常见错误·中级（11–20）
-- @title: 32. [坑 14] 默认值吞掉 false
print("错误写法：用 or 将显式 false 也替换掉")
local function wrong(value) return value or true end
print(wrong(false), wrong(nil)) -- true, true

print("正确写法：只对 nil 应用默认值")
local function correct(value)
  if value == nil then return true end
  return value
end
print(correct(false), correct(nil)) -- false, true
print("0 和空串都为真：", 0 or "fallback", "" or "fallback")
