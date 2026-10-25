-- @category: 06 常见错误·中级（11–20）
-- @title: 31. [坑 13] 元表读写代理
print("错误写法：只配 __index 却以为写入会转发")
local storage = {x = 1}
local wrong = setmetatable({}, {__index = storage})
wrong.x = 9
print(wrong.x, storage.x) -- 9, 1，写到了代理自己

print("正确写法：空代理同时转发读取和写入")
local proxy = setmetatable({}, {
  __index = storage,
  __newindex = function(_, key, value) storage[key] = value end,
})
proxy.x = 10
proxy.x = 11
print(proxy.x, storage.x, rawget(proxy, "x")) -- 11, 11, nil
-- __newindex 只拦截代理上不存在的键；不能 rawset 到代理再期望每次拦截。
-- 仅需读取默认值时，单独 __index 完全正确。
