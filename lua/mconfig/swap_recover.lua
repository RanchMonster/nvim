-- Automatically recover from swap files if they exist
vim.api.nvim_create_autocmd("SwapExists", {
   pattern = "*",
   callback = function(args)
      local choice = vim.fn.confirm(
         "Swap file found!\n" ..
         "1. Recover\n" ..
         "2. Delete it\n" ..
         "3. Quit",
         "&Recover\n&Delete\n&Quit",
         1
      )

      if choice == 1 then
         return vim.vcmdbang -- recover
      elseif choice == 2 then
         vim.fn.delete(vim.fn.expand("<afile>:p"))
         return ":e!"
      else
         vim.cmd("cquit")
      end
   end,
   nested = true,
})
