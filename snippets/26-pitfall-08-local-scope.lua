-- @category: 05 常见错误·初级（01–10）
-- @title: 26. [坑 08] 忘写 local
print("错误写法：函数内赋值泄漏到当前全局环境")
local function wrong() pitfall_scope_demo = 42 end
wrong()
print(pitfall_scope_demo) -- 42；网页中只是本次执行的沙箱全局
pitfall_scope_demo = nil -- 清理演示变量

print("正确写法：声明局部变量并显式返回")
local function correct()
  local pitfall_scope_demo = 43
  return pitfall_scope_demo
end
print(correct(), pitfall_scope_demo) -- 43, nil
