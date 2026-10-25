-- @category: 06 常见错误·中级（11–20）
-- @title: 33. [坑 15] 删除数组元素
print("错误写法：赋 nil 却以为后续元素会前移")
local wrong = {"a", "b", "c"}
wrong[2] = nil
print(wrong[1], wrong[2], wrong[3]) -- a, nil, c

print("正确写法：连续数组用 table.remove 保持紧凑")
local correct = {"a", "b", "c"}
local removed = table.remove(correct, 2)
print(removed, table.concat(correct, ","), #correct) -- b, a,c, 2
-- 字典删除键仍应赋 nil；无需对字典使用 table.remove。
