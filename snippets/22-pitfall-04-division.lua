-- @category: 05 常见错误·初级（01–10）
-- @title: 22. [坑 04] 除法与向下取整
print("错误写法：以为 / 返回整数商")
print(5 / 2, -5 / 2) -- 2.5, -2.5

print("正确写法：LuaJIT / Lua 5.1 用 math.floor")
print(math.floor(5 / 2), math.floor(-5 / 2)) -- 2, -3（不是向零截断）
-- 原生 Lua 5.3+：print(5 // 2, -5 // 2)
-- // 在 LuaJIT 中是语法错误，所以只作为注释展示。
