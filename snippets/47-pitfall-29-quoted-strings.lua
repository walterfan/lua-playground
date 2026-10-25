-- @category: 07 常见错误·高级（21–30）
-- @title: 47. [坑 29] %q 与普通文本
local message = 'a "quote"\nand a newline'
print("错误写法：把 Lua 字面量当作给人看的原文")
print(string.format("%q", message)) -- 含引号、转义；具体格式因版本而异

print("正确写法：显示文本用 %s，生成 Lua 字面量才用 %q")
print(string.format("%s", message))
local literal = string.format("%q", message)
print("Lua 源码：", "local message = " .. literal)
-- %q 是 Lua 源码转义，不是 HTML、SQL、JSON 或 shell 的编码器。
