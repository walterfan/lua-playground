-- @category: 03 字符串与数学
-- @title: 11. 字符串模式
-- Lua patterns (they are not regex): classes, sets, quantifiers, captures
local text = "2026-10-15 lua-playground v1.31"

-- character classes: %d digits, %a letters, %s space, %w word chars
print(text:match("^%d+"))        -- anchored at start: 2026
print(text:match("%a+-%a+"))     -- letters-dash-letters
print(text:match("v%d%.%d+"))    -- % escapes the dot

-- captures: each () returns one value
local y, m, d = text:match("(%d+)-(%d+)-(%d+)")
print(y, m, d)

-- sets: [abc] matches any listed character
print(("hello"):gsub("[aeiou]", "*"))

-- quantifiers: * (0+), + (1+), - (lazy 0+), ? (optional)
print(("foo123bar"):match("%a+"))
print(("foo123bar"):match("%d+"))
print(("color colour"):gsub("colou?r", "X"))

-- balanced match: %bxy
print(("f(a, (b))"):match("%b()"))

-- gsub with a function replacement
local out = ("a1 b2 c3"):gsub("%d", function(digit)
  return "[" .. digit .. "]"
end)
print(out)

-- gmatch iterates over all matches
for word in ("the quick brown fox"):gmatch("%a+") do
  print("word:", word)
end

-- find returns start and end indexes
local s, e = ("hello world"):find("wor")
print(s, e)
