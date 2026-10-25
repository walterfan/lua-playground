-- @category: 05 常见错误·初级（01–10）
-- @title: 27. [坑 09] 闭包捕获变量
print("错误写法：多个闭包捕获同一个外层变量")
local funcs, shared = {}, nil
for i = 1, 3 do
  shared = i
  funcs[i] = function() return shared end
end
print(funcs[1](), funcs[2](), funcs[3]()) -- 3, 3, 3

print("正确写法：每轮创建独立局部变量")
for i = 1, 3 do
  local snapshot = i
  funcs[i] = function() return snapshot end
end
print(funcs[1](), funcs[2](), funcs[3]()) -- 1, 2, 3
-- 数值 for 直接捕获 i 在 Lua 5.1 已可逐轮独立；不是 5.4 才新增。
