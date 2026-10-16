-- string.format specifiers
print(string.format("%d / %d = %.3f", 1, 3, 1 / 3))
print(string.format("[%10s]", "right"))      -- width, right-aligned
print(string.format("[%-10s]", "left"))      -- left-aligned
print(string.format("%05d", 42))             -- zero padding
print(string.format("%x %X %o", 255, 255, 8))
print(string.format("%e", 12345.6789))
print(string.format("%q", 'a "quoted" string'))  -- safely re-quotable
print(string.format("%s and %s", 1, true))   -- %s uses tostring
print(string.format("%.1f%%", 99.46))        -- literal %% for a percent sign
