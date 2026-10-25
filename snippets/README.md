# Snippet 学习目录

共 48 个示例：01–18 为语言基础，19–48 对应文章的 30 个常见错误。

常见错误案例先展示错误写法，再展示正确写法。可运行的错误由 `pcall` 捕获；编译错误以文本展示。
涉及 `require`、`dofile`、`load` 的案例展示本地运行源码；GC 和堆栈案例注明沙箱限制。

文件名中的首个编号为学习顺序，`pitfall-NN` 为文章中的错误编号。
分类和显示标题使用文件开头的 `@category`、`@title` 注释。无分类的自定义片段归入“99 我的片段”。

## 01 基础语法

- [01. Hello Lua](01-hello.lua)
- [02. 变量与作用域](02-variables-and-scope.lua)
- [03. 运算符](03-operators.lua)
- [04. 控制流程](04-control-flow.lua)

## 02 函数与集合

- [05. 函数与可变参数](05-functions.lua)
- [06. 闭包](06-closures.lua)
- [07. 表操作](07-table-utils.lua)
- [08. 迭代器](08-iterators.lua)

## 03 字符串与数学

- [09. 字符串字面量](09-string-literals.lua)
- [10. 字符串格式化](10-string-format.lua)
- [11. 字符串模式](11-string-patterns.lua)
- [12. 字符串工具](12-string-tricks.lua)
- [13. 数学函数](13-math-functions.lua)

## 04 元表与运行控制

- [14. 元表](14-metatables.lua)
- [15. 元方法](15-metamethods.lua)
- [16. 对象与继承](16-oop-inheritance.lua)
- [17. 错误处理](17-error-handling.lua)
- [18. 协程](18-coroutines.lua)

## 05 常见错误·初级（01–10）

- [19. [坑 01] 数组从 1 开始](19-pitfall-01-array-index.lua)
- [20. [坑 02] nil 会删除键](20-pitfall-02-nil-value.lua)
- [21. [坑 03] 带洞表的长度](21-pitfall-03-length-holes.lua)
- [22. [坑 04] 除法与向下取整](22-pitfall-04-division.lua)
- [23. [坑 05] 括号截断多返回值](23-pitfall-05-multiple-returns.lua)
- [24. [坑 06] 拼接要用两个点](24-pitfall-06-concatenation.lua)
- [25. [坑 07] 表的引用比较](25-pitfall-07-table-equality.lua)
- [26. [坑 08] 忘写 local](26-pitfall-08-local-scope.lua)
- [27. [坑 09] 闭包捕获变量](27-pitfall-09-closure-capture.lua)
- [28. [坑 10] 冒号自动传 self](28-pitfall-10-method-self.lua)

## 06 常见错误·中级（11–20）

- [29. [坑 11] ipairs 遇洞停止](29-pitfall-11-ipairs-holes.lua)
- [30. [坑 12] 循环拼接字符串](30-pitfall-12-string-building.lua)
- [31. [坑 13] 元表读写代理](31-pitfall-13-proxy-metatable.lua)
- [32. [坑 14] 默认值吞掉 false](32-pitfall-14-false-default.lua)
- [33. [坑 15] 删除数组元素](33-pitfall-15-array-removal.lua)
- [34. [坑 16] 格式化前验证数字](34-pitfall-16-format-types.lua)
- [35. [坑 17] 捕获错误与定位](35-pitfall-17-error-context.lua)
- [36. [坑 18] 嵌套函数与可变参数](36-pitfall-18-nested-varargs.lua)
- [37. [坑 19] 模块重复加载](37-pitfall-19-module-cache.lua)
- [38. [坑 20] 深浅拷贝](38-pitfall-20-deep-copy.lua)

## 07 常见错误·高级（21–30）

- [39. [坑 21] 共享 upvalue](39-pitfall-21-shared-upvalue.lua)
- [40. [坑 22] 弱键与强引用](40-pitfall-22-weak-table.lua)
- [41. [坑 23] GC 与确定性关闭](41-pitfall-23-finalization.lua)
- [42. [坑 24] 协程双向传值](42-pitfall-24-coroutine-values.lua)
- [43. [坑 25] goto 与局部作用域](43-pitfall-25-goto-scope.lua)
- [44. [坑 26] 位运算与版本](44-pitfall-26-bitwise-version.lua)
- [45. [坑 27] 可调用表](45-pitfall-27-callable-table.lua)
- [46. [坑 28] 动态编译先检查错误](46-pitfall-28-load-errors.lua)
- [47. [坑 29] %q 与普通文本](47-pitfall-29-quoted-strings.lua)
- [48. [坑 30] 热循环与长度](48-pitfall-30-hot-loops.lua)

## 与文章的语义校正

- 坑 02：不要把已经删除的键传给 `next` 来判断是否存在。
- 坑 03/11：带洞数组的遍历上界不能用 `#t` 推断。
- 坑 09：数值 `for` 每轮的局部循环变量在 Lua 5.1 中已经独立；共享外层变量才是本例的问题。
- 坑 13：只需读默认值时，单独配置 `__index` 完全合法；读写代理需保持代理自身为空。
- 坑 16：不要依赖 `%d` 的隐式转换；先验证数字、整数性和范围。
- 坑 17：`pcall` 的错误一般含位置，但不会自动生成完整堆栈。
- 坑 18：保存可变参数时必须记录个数，并在解包时指定上界，保留尾部 nil。
- 坑 22：弱键表主要看键的可达性，不能简单认为值在别处被引用就一定保留条目。
- 坑 23：标准 Lua 5.2+ 包括 5.4 支持表 `__gc`；及时释放资源应显式关闭。
- 坑 25：禁止 `goto` 跳入局部变量作用域的规则从 Lua 5.2 引入 `goto` 时就存在。
- 坑 30：数值 `for` 上界本来就只计算一次；`#t` 也没有普遍 O(1) 保证。

依据：[Lua 5.1 手册](https://www.lua.org/manual/5.1/manual.html)、[Lua 5.4 手册](https://www.lua.org/manual/5.4/manual.html)。
