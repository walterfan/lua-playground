-- OOP with metatables: a Vector class
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
  return setmetatable({ x = x, y = y }, Vector)
end

function Vector.__add(a, b)
  return Vector.new(a.x + b.x, a.y + b.y)
end

function Vector:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

function Vector:length()
  return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

local a, b = Vector.new(3, 4), Vector.new(1, 2)
print("a     = " .. tostring(a))
print("a + b = " .. tostring(a + b))
print("|a|   = " .. a:length())
