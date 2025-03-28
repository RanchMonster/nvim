local python_debugger = require("dap-python")
local cwd = vim.fn.getcwd()
local debugger_set = false
function first_time_setup()
   local input = vim.fn.input("would you like to create a venv [y/n]:")
   if input == "y" then
      vim.fn.system("python3 -m venv .venv")
      vim.fn.system(".venv/bin/python -m pip install debugpy")

      python_debugger.setup(".venv/bin/python")
   elseif input == "n" then
      os.execute("touch .novenv")
      python_debugger.setup("python3")
   else
      first_time_setup()
   end
end

for _, item in ipairs(vim.fn.readdir(cwd)) do
   if item == ".venv" then
      python_debugger.setup(".venv/bin/python")
      debugger_set = true
      break
   elseif item == ".novenv" then
      python_debugger.setup("python3")
      debugger_set = true
      break
   end
end
if not debugger_set then
   first_time_setup()
end

