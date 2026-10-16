# Proposal

## Why

Developers and learners need a quick, zero-install environment to test Lua code snippets and observe execution output safely. Building a self-contained Lua playground with OpenResty allows request handling, web UI delivery, script sandboxing, and execution to run inside an efficient NGINX worker process with minimal overhead.

## What Changes

- Create an OpenResty configuration (`nginx.conf`) configuring HTTP listening, module paths, rate limiting, and routing for UI and execution endpoints.
- Add a web interface handler (`lua/playground.lua`) that serves an HTML/CSS/JS playground with dark theme, code editing area, inline execution runner, and formatted output display.
- Add an execution API handler (`lua/executor.lua`) providing `POST /run` with request body parsing, payload size validation (max 16 KB), JSON formatting, and error handling.
- Add an isolated sandbox module (`lua/sandbox.lua`) providing environment replacement via `setfenv`, whitelisted safe built-ins (math, string, table, assertions), captured `print()` output buffering, and instruction count limits using `debug.sethook`.
- Provide a `docker-compose.yml` definition for running OpenResty in a lightweight Alpine container.

## Capabilities

### New Capabilities
- `playground-web-ui`: Serves the single-page web UI at `GET /` with an editor textarea, run button, and asynchronous output console.
- `code-execution-api`: Provides `POST /run` endpoint validating payload constraints, invoking the sandbox, and returning structured JSON outputs.
- `lua-sandbox`: Executes untrusted Lua code in a restricted environment with whitelisted globals, intercepted standard output, and CPU instruction execution bounds.

### Modified Capabilities
*(None - this is a new greenfield project)*

## Impact

- **New Files**: `nginx.conf`, `docker-compose.yml`, `lua/playground.lua`, `lua/executor.lua`, `lua/sandbox.lua`.
- **APIs**: Exposes `GET /` (HTML playground) and `POST /run` (JSON execution endpoint).
- **Dependencies**: Requires OpenResty (LuaJIT + `cjson.safe` library) and Docker / Docker Compose for containerized execution.
- **Security**: User scripts run in an isolated environment without access to filesystem, OS shell, network, debugging hooks, or LuaJIT FFI.
