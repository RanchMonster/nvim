return {
   python = {
      {
         name = "Run Current File",
         type = "python",
         request = "launch",
         program = "${file}", -- Debugs the current file
         console = "integratedTerminal",
         justMyCode = true,   -- Often useful for debugging project code
      },
      {
         console = "integratedTerminal",
         justMyCode = true,
         name = "Run Poetry Project",
         program = function()
            local project_path = vim.fn.getcwd() .. "/src/"
            local module_name = vim.fn.readdir(project_path)[1]
            return project_path .. module_name
         end,
         request = "launch",
         python = function()
            local python = vim.fn.system("poetry env info --path"):gsub("\n", "")
            python = python .. "/bin/python"
            if vim.fn.executable(python) == 1 then
               return python
            else
               error("python executable not found")
            end
         end,
         type = "python"
      }
   }
}
