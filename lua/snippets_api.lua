-- Snippet library for the playground: list, save, delete.
-- Serves /snippets (GET), /snippets/save (POST), /snippets/delete (POST).
-- Files live in /app/snippets/<name>.lua.

local cjson = require("cjson.safe")

local SNIPPETS_DIR = "/app/snippets/"
local MAX_CODE_BYTES = 16384
local MAX_NAME_CHARS = 48
local MAX_SNIPPETS = 100

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

local function valid_name(name)
    return type(name) == "string"
        and #name > 0
        and #name <= MAX_NAME_CHARS
        and name:match("^[%w%-_][%w%-_ ]*$") ~= nil
end

local function path_for(name)
    return SNIPPETS_DIR .. name .. ".lua"
end

local function read_post_args()
    ngx.req.read_body()
    local args, err = ngx.req.get_post_args()
    if not args then
        if err and err:find("temp file", 1, true) then
            return nil, "Snippet too long (max 16 KB)"
        end
        return nil, "Cannot parse form data: " .. (err or "unknown")
    end
    return args
end

-- Directory listing via the internal autoindex location.
local function list_entries()
    local res = ngx.location.capture("/snippet-index/")
    if res.status ~= 200 then
        return nil, "Failed to list snippets (status " .. res.status .. ")"
    end
    if not res.body or res.body == "" then
        return {}
    end
    local entries, decode_err = cjson.decode(res.body)
    if not entries then
        return nil, "Failed to parse snippet list: " .. tostring(decode_err)
    end
    return entries
end

local function snippet_files(entries)
    local files = {}
    for i = 1, #entries do
        local entry = entries[i]
        if entry.type == "file" and type(entry.name) == "string"
            and entry.name:match("%.lua$") then
            files[#files + 1] = entry.name
        end
    end
    return files
end

local function handle_list()
    local entries, err = list_entries()
    if not entries then
        say_json(500, { error = err })
        return
    end

    local snippets = {}
    for _, file_name in ipairs(snippet_files(entries)) do
        local file = io.open(SNIPPETS_DIR .. file_name, "r")
        if file then
            local code = file:read("*a")
            file:close()
            snippets[#snippets + 1] = {
                name = file_name:sub(1, #file_name - 4),
                code = code,
            }
        end
    end

    table.sort(snippets, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    say_json(200, { snippets = snippets })
end

local function name_from_args(args)
    local name = args.name
    if type(name) ~= "string" then
        return nil, "No snippet name provided"
    end
    name = name:gsub("^%s+", ""):gsub("%s+$", "")
    if not valid_name(name) then
        return nil, "Invalid name: use 1-" .. MAX_NAME_CHARS ..
            " letters, digits, spaces, '-' or '_'"
    end
    return name
end

local function handle_save()
    local args, err = read_post_args()
    if not args then
        say_json(400, { error = err })
        return
    end

    local name, name_err = name_from_args(args)
    if not name then
        say_json(400, { error = name_err })
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

    local entries, list_err = list_entries()
    if not entries then
        say_json(500, { error = list_err })
        return
    end

    local target = name .. ".lua"
    local exists = false
    local files = snippet_files(entries)
    for _, file_name in ipairs(files) do
        if file_name == target then
            exists = true
            break
        end
    end
    if not exists and #files >= MAX_SNIPPETS then
        say_json(400, { error = "Too many snippets (max " .. MAX_SNIPPETS .. ")" })
        return
    end

    local file, open_err = io.open(path_for(name), "w")
    if not file then
        say_json(500, { error = "Cannot write snippet: " .. tostring(open_err) })
        return
    end
    file:write(code)
    file:close()

    say_json(200, { name = name, updated = exists })
end

local function handle_delete()
    local args, err = read_post_args()
    if not args then
        say_json(400, { error = err })
        return
    end

    local name, name_err = name_from_args(args)
    if not name then
        say_json(400, { error = name_err })
        return
    end

    local ok, remove_err = os.remove(path_for(name))
    if not ok then
        if remove_err and tostring(remove_err):find("No such file") then
            say_json(404, { error = "Snippet not found: " .. name })
        else
            say_json(500, { error = "Cannot delete snippet: " .. tostring(remove_err) })
        end
        return
    end

    say_json(200, { name = name })
end

local uri = ngx.var.uri
local method = ngx.req.get_method()

if uri == "/snippets" then
    if method ~= "GET" then
        say_json(405, { error = "Method not allowed" })
        return
    end
    handle_list()
elseif uri == "/snippets/save" then
    if method ~= "POST" then
        say_json(405, { error = "Method not allowed" })
        return
    end
    handle_save()
elseif uri == "/snippets/delete" then
    if method ~= "POST" then
        say_json(405, { error = "Method not allowed" })
        return
    end
    handle_delete()
else
    ngx.status = 404
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say('{"error":"Not found"}')
end
