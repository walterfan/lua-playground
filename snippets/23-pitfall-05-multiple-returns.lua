-- @category: 05 常见错误·初级（01–10）
-- @title: 23. [坑 05] 括号截断多返回值
local function values() return 1, 2, 3 end
print("错误写法：给函数调用加括号却期望全部返回值")
local a, b, c = (values())
print(a, b, c) -- 1, nil, nil

print("正确写法：让调用位于表达式列表末尾，不加括号")
a, b, c = values()
print(a, b, c) -- 1, 2, 3
print("非末尾调用也只留一个：", values(), "end") -- 1, end
