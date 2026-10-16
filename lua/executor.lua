local sandbox = require("sandbox")
local cjson = require("cjson.safe")

local MAX_CODE_BYTES = 16384

local function say_json(status, payload)
    ngx.status = status
    ngx.header.content_type = "application/json; charset=utf-8"
    local body = cjson.encode(payload)
    if not body then
        ngx.status = 500
        ngx.say('{"error":"Failed to encode response"}')
        return
    end
    ngx.say(body)
end

if ngx.req.get_method() ~= "POST" then
    say_json(405, { error = "Method not allowed" })
    return
end

ngx.req.read_body()
local args, err = ngx.req.get_post_args()
if not args then
    if err and err:find("temp file", 1, true) then
        say_json(400, { error = "Code too long (max 16 KB)" })
        return
    end
    say_json(400, { error = "Cannot parse form data: " .. (err or "unknown") })
    return
end

local code = args.code
if type(code) ~= "string" or code == "" then
    say_json(400, { error = "No code provided" })
    return
end

if #code > MAX_CODE_BYTES then
    say_json(400, { error = "Code too long (max 16 KB)" })
    return
end

local output, exec_err = sandbox.run(code)
if exec_err then
    say_json(200, { error = exec_err })
else
    say_json(200, { output = output })
end
