local function load() 
   vim.keymap.set( "n", "<CR>", function()
      local line_text = vim.fn.getline("."):gsub( " ", "" ):gsub( "   ", "" ) -- Just in case
      if line_text == "" then 
         print( "term" )
         return 
      end
      if vim.startswith( line_text, "-[x]" ) then 
         print( "true" )
         vim.api.nvim_feedkeys( "mp0f[lr `p", "n", true )
         vim.api.nvim_feedkeys( "`p", "n", true )
         return
      elseif vim.startswith( line_text, "-[]" ) then
         print( "false" )
         vim.api.nvim_feedkeys( "mp0f[lrx`p", "n", true )
         return
      end
   end )
   vim.keymap.set( "n", "<leader>td", function() 
      vim.cmd( "e Todo.md" )
      vim.cmd( "w" )
   end )
end

load()
