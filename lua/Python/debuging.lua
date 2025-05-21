local python_debugger = require("dap-python")
local uv = vim.loop

-- Helper function to get Poetry venv path
local function get_poetry_venv()
   local handle = io.popen("poetry env info -p 2>/dev/null")
   if handle then
      local result = handle:read("*a")
      handle:close()
      return result and vim.fn.trim(result)
   end
   return nil
end

-- First-time setup: use Poetry to create venv and install debugpy
local function first_time_setup()
   local input = vim.fn.input("No venv found. Create one using Poetry? [y/n]: ")
   if input == "y" then
      print("Creating Poetry venv and installing debugpy...")
      vim.fn.system("poetry install")
      vim.fn.system("poetry run python -m pip install debugpy")

      local poetry_venv = get_poetry_venv()
      if poetry_venv and uv.fs_stat(poetry_venv .. "/bin/python") then
         python_debugger.setup(poetry_venv .. "/bin/python")
      else
         print("Failed to detect Poetry venv after creation.")
      end
   elseif input == "n" then
      os.execute("touch .novenv")
      python_debugger.setup("python3")
   else
      first_time_setup()
   end
end

-- Main logic to set up debugger
local function setup_debugger()
   local cwd = vim.fn.getcwd()
   local items = vim.fn.readdir(cwd)

   for _, item in ipairs(items) do
      if item == ".venv" then
         python_debugger.setup(".venv/bin/python")
         return
      elseif item == ".novenv" then
         python_debugger.setup("python3")
         return
      end
   end

   -- Check for existing Poetry venv
   local poetry_venv = get_poetry_venv()
   if poetry_venv and uv.fs_stat(poetry_venv .. "/bin/python") then
      python_debugger.setup(poetry_venv .. "/bin/python")
   else
      first_time_setup()
   end
end

setup_debugger()

