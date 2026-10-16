-- String literals: quotes, escapes, long brackets, comments
local single = 'single quotes work the same'
local escapes = "line1\nline2\ttabbed \"quoted\" backslash: \\"
print(single)
print(escapes)

-- decimal escapes: \ddd
print("\65\66\67")

-- long brackets: raw text, no escape sequences
local raw = [[C:\path\to\lua
and newlines stay literal]]
print(raw)

-- bracket levels handle nested long strings
local nested = [==[contains ]] and ]=] characters inside]==]
print(nested)

-- comments come in two flavours:
--   a line comment like this one
--[[ and a block comment
     that spans
     several lines ]]
print("done")
