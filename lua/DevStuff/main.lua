function testOutput( string )
   vim.api.nvim_feedkeys( "mpo" .. string .. "<esc>`p" , "n", false )
end
