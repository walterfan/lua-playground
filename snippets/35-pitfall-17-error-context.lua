-- @category: 06 常见错误·中级（11–20）
-- @title: 35. [坑 17] 捕获错误与定位
local function parse() error("demo parse failure") end
local function process() return parse() end

print("错误写法：以为 pcall 默认返回完整调用栈")
local ok, err = pcall(process)
print(ok, err) -- 通常含位置和消息，但没有完整堆栈

print("正确写法：xpcall 在栈展开前添加上下文")
local function describe(message)
  if debug and debug.traceback then return debug.traceback(message, 2) end
  return "process -> parse: " .. tostring(message)
end
ok, err = xpcall(process, describe)
print(ok, err)
-- 网页禁用 debug，因此输出手工上下文；本地 Lua 输出 traceback。
