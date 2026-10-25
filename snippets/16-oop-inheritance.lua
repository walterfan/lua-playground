-- @category: 04 元表与运行控制
-- @title: 16. 对象与继承
-- Classes and inheritance with metatables
local Animal = {}
Animal.__index = Animal

function Animal.new(name, sound)
  return setmetatable({ name = name, sound = sound or "..." }, Animal)
end

function Animal:speak()                    -- colon syntax adds self
  return self.name .. " says " .. self.sound
end

function Animal:__tostring()
  return "Animal(" .. self.name .. ")"
end

-- Dog inherits from Animal
local Dog = setmetatable({}, { __index = Animal })
Dog.__index = Dog                          -- instances look up in Dog first

function Dog.new(name, breed)
  local self = Animal.new(name, "Woof")    -- call the super constructor
  self.breed = breed
  return setmetatable(self, Dog)
end

function Dog:speak()                       -- override, reuse the super method
  return Animal.speak(self) .. " (" .. self.breed .. " business)"
end

function Dog:fetch(item)
  return self.name .. " fetches the " .. item
end

local a = Animal.new("Cat", "Meow")
local d = Dog.new("Rex", "golden")
print(a:speak())
print(d:speak())
print(d:fetch("stick"))
print(tostring(d))
