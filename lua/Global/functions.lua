vim.api.nvim_create_user_command("W", ":w", { bang = false })
vim.api.nvim_create_user_command("Q", ":q!", { bang = false })
vim.api.nvim_create_user_command("Vscode", function()
   vim.cmd("colorscheme vscode") end, { bang = false }
)
vim.api.nvim_create_user_command("Esc", ":execute \"norm \\<Esc>\"", { bang = false })
vim.api.nvim_create_user_command( "English", function()
   vim.opt.spelllang = "en_us"
   vim.opt.wrap = true

 end, { bang = false })

