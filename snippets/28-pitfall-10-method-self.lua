-- @category: 05 常见错误·初级（01–10）
-- @title: 28. [坑 10] 冒号自动传 self
local obj = {x = 10}
function obj:get() return self.x end

print("错误写法：点号调用时忘了传对象")
print(pcall(function() return obj.get() end)) -- false，self 是 nil

print("正确写法：冒号调用，或点号显式传入 self")
print(obj:get(), obj.get(obj)) -- 10, 10
-- 冒号是语法糖；点号定义/冒号调用也能配合，只要第一个形参是 self。
