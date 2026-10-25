-- @category: 02 函数与集合
-- @title: 05. 函数与可变参数
-- Functions: multiple returns, varargs, recursion, higher-order functions
local function min_max(t)
  local lo, hi = math.huge, -math.huge
  for _, v in ipairs(t) do
    if v < lo then lo = v end
    if v > hi then hi = v end
  end
  return lo, hi
end

local lo, hi = min_max({3, 1, 4, 1, 5, 9, 2, 6})
print("min:", lo, "max:", hi)

local wrapped = {min_max({7, 8, 9})}  -- all returns collected in a table
print("wrapped:", wrapped[1], wrapped[2])

-- varargs: ... inside a function
local function log(tag, ...)
  local args = {...}
  local count = select("#", ...)
  print("[" .. tag .. "] got " .. count .. " args")
  for i = 1, count do
    print("  arg" .. i .. " =", tostring(args[i]))
  end
end
log("demo", 1, "two", nil, true)

-- select("#", ...) counts nils; {...} does not
print(select("#", 1, nil), #{1, nil})

-- recursion
local function fib(n)
  if n < 2 then return n end
  return fib(n - 1) + fib(n - 2)
end
print("fib(10) =", fib(10))

-- functions are values: composition
local function compose(f, g)
  return function(x) return f(g(x)) end
end
local double = function(x) return x * 2 end
local inc = function(x) return x + 1 end
print("compose:", compose(double, inc)(5))  -- double(inc(5))
