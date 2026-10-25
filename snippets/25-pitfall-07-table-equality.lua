-- @category: 05 常见错误·初级（01–10）
-- @title: 25. [坑 07] 表的引用比较
local a, b = {name = "Lua", version = 1}, {name = "Lua", version = 1}
print("错误写法：默认 == 会比较表内容")
print(a == b) -- false（没有 __eq 时比较引用）

print("正确写法：按数据结构比较字段")
local function same_record(left, right)
  return left.name == right.name and left.version == right.version
end
print(same_record(a, b)) -- true；这里只比较这个固定结构
print(rawequal(a, a))   -- true；rawequal 始终比较原始身份
-- 通用嵌套表比较还需处理循环引用、键、元方法等语义。
