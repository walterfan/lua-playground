-- @category: 06 常见错误·中级（11–20）
-- @title: 29. [坑 11] ipairs 遇洞停止
local values = {[1] = 10, [3] = 30}
local last_index = 3
print("错误写法：指望 ipairs 跳过 nil 继续")
for i, value in ipairs(values) do print(i, value) end -- 只有 1, 10

print("正确写法：有序遍历时使用明确的逻辑上界")
for i = 1, last_index do print(i, values[i]) end -- 包含洞以及 3, 30
local count = 0
for _ in pairs(values) do count = count + 1 end
print("不要求顺序时 pairs 可遍历现有键，数量：", count) -- 2
-- 不能用 #values 推断稀疏数组的最大下标；见坑 03。
