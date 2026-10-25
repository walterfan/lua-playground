-- @category: 07 常见错误·高级（21–30）
-- @title: 40. [坑 22] 弱键与强引用
print("错误写法：保留强引用，却期望弱键条目消失")
local keys = {{}}
local weak = setmetatable({}, {__mode = "k"})
weak[keys[1]] = "cached"
if collectgarbage then collectgarbage("collect") end
print("仍有条目：", next(weak) ~= nil) -- true，keys 保持键存活

print("正确写法：释放不再需要的强引用，允许 GC 回收")
keys[1] = nil
if collectgarbage then
  collectgarbage("collect")
  collectgarbage("collect")
  print("已回收：", next(weak) == nil) -- true
else
  print("源码：collectgarbage('collect')；本地 Lua 可验证回收。")
  print("网页禁用手动 GC，不能对本次条目是否已回收作保证。")
end
-- 值在别处存活，不一定保住弱键；重点是键是否仍可达。
-- Lua 5.2+ 弱键强值表有 ephemeron 语义；此例不依赖值到键的回指。
