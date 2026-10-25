-- @category: 05 常见错误·初级（01–10）
-- @title: 24. [坑 06] 拼接要用两个点
print("错误写法：用 + 拼接非数字字符串")
local function wrong() return "hello" + " world" end
local ok, err = pcall(wrong)
print(ok, err) -- false；接住错误，让正确示例继续运行

print("正确写法：用 .. 拼接")
print("hello" .. " world")
print("sum=" .. (2 + 3)) -- sum=5
