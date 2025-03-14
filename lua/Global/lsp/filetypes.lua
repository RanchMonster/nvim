local autofiletype = vim.api.nvim_create_augroup("autofiletype", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
   pattern = "*.slint",
   group = autofiletype,
   callback = function()
      vim.cmd("set filetype=slint")
   end
}
)
vim.api.nvim_create_autocmd({ "BufEnter" }, {
   pattern = { "*.php" },
   group = autofiletype,
   callback = function()
      vim.cmd("set filetype=php")
   end
}
)
