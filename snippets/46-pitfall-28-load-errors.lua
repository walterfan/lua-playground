-- @category: 07 常见错误·高级（21–30）
-- @title: 46. [坑 28] 动态编译先检查错误
print("错误写法：忽略编译错误，直接调用返回的 nil")
print([[local fn = load("return 1+", "demo", "t", {})
fn() -- 编译已经失败；这里又触发 attempt to call a nil value]])

print("正确写法：固定演示文本、命名来源、限制环境、分别检查编译与执行")
print([[local fn, err = load("return 1 + 2", "demo", "t", {})
if not fn then print("compile:", err)
else print("execute:", pcall(fn)) end]])
-- 网页不开放动态编译；不要为这个示例向沙箱添加 load/loadstring。
if not load or setfenv then
  print("源码展示：本地标准 Lua 5.2+ 可执行下面的隔离编译。")
  return
end
-- 仅编译固定、可信的教学文本；空环境也不是完整安全隔离边界。
local bad, compile_err = load("return 1+", "demo-invalid", "t", {})
print("语法错误：", bad, compile_err)
local fn, err = load("return 1 + 2", "demo-valid", "t", {})
if not fn then print("compile:", err)
else print("execute:", pcall(fn)) end -- true, 3
