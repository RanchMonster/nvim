local uv = vim.loop
local socket_path = "/tmp/nvim-status"

local pipe = uv.new_pipe(false)

local function try_connect()
    pipe:connect(socket_path, function(err)
        if err then
            vim.defer_fn(try_connect, 2000)
        end
    end)
end
try_connect()

local function send_status()
    local ok, status = pcall(vim.json.encode, {
        current_file = vim.fn.expand("%:p"),
        current_project = vim.fn.getcwd(),
        current_language = vim.bo.filetype,
        since = os.time(),
    })
    if ok then
        local _, write_err = pipe:write(status .. "\n")
        if write_err then
            pipe:close()
            pipe = uv.new_pipe(false)
            try_connect()
        end
    end
end

local group = vim.api.nvim_create_augroup("PortfolioStatus", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FocusGained", "VimResume" }, {
    group = group,
    callback = send_status,
})

send_status()
