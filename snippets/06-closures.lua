-- @category: 02 函数与集合
-- @title: 06. 闭包
-- Closures: functions that remember their environment
local function make_counter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end

local next_id = make_counter()
print(next_id(), next_id(), next_id())

-- memoize with a closure-owned cache
local function memoize(fn)
  local cache = {}
  return function(n)
    if cache[n] == nil then
      cache[n] = fn(n)
    end
    return cache[n]
  end
end

local slow_square = memoize(function(n)
  return n * n
end)
print(slow_square(12), slow_square(12))
