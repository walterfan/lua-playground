-- @category: 07 常见错误·高级（21–30）
-- @title: 43. [坑 25] goto 与局部作用域
print("错误写法：goto 跳入局部变量作用域")
-- 编译错误放在字符串中，保证网页仍能运行整个示例。
print([[do
  goto skip
  local x = 10
  ::skip::
  print(x)
end]])
-- Lua 5.2 引入 goto 时就禁止这种跳转，并非 5.4 才禁止。
-- LuaJIT 对 goto 有扩展支持；标准 Lua 5.1 没有 goto。

print("正确写法：用分支表达是否执行初始化与后续逻辑")
local function process(skip)
  if not skip then
    local x = 10
    print(x)
  end
  print("结束")
end
process(true)
process(false)
