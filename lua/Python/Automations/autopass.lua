function check_pass()

   local buffer = vim.fn.bufnr()
   local current_node = vim.treesitter.get_node { ignore_injections = false }

   local function_node = find_node_ancestor( { "function_definition" }, current_node )
   if not function_node then
      return
   end


   local function_block = nc( { "block" }, function_node )
   if not function_block then
      return
   end

   local pass_statement = nc( { "pass_statement" }, function_block )
   if not pass_statement then

      if not function_block:child_count() == 0 then
      
         local start_row, start_col = function_block:start()
         vim.api.nvim_buf_set_text( buffer, start_row + 1, start_col + 3, start_row + 1, start_col + 3, { "pass" } )

      end

      return
   end

   if function_block:child_count() == 1 then
      return
   end

   local pass_start_row = pass_statement:start()

   vim.fn.deletebufline( buffer, pass_start_row + 1 )
end
