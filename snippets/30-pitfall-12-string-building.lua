-- @category: 06 常见错误·中级（11–20）
-- @title: 30. [坑 12] 循环拼接字符串
-- 只用 100 个片段，避免演示耗尽沙箱指令预算。
print("错误写法：循环反复复制累积字符串")
local slow = ""
for i = 1, 100 do slow = slow .. tostring(i) end
print("结果字节数：", #slow)

print("正确写法：先收集片段，再 table.concat")
local parts = {}
for i = 1, 100 do parts[i] = tostring(i) end
local fast = table.concat(parts)
print("结果相同：", fast == slow, "字节数：", #fast)
-- 短小拼接可以用 ..；大量累积拼接才是这里的性能问题。
