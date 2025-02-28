local extensions = {
   "py",
   "lua",
   "c",
   "cpp",
   "java",
   "js",
   "ts",
   "html",
   "css",
   "sh",
   "go",
   "rs",
   "hs",
}

local function add_tagline()
   local flag = false
   for i = 1, #extensions do
      if vim.fn.expand("%:e") == extensions[i] then
         flag = true
         break
      end
   end

   if not flag then return end

   local file_path = vim.fn.expand("%")
   local date = vim.cmd("!date")
   vim.cmd("norm mp")
   vim.api.nvim_win_set_cursor( 0, { 1, 1 } )
   vim.api.nvim_feedkeys( "\n"..file_path.."\n", "n", true )
   vim.api.nvim_win_set_cursor( 0, { 1, 0 } )
   vim.api.nvim_feedkeys( date.."\n", "n", true )
   vim.cmd("norm `p")
end

vim.api.nvim_create_user_command( "TagLine", function()
   add_tagline()
end, { bang = false })

vim.api.nvim_create_augroup( "TagLineGroup", { clear = true })

-- vim.api.nvim_create_autocmd( { "BufEnter" }, {
--    command = "TagLine",
--    group = "TagLineGroup",
-- })
--
