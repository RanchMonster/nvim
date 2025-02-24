function setup()
   vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
end
pcall( setup )
