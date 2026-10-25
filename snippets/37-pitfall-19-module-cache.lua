-- @category: 06 常见错误·中级（11–20）
-- @title: 37. [坑 19] 模块重复加载
print("错误写法：用 dofile 加载应共享的模块")
print([[-- 本地创建 demo_module.lua：print("loaded"); return {n = 1}
local a = dofile("demo_module.lua")
local b = dofile("demo_module.lua")
print(a == b) -- false，执行两次]])

print("正确写法：模块使用 require，按模块名缓存")
print([[local a = require("demo_module")
local b = require("demo_module")
print(a == b) -- true；正常情况下模块只执行一次]])
-- 本案例是源码展示，未在网页执行文件或加载模块。
print("运行条件：本地 Lua；网页沙箱禁用 dofile、require 和 package。")
-- require 以模块名缓存；别名或手工修改 package.loaded 会改变缓存行为。
