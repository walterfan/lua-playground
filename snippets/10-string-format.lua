-- @category: 03 字符串与数学
-- @title: 10. 字符串格式化
-- string.format specifiers
print(string.format("%d / %d = %.3f", 1, 3, 1 / 3))
print(string.format("[%10s]", "right"))      -- width, right-aligned
print(string.format("[%-10s]", "left"))      -- left-aligned
print(string.format("%05d", 42))             -- zero padding
print(string.format("%x %X %o", 255, 255, 8))
print(string.format("%e", 12345.6789))
print(string.format("%q", 'a "quoted" string'))  -- safely re-quotable
print(string.format("%s and %s", tostring(1), tostring(true)))   -- portable to Lua 5.1/LuaJIT
print(string.format("%.1f%%", 99.46))        -- literal %% for a percent sign
