-- @category: 05 常见错误·初级（01–10）
-- @title: 19. [坑 01] 数组从 1 开始
local values = {"a", "b", "c"}

print("错误写法：按 0 到 n-1 遍历")
for i = 0, #values - 1 do print(i, values[i]) end
-- 多了 nil，漏掉了 c；Lua 允许键 0，但数组构造器从 1 填充。

print("正确写法：连续数组按 1 到 n 遍历")
for i = 1, #values do print(i, values[i]) end
