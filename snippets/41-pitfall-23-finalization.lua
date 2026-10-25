-- @category: 07 常见错误·高级（21–30）
-- @title: 41. [坑 23] GC 与确定性关闭
-- 纠正原文：标准 Lua 5.2+（含 5.4）支持表 __gc；Lua 5.1 不支持。
-- GC 只回收不可达对象；时机不等于业务资源需要释放的时刻。
local finalized = false
print("错误写法：对象仍被引用，却指望 GC 立即关闭")
local held = setmetatable({}, {
  __gc = function() finalized = true end,
})
if collectgarbage then collectgarbage("collect") end
print("仍存活：", held ~= nil, "已终结：", finalized) -- true, false

print("正确写法：显式关闭，GC 最多作为后备")
local resource = {closed = false}
function resource:close()
  if not self.closed then self.closed = true end -- 模拟幂等资源释放
end
resource:close()
resource:close()
print("已关闭：", resource.closed) -- true
-- 在本地支持表 __gc 的版本中，可解除引用后验证终结器。
held = nil
if collectgarbage then
  collectgarbage("collect")
  print("释放引用后是否终结（取决于版本）：", finalized)
else
  print("网页禁用手动 GC；可在本地 Lua 5.2+ 验证表终结器。")
end
