-- @category: 06 常见错误·中级（11–20）
-- @title: 34. [坑 16] 格式化前验证数字
print("错误写法：给 %d 传入非数字文本")
print(pcall(string.format, "num=%d", "hello")) -- false

print("正确写法：显式转换并校验整数范围")
local function format_count(value)
  local n = tonumber(value)
  if not n or n ~= n or n < 0 or n > 1000000 or n % 1 ~= 0 then
    return nil, "count 必须是 0 到 1000000 的整数"
  end
  return string.format("num=%d", n)
end
print(format_count("42"))   -- num=42
print(format_count("oops")) -- nil, 校验错误
print(format_count("2.5"))  -- nil, 校验错误
-- 某些版本会接受数字字符串；不能概括为“%d 拒绝所有字符串”。
