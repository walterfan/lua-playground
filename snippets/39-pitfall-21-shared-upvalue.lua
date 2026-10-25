-- @category: 07 常见错误·高级（21–30）
-- @title: 39. [坑 21] 共享 upvalue
local function make_counter()
  local count = 0
  return function() count = count + 1; return count end,
         function() return count end
end

print("错误写法：把同一闭包的别名当作独立计数器")
local first, get = make_counter()
local second = first
print(first(), second(), get()) -- 1, 2, 2

print("正确写法：分别调用工厂生成独立状态")
local independent_a = make_counter()
local independent_b = make_counter()
print(independent_a(), independent_b(), independent_a()) -- 1, 1, 2
-- 同一次工厂调用返回的 inc/get 共享状态本身是合法设计。
