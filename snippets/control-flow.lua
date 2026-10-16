-- if / elseif / else, while, repeat-until, for loops, break
local n = 42

if n < 10 then
  print("small")
elseif n < 100 then
  print("medium")
else
  print("large")
end

-- numeric for with a step
for i = 10, 1, -3 do
  print("countdown:", i)
end

-- generic for over an array
for index, value in ipairs({"a", "b", "c"}) do
  print(index, value)
end

-- while with break
local i = 1
while true do
  if i > 3 then break end
  print("while:", i)
  i = i + 1
end

-- repeat-until: body always runs once, and the test can see body locals
local count = 0
repeat
  local done = count >= 2
  count = count + 1
  print("repeat:", count, done)
until done
