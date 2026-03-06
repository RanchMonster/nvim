return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function()
      -- Try to set up treesitter
      local treesitter = require("nvim-treesitter")
      treesitter.install({ 'rust', 'javascript', 'c', 'python' }) -- Add more as needed
      vim.api.nvim_create_autocmd('BufEnter', {
         callback = function()
            -- First, try to call treesitter.start() if it errors then try to install the parser if not already installed
            local ok, parser = pcall(vim.treesitter.start)
            if not ok then
               local filetype = vim.bo.filetype
               if filetype == "typescriptreact" or filetype == "tsx" then
                  filetype = "typescript"
               end
               if vim.tbl_contains(treesitter.get_installed(), filetype) then
                  local ok, parser = pcall(vim.treesitter.start, vim.api.nvim_get_current_buf(), filetype)
               elseif vim.tbl_contains(treesitter.get_available(), filetype) then
                  treesitter.install(filetype)
                  local ok, parser = pcall(vim.treesitter.start, vim.api.nvim_get_current_buf(), filetype)
                  if not ok then
                     vim.notify("Failed to install treesitter parser for " .. filetype)
                  end
               end
            end
         end,
      })
   end
}
