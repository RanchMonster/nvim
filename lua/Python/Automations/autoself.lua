function add_self()
   local buffer = vim.fn.bufnr()
   local current_node = vim.treesitter.get_node { ignore_injections = false }
   local class_node = find_node_ancestor({ "class_definition" }, current_node)
   if not class_node then
      local function_node = find_node_ancestor({ "function_definition" }, current_node)
      if not function_node then
         return
      end
      local parameters = nc({ "parameters" }, function_node)
      if not parameters then
         return
      end

      local first_param = nc({ "identifier" }, parameters)
      if not first_param then
         return
      end

      if vim.treesitter.get_node_text(first_param, 0) == "self" then
         local row1, col1 = first_param:start()
         local row2, col2 = first_param:end_()
         if parameters:child_count() > 1 then
            vim.api.nvim_buf_set_text(buffer, row1, col1, row2, col2 + 1, { "" })
            return
         end
         vim.api.nvim_buf_set_text(buffer, row1, col1, row2, col2, { "" })
      end
   end
   local decorated = true
   local function_node = find_node_ancestor(
      { "decorated_definition" },
      current_node
   )
   if function_node then
      -- Check if the function has a `staticmethod` decorator
      local decorator = nc({ "decorator" }, function_node)
      if not decorator then
         return
      end
      local identifier = nc({ "identifier" }, decorator)
      if not identifier then
         return
      end
      local decorator_name = vim.treesitter.get_node_text(identifier, 0)
      if decorator_name == "staticmethod" then
         return
      end

      function_node = nc({ "function_definition" }, function_node)
   end

   if not function_node then
      function_node = find_node_ancestor({ "function_definition" }, current_node)
   end
   if not function_node then
      return
   end

   -- Check if the `self` arg is present
   local args = nc({ "parameters" }, function_node)

   if not args then
      return
   end

   local arg_text = vim.treesitter.get_node_text(args, 0)
   if vim.startswith(arg_text, "( self") then
      return
   end

   if arg_text == "" or arg_text == " " then
      local insert = " self"
   else
      local insert = " self,"
   end

   if vim.startswith(arg_text, "()") then
      insert = " self "
   end

   local start_row, start_col = args:start()
   vim.api.nvim_buf_set_text(buffer, start_row, start_col + 1, start_row, start_col + 1, { insert })
end
