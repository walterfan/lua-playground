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
