-- Iterators: closure-based, stateless, and custom traversal
local function range(from, to, step)  -- closure-based iterator
  step = step or 1
  local i = from - step
  return function()
    i = i + step
    if (step > 0 and i > to) or (step < 0 and i < to) then return nil end
    return i
  end
end

for i in range(1, 5) do print("range:", i) end
for i in range(3, 1, -1) do print("back:", i) end

-- stateless iterator: the generic for keeps (f, s, control) between steps
local function iterate(t, i)
  i = i + 1
  local v = t[i]
  if v ~= nil then return i, v end
end
local function my_ipairs(t)
  return iterate, t, 0
end

for i, v in my_ipairs({"x", "y", "z"}) do print(i, v) end

-- custom pairs-like iterator over sorted keys
local function sorted_pairs(t)
  local keys = {}
  for k in pairs(t) do keys[#keys + 1] = k end
  table.sort(keys)
  local i = 0
  return function()
    i = i + 1
    if keys[i] ~= nil then return keys[i], t[keys[i]] end
  end
end

local cfg = { port = 8080, host = "localhost", debug = true }
for k, v in sorted_pairs(cfg) do print(k .. " = " .. tostring(v)) end
