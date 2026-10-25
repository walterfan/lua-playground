-- @category: 06 常见错误·中级（11–20）
-- @title: 38. [坑 20] 深浅拷贝
local original = {nested = {value = 2}}
original.self = original
print("错误写法：浅拷贝后修改嵌套对象")
local shallow = {}
for key, value in pairs(original) do shallow[key] = value end
shallow.nested.value = 99
print(original.nested.value) -- 99

print("正确写法：为普通数据表递归复制并记录已访问对象")
local function copy(value, seen)
  if type(value) ~= "table" then return value end
  seen = seen or {}
  if seen[value] then return seen[value] end
  local result = {}
  seen[value] = result
  for key, item in pairs(value) do result[copy(key, seen)] = copy(item, seen) end
  return result
end
local deep = copy(original)
deep.nested.value = 7
print(original.nested.value, deep.nested.value, deep.self == deep) -- 99, 7, true
-- 仅演示可信的小型普通数据表；不复制元表、userdata、函数内部状态。
-- 生产中先明确复制语义；大型/深层输入还需大小和递归深度上限。
