# Lua Playground

A small web playground for trying Lua snippets. OpenResty serves the page, compiles the code you submit, and runs it inside a restricted LuaJIT environment.

Type Lua in the editor, click **Run**, and the output of `print()` (or a compile/runtime error) appears on the same page.

A snippet menu on the left lists the Lua files in `snippets/`. Click one to load it into the editor, **Save** the editor content as a (new or existing) snippet, or **Delete** the selected snippet.

## Layout

```
lua-playground/
├── docker-compose.yml    # OpenResty service
├── nginx.conf            # routes and rate limit
├── html/
│   └── index.html        # static playground page (editor + snippet menu)
├── lua/
│   ├── executor.lua      # POST /run — validate and return JSON
│   ├── snippets_api.lua  # /snippets* — list, save, delete snippets
│   └── sandbox.lua       # restricted environment and instruction limit
└── snippets/             # snippet library (preloaded into the left menu)
```

There is no separate build step. The app is the static page, the Lua sources, and `nginx.conf`, run by the official OpenResty image.

## Start

You need Docker Compose, or Podman with a Compose provider.

```bash
docker compose up -d
```

Then open [http://localhost:8080](http://localhost:8080).

Stop it with:

```bash
docker compose down
```

`nginx.conf`, `lua/`, and `html/` are mounted into the container. With `lua_code_cache off`, edits under `lua/` are picked up on the next request; `html/` is served statically. Changes to `nginx.conf` need a reload:

```bash
docker compose exec openresty openresty -s reload
```

`snippets/` is mounted writable. Files created from the browser appear there immediately, and files you drop into the folder show up in the menu on the next list refresh.

## What you can run

Scripts get a fresh environment with `math`, `string`, `table`, `coroutine`, and common safe builtins (`pairs`, `ipairs`, `tostring`, `pcall`, `setmetatable`, and similar). `print()` is captured and returned as the output. Arguments to one `print()` are joined with tabs; each call is a new line.

Coroutines created inside a script share the same instruction budget as the main chunk, so loops inside `coroutine.create`/`coroutine.wrap` are bounded too.

These are not available: `os`, `io`, `require`, `package`, `debug`, `ffi`, `load`, `loadstring`, `dofile`, and `loadfile`.

Limits:

| Limit | Value |
| --- | --- |
| Code size | 16 KB |
| CPU | 1,000,000 Lua instructions (shared with coroutines), then the run is aborted |
| Rate | 10 `POST /run` requests per minute per IP, burst 5 |
| Container memory | 256 MB |

The bundled snippet library in `snippets/` tours the language: variables and scope, operators, control flow, functions and varargs, string literals/format/patterns, the math library, tables, iterators, closures, metatables and metamethods, OOP with inheritance, error handling, and coroutines.

The library contains **48 numbered snippets**, grouped in the left menu:

| Numbers | Category |
| --- | --- |
| 01–04 | 基础语法 — basics |
| 05–08 | 函数与集合 — functions and collections |
| 09–13 | 字符串与数学 — strings and math |
| 14–18 | 元表与运行控制 — metatables and runtime control |
| 19–28 | 常见错误·初级 — article mistakes 01–10 |
| 29–38 | 常见错误·中级 — article mistakes 11–20 |
| 39–48 | 常见错误·高级 — article mistakes 21–30 |

See the [complete snippet index](snippets/README.md). The 30 mistake examples
follow `tech_20261022_lua-top-10-mistakes.md` (the article covers thirty mistakes).
Each presents **错误写法 → 正确写法**, with observed results and explanations.
Runtime errors are caught with `pcall` so the correction still runs. Invalid
syntax is shown as source text so it does not prevent the whole snippet compiling.
Module loading and dynamic compilation examples display local Lua source because
those capabilities are disabled in the web sandbox. GC examples explain how to
verify collection locally; the sandbox does not expose `collectgarbage` or `debug`.

The examples correct several statements in the article according to the official
[Lua 5.1 manual](https://www.lua.org/manual/5.1/manual.html) and
[Lua 5.4 manual](https://www.lua.org/manual/5.4/manual.html): table `__gc` is still
supported in standard Lua 5.4; sparse arrays need an explicit traversal bound;
numeric `for` closures already have per-iteration locals in Lua 5.1; a weak-key
entry depends on key reachability; and table length has a documented worst case
of O(log n), rather than a universal O(1) guarantee.

Bundled filenames use a two-digit learning order. Menu labels come from the first
two comment lines, for example:

```lua
-- @category: 01 基础语法
-- @title: 01. Hello Lua
```

The original filename remains the identity used for save/delete. A snippet without
these comments appears under **99 我的片段** with its filename as its label.
The API and flat `snippets/` directory layout remain the same.

This sandbox is for learning and local use. It is not a complete isolation boundary against a hostile user.

## API

`GET /` returns the static playground page (`text/html`, served from `html/index.html` without touching Lua).

`POST /run` accepts `application/x-www-form-urlencoded` with a `code` field.

Success:

```json
{ "output": "Hello from Lua Playground!" }
```

Compile or runtime failure (HTTP 200, so the page can show the message):

```json
{ "error": "Compile error: ..." }
```

Other responses:

- `405` — method is not `POST`
- `400` — missing code, empty code, or code longer than 16 KB
- `503` — rate limit exceeded

## Snippet API

Snippet names are 1–48 characters (letters, digits, spaces, `-`, `_`). Snippet code is capped at 16 KB and at most 100 snippets are kept.

`GET /snippets` lists all snippets:

```json
{ "snippets": [ { "name": "hello", "code": "print(\"hi\")" } ] }
```

`POST /snippets/save` accepts `name` and `code` (form-encoded). Saving an existing name overwrites it:

```json
{ "name": "hello", "updated": true }
```

`POST /snippets/delete` accepts `name` and removes the snippet. Save and delete share the `/run` rate limit.
