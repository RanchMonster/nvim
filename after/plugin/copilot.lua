function setup()
   vim.keymap.set("n", "<leader>co", vim.cmd("Copilot"))
end

pcall( setup )
