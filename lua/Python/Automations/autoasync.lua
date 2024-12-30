function add_async()
   
   local buffer = vim.fn.bufnr() -- Gets the current buffer / window
   local text_before_cursor = vim.fn.getline("."):sub(vim.fn.col "." - 4, vim.fn.col "." -1 )
   if text_before_cursor ~= "await" then 
      return 
   end
   local current_node = vim.treesitter.get_node { ignore_injections = false }
   local function_node = find_node_ancestor(
      { "function_definition" },
      current_node
   )
   if not function_node then
      return 
   end
   local function_text = vim.treesitter.get_node_text( function_node, 0 )
   if vim.startswith( function_text, 'async ' ) then 
      return 
   end

   local start_row, start_col = function_node:start()
   vim.api.nvim_buf_set_text( buffer, start_row, start_col, start_row, start_col, { 'async ' } )

end
