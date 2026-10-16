-- Tables: arrays, insert/remove/sort/concat, and maps
local t = {5, 3, 8, 1}
table.sort(t)
print("sorted:   " .. table.concat(t, ", "))

table.insert(t, 1, 99)
print("inserted: " .. table.concat(t, ", "))

print("removed:  " .. tostring(table.remove(t)))

local config = { host = "localhost", port = 8080 }
for key, value in pairs(config) do
  print(key .. " = " .. tostring(value))
end
