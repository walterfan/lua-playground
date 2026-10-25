-- @category: 05 常见错误·初级（01–10）
-- @title: 21. [坑 03] 带洞表的长度
local values = {[1] = "x", [2] = "y", [3] = "z", [5] = "w"}
print("错误写法：把 # 当元素个数或最大下标")
print("#values：", #values) -- 可能是 3 或 5，不能依赖某个边界

print("正确写法：分别记录逻辑上界与实际元素数")
local last_index, count = 5, 0
for _ in pairs(values) do count = count + 1 end
print("实际元素数：", count, "逻辑上界：", last_index) -- 4, 5
for i = 1, last_index do print(i, values[i]) end
-- # 对连续序列可靠；对稀疏表请明确自己需要哪一种“长度”。
