-- Error handling with pcall, error, and assert
local ok, err = pcall(function()
  error("something went wrong")
end)
print("ok:  " .. tostring(ok))
print("err: " .. err)

local function risky(n)
  if n < 0 then
    error("negative input: " .. n, 0)
  end
  return math.sqrt(n)
end

print(pcall(risky, 16))
print(pcall(risky, -1))

print("assert passed: " .. tostring(pcall(assert, 2 > 1, "math is broken")))
