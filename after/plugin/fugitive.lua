function setup()
   vim.keymap.set( "n", "<leader>gs", vim.cmd.Git )
end
pcall( setup )


