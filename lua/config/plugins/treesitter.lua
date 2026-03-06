return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function()
      -- Try to set up treesitter
      local treesitter = require("nvim-treesitter")
      treesitter.install({ 'rust', 'javascript', 'c', 'python' }) -- Add more as needed
      vim.api.nvim_create_autocmd('BufEnter', {
         callback = function()
            local filetype = vim.bo.filetype
            if vim.tbl_contains(treesitter.get_installed(), filetype) then
               vim.treesitter.start()
            elseif vim.tbl_contains(treesitter.get_available(), filetype) then
               treesitter.install(filetype)
            end
         end,
      })
   end
}
