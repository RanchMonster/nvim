vim.api.nvim_create_autocmd('VimEnter', {
   group = vim.api.nvim_create_augroup("LazyUpdate", {}),
   callback = function()
      local lazy = require("lazy")
      lazy.update({ show = false })
   end,
})
