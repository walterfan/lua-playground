-- @category: 05 常见错误·初级（01–10）
-- @title: 20. [坑 02] nil 会删除键
print("错误写法：用 nil 表示存在但为空")
local record = {name = "Lua", note = "pending"}
record.note = nil
local count = 0
for _ in pairs(record) do count = count + 1 end
print("字段数：", count) -- 1，note 已不存在
-- 不要 next(record, "note")：传入已经不存在的键可能报 invalid key。

print("正确写法：用独立哨兵表示空值")
local NULL = {}
record.note = NULL
count = 0
for _ in pairs(record) do count = count + 1 end
print("字段数：", count, "note 为空：", record.note == NULL) -- 2, true
