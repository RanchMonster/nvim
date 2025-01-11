local function testOutput(string)
   if not string then return end
   vim.api.nvim_feedkeys("mpo" .. string .. "<esc>`p", "n", false)
end

vim.api.nvim_create_user_command("Input", 
   function() 
      vim.ui.input( { promt = "Enter a number" }, function( input )
         print( input )
      end )
   end,
   { bang = false }
)
