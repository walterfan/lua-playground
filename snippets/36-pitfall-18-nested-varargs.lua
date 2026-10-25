-- @category: 06 常见错误·中级（11–20）
-- @title: 36. [坑 18] 嵌套函数与可变参数
print("错误写法：非可变参数的内层函数直接访问 ...")
-- 编译错误只能以文本展示，否则整个 snippet 都无法执行。
print([[local function outer(...)
  local function inner() return select("#", ...) end
  return inner()
end]])

print("正确写法：在外层保存参数，并显式记录个数")
local unpack_values = table.unpack or unpack
local function outer(...)
  local args = {n = select("#", ...), ...} -- 兼容 5.1 的 table.pack
  local function inner()
    print("参数个数：", args.n)
    return unpack_values(args, 1, args.n)
  end
  return inner()
end
local function inspect(...) print("返回个数：", select("#", ...)); print(...) end
inspect(outer("a", nil, "c", nil)) -- 4；尾部 nil 也保留
-- 用 #args 会再次引入洞/尾部 nil 的问题。
