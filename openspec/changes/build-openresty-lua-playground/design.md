# Design

## Context

See `proposal.md` for the motivation and scope. OpenResty bundles NGINX with LuaJIT and core Lua libraries (`cjson`, `lua-resty-*`), allowing the web server to directly compile, sandbox, and execute Lua code without an external application runtime or process fork for every request.

## Goals / Non-Goals

**Goals:**
- Provide a lightweight, self-contained Lua playground runnable via Docker Compose.
- Sandbox untrusted Lua execution at the language level by substituting the global environment using `setfenv` and a strict symbol whitelist.
- Capture all user `print()` calls in memory to return formatted standard output.
- Guard against runaway loops using a cooperative VM instruction count hook (`debug.sethook`).
- Rate-limit execution requests using NGINX `limit_req_zone`.

**Non-Goals:**
- Hostile multi-tenant zero-trust execution boundary (OS-level cgroups, ptrace, or Luau C-level VM isolation are out of scope for this learning playground).
- Code persistence, snippet sharing, or database integration.
- Multiple selectable Lua versions or runtime engines.
- Complex browser code editor dependencies (e.g. Monaco/CodeMirror) in this initial phase; use accessible native textareas with monospaced styling.

## Decisions

### 1. In-Process Execution with LuaJIT vs External Subprocess
- **Choice:** Execute scripts within the OpenResty worker process using `loadstring` and `setfenv`.
- **Rationale:** Minimizes latency, keeps resource overhead low, and requires no external process management or IPC.
- **Alternative Considered:** Forking `lua` CLI subprocesses via `os.execute` or pipes. Rejected due to fork overhead, potential zombie processes, and increased server complexity.

### 2. Environment Whitelisting for Sandboxing
- **Choice:** Construct a fresh environment table per execution containing only safe functions (`assert`, `error`, `ipairs`, `pairs`, `next`, `pcall`, `xpcall`, `select`, `tonumber`, `tostring`, `type`, `unpack`, `rawequal`, `rawget`, `rawset`, and copies of `math`, `string`, `table`). Explicitly omit `os`, `io`, `require`, `package`, `dofile`, `loadfile`, `load`, `loadstring`, `debug`, and `ffi`.
- **Rationale:** Lua 5.1 / LuaJIT's `setfenv` confines chunk execution to this table. Without module loaders or OS bindings, user scripts cannot access filesystem or network resources.
- **Alternative Considered:** Metatable fallback to `_G` with blacklisting. Rejected because blacklisting frequently misses obscure globals or internal escape paths.

### 3. Print Output Redirection
- **Choice:** Provide a custom `print(...)` function inside the sandbox environment that converts all arguments to strings, joins arguments with tabs, and appends rows to an internal Lua table buffer.
- **Rationale:** Standard `print` in OpenResty prints to NGINX standard error log. Intercepting it in the sandbox captures standard output cleanly for the HTTP response.
- **Alternative Considered:** Monkey-patching global `io.write`. Rejected because `io` is completely removed from the sandbox.

### 4. Cooperative CPU Limiting via `debug.sethook`
- **Choice:** Attach an instruction hook with a limit of 1,000,000 instructions (`debug.sethook(hook, "", 1000000)`). Remove the hook in `pcall` completion.
- **Rationale:** Traps infinite loops (e.g., `while true do end`) and raises an execution timeout error.
- **Alternative Considered:** POSIX timers / OS signals. Rejected because signal handling inside LuaJIT and NGINX event loops can cause worker instability.

### 5. Transport and API Protocol
- **Choice:** Serve single-page UI at `GET /` and accept AJAX submissions at `POST /run` with `x-www-form-urlencoded` body, responding with JSON (`{ "output": "..." }` or `{ "error": "..." }`).
- **Rationale:** Straightforward web semantics, simple error parsing, and natural fit for NGINX rate limiting and form parsing.
- **Alternative Considered:** WebSocket or Server-Sent Events. Rejected as unnecessary overhead for batch script execution.

## Risks / Trade-offs

- **[Risk: C functions or regex catastrophic backtracking bypass instruction hook]**  
  → *Mitigation:* Exclude dangerous C modules and keep string library available with 16 KB payload limits. Note in documentation that this sandbox is intended for education/internal use.
- **[Risk: Memory exhaustion by script creating large tables or strings]**  
  → *Mitigation:* Enforce 16 KB code size limit, 1M instruction limit, and configure Docker container memory caps (e.g., `--memory 256m`).
- **[Risk: Development code reload latency vs production caching]**  
  → *Mitigation:* Set `lua_code_cache off` during local development and document switching to `lua_code_cache on` for production deployments.

## Migration Plan

1. Deploy using Docker Compose: `docker compose up -d`.
2. Access playground at `http://localhost:8080`.
3. To reload changes in production mode: `docker compose exec openresty openresty -s reload`.
