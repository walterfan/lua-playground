-- @category: 07 常见错误·高级（21–30）
-- @title: 42. [坑 24] 协程双向传值
print("错误写法：忘记 resume 首个返回值是成功标志")
local wrong = coroutine.create(function() coroutine.yield("payload") end)
local payload = coroutine.resume(wrong)
print(payload, type(payload)) -- true, boolean；不是 payload 文本

print("正确写法：分开状态和值，明确 yield/resume 方向")
local co = coroutine.create(function(first)
  print("第一次 resume 传入：", first)
  local reply = coroutine.yield("outbound")
  print("下一次 resume 传入：", reply)
  return "done"
end)
local ok, value = coroutine.resume(co, 10)
print(ok, value) -- true, outbound
ok, value = coroutine.resume(co, "inbound")
print(ok, value, coroutine.status(co)) -- true, done, dead
print(coroutine.resume(co)) -- false, cannot resume dead coroutine
