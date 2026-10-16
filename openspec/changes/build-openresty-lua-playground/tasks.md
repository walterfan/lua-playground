# Tasks

## 1. Project Scaffolding and NGINX Configuration

- [x] 1.1 Create directory layout and `nginx.conf` with OpenResty worker configuration, package search paths, rate-limiting zones (`exec_limit`), and route definitions for `/` and `/run`; verify configuration format and file presence.
- [x] 1.2 Create `docker-compose.yml` defining the `openresty/openresty:alpine` service with port mapping `8080:80` and configuration volume mounts; verify valid compose syntax with `docker compose config`.

## 2. Lua Sandbox Implementation

- [x] 2.1 Implement `lua/sandbox.lua` constructing a restricted global environment with safe built-ins (`math`, `string`, `table`, `pairs`, `ipairs`, `tostring`, `pcall`), explicitly omitting unsafe libraries (`os`, `io`, `require`, `debug`, `ffi`); verify sandbox blocks dangerous globals while allowing safe computations.
- [x] 2.2 Implement print output buffering and cooperative CPU limiting via `debug.sethook` in `lua/sandbox.lua`; verify execution timeouts on infinite loops and verify proper concatenation of multi-argument `print()` calls.

## 3. Execution API Handler

- [x] 3.1 Implement `lua/executor.lua` to enforce HTTP POST method validation, parse request body, and reject scripts exceeding 16 KB (16,384 bytes); verify HTTP 405 on GET requests and HTTP 400 on oversized or empty payloads.
- [x] 3.2 Wire `lua/executor.lua` to invoke `sandbox.run` and return JSON responses (`{ "output": "..." }` or `{ "error": "..." }`) via `cjson.safe`; verify JSON response structure and appropriate HTTP status codes.

## 4. Web Playground User Interface

- [x] 4.1 Implement `lua/playground.lua` to serve the single-page HTML/CSS interface with dark styling, code editor textarea, run trigger button, and output console container; verify `GET /` responds with `text/html; charset=utf-8`.
- [x] 4.2 Implement client-side JavaScript in `lua/playground.lua` to submit code asynchronously to `POST /run` via XMLHttpRequest and render success output or error diagnostics; verify UI updates smoothly without full-page reload.

## 5. End-to-End Testing and Verification

- [x] 5.1 Launch the playground stack via `docker compose up -d` and verify the service responds on `http://localhost:8080/`.
- [x] 5.2 Validate end-to-end execution across test scenarios: standard printing, syntax error reporting, infinite loop timeout abort, and blocked dangerous functions (`os.execute`, `io.open`).
