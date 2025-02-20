vim.api.nvim_create_user_command("W", ":w", { bang = false })
vim.api.nvim_create_user_command("Q", ":q!", { bang = false })
vim.api.nvim_create_user_command("Vscode", vim.cmd("colorscheme vscode"), { bang = false })
vim.api.nvim_create_user_command("Esc", ":execute \"norm \\<Esc>\"", { bang = false })
