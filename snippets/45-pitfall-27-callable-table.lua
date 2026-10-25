-- @category: 07 常见错误·高级（21–30）
-- @title: 45. [坑 27] 可调用表
print("错误写法：把 __call 放在对象自身却没有设置元表")
local wrong = {base = 10, __call = function(self, x) return self.base + x end}
print(pcall(function() return wrong(5) end)) -- false

print("正确写法：在对象的元表中定义 __call")
local correct = setmetatable({base = 10}, {
  __call = function(self, x) return self.base + x end,
})
print(correct(5)) -- 15
