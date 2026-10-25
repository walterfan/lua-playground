-- @category: 04 元表与运行控制
-- @title: 15. 元方法
-- Beyond __index: __newindex, __call, __eq, __lt, __concat, __unm, __len, raw*
local defaults = { color = "black", size = "M" }
local shirt = setmetatable({}, {
  __index = defaults,                     -- read fallback
  __newindex = function(t, k, v)          -- intercept writes
    if defaults[k] and v == nil then
      error("cannot reset " .. k .. " to nil", 0)
    end
    rawset(t, k, v)                       -- store it for real
  end,
})

print(shirt.color)                        -- black, inherited
shirt.color = "red"
print(rawget(shirt, "color"))             -- red, own value now
print(rawget(shirt, "size"))              -- nil, still only in defaults

-- __call makes a table callable
local adder = setmetatable({}, {
  __call = function(self, a, b) return a + b end,
})
print("call:", adder(3, 4))

-- __eq and __lt enable table comparison
local V = {}
V.__eq = function(a, b) return a[1] == b[1] end
V.__lt = function(a, b) return a[1] < b[1] end
local p, q, r = setmetatable({1}, V), setmetatable({1}, V), setmetatable({2}, V)
print("p == q:", p == q, " p < r:", p < r)

-- __concat, __unm, __len
local line = setmetatable({ 3 }, {
  __concat = function(a, b) return "concat!" end,
  __unm = function(a) return "negated" end,
  __len = function() return 99 end,
})
print("line! " .. line, -line, #line)
