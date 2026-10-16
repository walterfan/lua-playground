-- Restricted environment for untrusted Lua snippets (LuaJIT / Lua 5.1).

local _M = {}

local INSTRUCTION_LIMIT = 1000000
-- Hooks fire every HOOK_INTERVAL instructions; INSTRUCTION_LIMIT /
-- HOOK_INTERVAL ticks are allowed, so the total budget is the same as
-- before but is now shared across the main thread and any coroutines.
local HOOK_INTERVAL = 1000

local SAFE_GLOBALS = {
    "assert", "error", "ipairs", "pairs", "next", "pcall", "xpcall",
    "select", "tonumber", "tostring", "type", "unpack",
    "rawequal", "rawget", "rawset", "setmetatable", "getmetatable",
}

local function shallow_copy(src)
    local dst = {}
    for k, v in pairs(src) do
        dst[k] = v
    end
    return dst
end

-- Coroutine facade: threads created by untrusted code inherit the shared
-- instruction-budget hook, so loops inside coroutines are bounded too.
local function make_coroutine(hook)
    local safe = {}
    for name, fn in pairs(coroutine) do
        safe[name] = fn
    end
    safe.create = function(user_fn)
        local co = coroutine.create(user_fn)
        debug.sethook(co, hook, "", HOOK_INTERVAL)
        return co
    end
    safe.wrap = function(user_fn)
        local co = coroutine.create(user_fn)
        debug.sethook(co, hook, "", HOOK_INTERVAL)
        return function(...)
            local results = { coroutine.resume(co, ...) }
            if results[1] then
                return unpack(results, 2)
            else
                error(results[2], 0)
            end
        end
    end
    return safe
end

local function make_env(hook)
    local output_buffer = {}
    local env = {
        math = shallow_copy(math),
        string = shallow_copy(string),
        table = shallow_copy(table),
        coroutine = make_coroutine(hook),
        print = function(...)
            local parts = {}
            local n = select("#", ...)
            for i = 1, n do
                parts[i] = tostring(select(i, ...))
            end
            output_buffer[#output_buffer + 1] = table.concat(parts, "\t")
        end,
    }

    for i = 1, #SAFE_GLOBALS do
        local name = SAFE_GLOBALS[i]
        env[name] = _G[name]
    end

    return env, output_buffer
end

--- Compile and run untrusted source.
-- @param source string
-- @return string|nil captured print output
-- @return string|nil error message
function _M.run(source)
    if type(source) ~= "string" then
        return nil, "Compile error: source must be a string"
    end

    local fn, compile_err = loadstring(source, "user_input")
    if not fn then
        return nil, "Compile error: " .. compile_err
    end

    local timed_out = false
    local ticks_left = INSTRUCTION_LIMIT / HOOK_INTERVAL
    local function hook()
        ticks_left = ticks_left - 1
        if ticks_left <= 0 then
            timed_out = true
            error("execution timeout: instruction limit exceeded", 0)
        end
    end

    local env, output_buffer = make_env(hook)
    setfenv(fn, env)

    -- Instruction hooks do not run inside JIT traces. Keep this chunk
    -- (and its nested protos, which includes coroutine bodies)
    -- interpreted so the limit applies to tight loops.
    if jit and jit.off then
        jit.off(fn, true)
    end

    debug.sethook(hook, "", HOOK_INTERVAL)

    local ok, runtime_err = pcall(fn)
    debug.sethook()

    if not ok then
        if timed_out then
            return nil, "Execution timed out (too many instructions)"
        end
        return nil, "Runtime error: " .. tostring(runtime_err)
    end

    return table.concat(output_buffer, "\n"), nil
end

return _M
