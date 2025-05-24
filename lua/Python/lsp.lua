local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

-- Function to get Poetry venv Python path
local function get_poetry_python()
   local handle = io.popen("poetry env info -p 2>/dev/null")
   if handle then
      local result = handle:read("*a")
      handle:close()
      if result then
         local path = vim.fn.trim(result) .. "/bin/python"
         if vim.fn.executable(path) == 1 then
            return path
         end
      end
   end
   return nil
end

-- Setup for Pyright using Poetry venv
lspconfig.pyright.setup({
   before_init = function(_, config)
      local python_path = get_poetry_python()
      if python_path then
         config.settings = config.settings or {}
         config.settings.python = config.settings.python or {}
         config.settings.python.pythonPath = python_path
         print("Using Poetry venv for Pyright:", python_path)
      else
         print("Warning: Could not find Poetry venv!")
      end
   end,
   root_dir = util.find_git_ancestor or util.path.dirname,
})
