-- @category: 07 常见错误·高级（21–30）
-- @title: 48. [坑 30] 热循环与长度
print("错误写法：热路径重复做函数查找，并认定 # 永远 O(1)")
local values, slow_sum = {}, 0
for i = 1, 100 do values[i] = i / 2 end
for i = 1, #values do slow_sum = slow_sum + math.floor(values[i]) end
print("结果：", slow_sum)

print("正确写法：数据不变时缓存热点函数与循环边界，先保证结果一致")
local floor, count, fast_sum = math.floor, #values, 0
for i = 1, count do fast_sum = fast_sum + floor(values[i]) end
print("结果相同：", fast_sum == slow_sum, "结果：", fast_sum) -- true, 2500
-- 数值 for 的上界表达式本来就只求值一次；缓存 #values 不会让它少算 100 次。
-- 标准 Lua 5.4 手册给出 #t 最坏 O(log n)，不是普遍保证 O(1)。
-- 这里不声称测出了加速；LuaJIT 可能优化查找，应在实际宿主中测量热点。
-- 缓存函数会固定函数引用，动态替换 math.floor 的行为也会因此改变。
