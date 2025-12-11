-- ~/.config/nvim/lua/config/plugins/dap.lua
---@param s string
---@param delimiter string?
---@return table
local function split(s, delimiter)
   delimiter = delimiter or "\n"
   local result = {}
   for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
      table.insert(result, match)
   end
   return result
end

local DEFAULT_CONFIGS = {
   python = {
      {
         name = "Run Current Python File (Project Specific)",
         type = "python",
         request = "launch",
         program = "${file}", -- Debugs the current file
         console = "integratedTerminal",
         justMyCode = false,  -- Often useful for debugging project code
      },
   },
   rust = {
      {
         name = "Launch file (Rust)",
         type = "codelldb",
         request = "launch",
         program = function()
            local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
            if cargo_toml == "" then
               return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
            local cargo_dir = vim.fn.fnamemodify(cargo_toml, ":p:h")
            -- Find package name from Cargo.toml
            local file = io.open(cargo_toml, "r")
            if not file then return end
            local content = file:read("*a")
            file:close()
            local _, _, package_name = string.find(content, 'name%s*=%s*"(.-)"')
            package_name = package_name or "debug"
            local exe_path = cargo_dir .. "/target/debug/" .. package_name
            -- Build if it doesn't exist
            if vim.fn.filereadable(exe_path) == 0 then
               vim.notify("Rust executable not found, building...", vim.log.levels.INFO)
               vim.fn.system({ "cargo", "build" })
            end
            return exe_path
         end,
         cwd = "${workspaceFolder}",
         stopOnEntry = false,
      },
   }
}

return {
   "mfussenegger/nvim-dap",
   dependencies = {
      -- UI for DAP
      {
         "rcarriga/nvim-dap-ui",
         dependencies = { "nvim-neotest/nvim-nio" },
         config = function()
            local dapui = require("dapui")
            dapui.setup()

            -- Auto open/close UI
            local dap = require("dap")
            dap.listeners.after.event_initialized["dapui_config"] = function()
               dapui.open()
               vim.notify("Debugger started", vim.log.levels.INFO)
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
               dapui.close()
               vim.notify("Debugger stopped", vim.log.levels.INFO)
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
               dapui.close()
               vim.notify("Debugger exited", vim.log.levels.INFO)
            end
         end,
      },
      -- Virtual text for debugging
      {
         "theHamsta/nvim-dap-virtual-text",
         opts = {},
      },
      -- Mason integration
      {
         "jay-babu/mason-nvim-dap.nvim",
         dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
         },
         config = function()
            require("mason-nvim-dap").setup({
               ensure_installed = { "codelldb", "node-debug2-adapter", "debugpy" },
               automatic_installation = true,
               handlers = {},
            })
         end,
      },
   },
   config = function()
      -- Add the missing Key function
      local function Key(mode, key, func, desc)
         vim.keymap.set(mode, key, func, { desc = desc, silent = true })
      end

      vim.api.nvim_create_autocmd("BufRead", {
         once = true,
         callback = function()
            local dap = require("dap")
            if vim.fn.filereadable(vim.fn.getcwd() .. "/.nvim/dap.lua") == 1 then
               vim.notify("Loading project-specific DAP configurations: " .. vim.fn.getcwd() .. "/.nvim/dap.lua",
                  vim.log.levels.INFO)
               local success, config = pcall(dofile, vim.fn.getcwd() .. "/.nvim/dap.lua")
               if success then
                  vim.notify("Loaded project-specific DAP configurations: " .. vim.fn.getcwd() .. "/.nvim/dap.lua",
                     vim.log.levels.INFO)
                  dap.configurations = config.configurations or config
               end
            else
               vim.notify("No project-specific DAP configurations found: " .. vim.fn.getcwd() .. "/.nvim/dap.lua",
                  vim.log.levels.INFO)
               local opt = vim.fn.input("Would you like to create a default dap.lua file? (y/n) ")
               if opt == "y" then
                  vim.fn.mkdir(vim.fn.getcwd() .. "/.nvim", "p")
                  local ft = vim.bo.filetype
                  if DEFAULT_CONFIGS[ft] then
                     vim.notify("Using default " .. ft .. " configurations", vim.log.levels.INFO)
                     local valid_lua = vim.inspect(DEFAULT_CONFIGS[ft])
                     local write_table = split(valid_lua, "\n")
                     write_table[1] = "return " .. write_table[1]
                     vim.fn.writefile(write_table, vim.fn.getcwd() .. "/.nvim/dap.lua", "s")
                  else
                     vim.notify("No default " .. ft .. " configuration found", vim.log.levels.INFO)
                     vim.notify("Creating empty dap.lua file", vim.log.levels.INFO)
                     vim.fn.writefile({ "return {}" }, vim.fn.getcwd() .. "/.nvim/dap.lua", "s")
                  end
                  local success, config = pcall(dofile, vim.fn.getcwd() .. "/.nvim/dap.lua")
                  if success then
                     vim.notify("Loaded project-specific DAP configurations: " .. vim.fn.getcwd() .. "/.nvim/dap.lua",
                        vim.log.levels.INFO)
                     dap.configurations = config.configurations or config
                  end
               end
            end
            vim.api.nvim_create_autocmd({ "BufWritePre", "BufWritePost" }, {
               callback = function(ev)
                  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(ev.buf))
                  local abs_path = vim.fs.normalize(vim.fn.getcwd() .. "/" .. ".nvim/dap.lua")
                  if path == abs_path then
                     vim.notify("Detected DAP configuration change: " .. path, vim.log.levels.INFO)
                     local success, config = pcall(dofile, abs_path)
                     if success then
                        vim.notify("Loaded project-specific DAP configurations: " .. abs_path, vim.log.levels.INFO)
                        dap.configurations = config.configurations or config
                     else
                        vim.notify("Failed to load project DAP config: " .. tostring(config), vim.log.levels.ERROR)
                        vim.notify("Using previous DAP configurations", vim.log.levels.INFO)
                     end
                  end
               end
            })
         end,
      })

      -- Setup keymaps
      Key("n", "<F5>", function() require("dap").continue() end, "( DAP ) Continue")
      Key("n", "<F10>", function() require("dap").step_over() end, "( DAP ) Step Over")
      Key("n", "<F11>", function() require("dap").step_into() end, "( DAP ) Step Into")
      Key("n", "<F12>", function() require("dap").step_out() end, "( DAP ) Step Out")
      Key("n", "<leader>b", function() require("dap").toggle_breakpoint() end, "( DAP ) Toggle Breakpoint")
      Key("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
         "( DAP ) Conditional Breakpoint")
      Key("n", "<leader>dr", function() require("dap").repl.open() end, "( DAP ) Open REPL")
      Key("n", "<leader>dl", function() require("dap").run_last() end, "( DAP ) Run Last")
      Key("n", "<leader>dt", function() require("dapui").toggle() end, "( DAP ) Toggle DAP UI")
      Key("n", "<leader>dc", function() require("dap").terminate() end, "( DAP ) Terminate")

      -- Additional useful keymaps
      Key("n", "<leader>de", function() require("dap").eval(vim.fn.input("Expression: ")) end,
         "( DAP ) Evaluate Expression")
      Key("n", "<leader>dw", function()
         local expr = vim.fn.input("Add watch expression: ")
         if expr and expr ~= "" then
            local session = require("dap").session()
            if session then
               session.watches = session.watches or {}
               table.insert(session.watches, { name = expr, expression = expr })
            end
         end
      end, "( DAP ) Add Watch")
   end,
}
