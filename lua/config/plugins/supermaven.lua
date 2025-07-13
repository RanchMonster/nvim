-- Find a way so it's only used for tasks like debuging
return {
   {
      "supermaven-inc/supermaven-nvim",
      config = function()
         require("supermaven-nvim").setup({
            keymaps = {
               accept_suggestion = "<C-k>",
               clear_suggestion = "<C-l>",
               accept_word = "<C-j>",
            },
            ignore_filetypes = {}, -- or { "rust", }
            color = {
               suggestion_color = "#ffffff",
               cterm = 244,
            },
            log_level = "info",                -- set to "off" to disable logging completely
            disable_inline_completion = false, -- disables inline completion for use with cmp
            disable_keymaps = false,           -- disables built in keymaps for more manual control
            condition = function()
               local log_patterns = {
                  "print%s*%(",
                  "console%.log%s*%(",
                  "logger%.%a+%s*%(",
                  "System%.out%.println%s*%(",
                  "log::%a+!%s*%(",
               }

               local row, col = unpack(vim.api.nvim_win_get_cursor(0))
               local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
               local before_cursor = line:sub(1, col)

               for _, pattern in ipairs(log_patterns) do
                  if before_cursor:match(pattern) then
                     return false -- disable Supermaven if in logging context
                  end
               end

               return false -- enable elsewhered
            end
         })
      end
   },
}
