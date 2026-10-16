-- Coroutines: cooperative multitasking, generators, pipelines
local co = coroutine.create(function(a)
  local b = coroutine.yield(a + 1)         -- pause, send a value out
  return b * 2                              -- final return
end)
print(coroutine.resume(co, 10))             -- true  11
print(coroutine.status(co))                 -- suspended
print(coroutine.resume(co, 5))              -- true  10
print(coroutine.status(co))                 -- dead

-- coroutine.wrap: call like a function, errors propagate
local function squares(n)
  return coroutine.wrap(function()
    for i = 1, n do coroutine.yield(i * i) end
  end)
end
for sq in squares(4) do print("square:", sq) end

-- producer -> filter -> consumer pipeline
local function numbers(n)
  return coroutine.wrap(function()
    for i = 1, n do coroutine.yield(i) end
  end)
end

local function filter(input, pred)
  return coroutine.wrap(function()
    for v in input do
      if pred(v) then coroutine.yield(v) end
    end
  end)
end

for even in filter(numbers(10), function(x) return x % 2 == 0 end) do
  print("even:", even)
end
