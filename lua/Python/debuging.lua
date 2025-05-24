local python_debugger = require("dap-python")
local uv = vim.loop

-- Internal guard to print only once
local printed_venv = false

-- Setup wrapper that prints the venv being used once
local function setup_and_log(python_path)
   python_debugger.setup(python_path)
   if not printed_venv then
      print("Using venv: " .. python_path)
      printed_venv = true
   end
end

-- Get the Poetry venv path (if Poetry is available)
local function get_poetry_venv()
   local handle = io.popen("command -v poetry >/dev/null 2>&1 && poetry env info -p 2>/dev/null")
   if handle then
      local result = handle:read("*a")
      handle:close()
      return result and vim.fn.trim(result)
   end
   return nil
end

-- First-time setup: ask user to install debugpy via Poetry
local function first_time_setup()
   local input = vim.fn.input("No venv found. Create one using Poetry? [y/n]: ")
   if input == "y" then
      print("Creating Poetry venv and installing debugpy...")
      vim.fn.system("poetry install")
      vim.fn.system("poetry run python -m pip install debugpy")

      local poetry_venv = get_poetry_venv()
      if poetry_venv and uv.fs_stat(poetry_venv .. "/bin/python") then
         setup_and_log(poetry_venv .. "/bin/python")
      else
         print("Failed to detect Poetry venv after creation.")
      end
   elseif input == "n" then
      os.execute("touch .novenv")
      setup_and_log("python3") -- fallback
   else
      first_time_setup()       -- re-prompt
   end
end

-- Main logic: set up the Python debugger using venv if found
local function setup_debugger()
   local cwd = vim.fn.getcwd()
   local items = vim.fn.readdir(cwd)

   for _, item in ipairs(items) do
      if item == ".venv" and uv.fs_stat(".venv/bin/python") then
         setup_and_log(cwd .. "/.venv/bin/python")
         return
      elseif item == ".novenv" then
         setup_and_log("python3")
         return
      end
   end

   -- Try Poetry-managed venv
   local poetry_venv = get_poetry_venv()
   if poetry_venv and uv.fs_stat(poetry_venv .. "/bin/python") then
      setup_and_log(poetry_venv .. "/bin/python")
   else
      first_time_setup()
   end
end

setup_debugger()

