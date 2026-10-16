-- String library tour
local s = "the quick brown fox"

print("upper: " .. s:upper())
print("sub:   " .. s:sub(5, 9))
print("find:  " .. tostring(s:find("brown")))
print("gsub:  " .. s:gsub("o", "0"))
print("rep:   " .. string.rep("=", 20))

-- split on whitespace with gmatch
local words = {}
for word in s:gmatch("%S+") do
  words[#words + 1] = word
end
print("words: " .. table.concat(words, "|"))
