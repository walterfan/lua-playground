-- @category: 01 基础语法
-- @title: 03. 运算符
-- Arithmetic, comparison, logical, and concatenation operators
print("7 + 3  =", 7 + 3)
print("7 - 3  =", 7 - 3)
print("7 * 3  =", 7 * 3)
print("7 / 2  =", 7 / 2)
print("7 % 3  =", 7 % 3)      -- modulo
print("2 ^ 10 =", 2 ^ 10)     -- exponentiation

print("1 == 1.0     :", 1 == 1.0)        -- numbers compare by value
print('compare "2"==2:', "2" == 2)       -- different types are never equal
print(3 < 5, 5 <= 5, 3 ~= 4)             -- ~= is Lua's !=

-- and/or short-circuit and return an operand, not a boolean
print(nil or "default")
print(false or "fallback")
print("kept" and "second")
print(nil and "never evaluated")

-- the Lua ternary idiom: cond and x or y
local age = 20
print(age >= 18 and "adult" or "minor")

-- .. concatenates, # takes the length
local lang = "Lua"
print(lang .. " has " .. #lang .. " chars")
