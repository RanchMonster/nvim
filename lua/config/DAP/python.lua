return {
   python = {
      {
         name = "Run Current Python File (Project Specific)",
         type = "python",
         request = "launch",
         program = "${file}", -- Debugs the current file
         console = "integratedTerminal",
         justMyCode = false,  -- Often useful for debugging project code
      },
   }
}
