function auto_init()
   local text_before_cursor = vim.fn.getline("."):sub(vim.fn.col "." - 3, vim.fn.col "." - 1)
   print(text_before_cursor)
   if not text_before_cursor == "ini" then
      vim.api.nvim_feedkeys("t", "n", true)
      return
   end

   local buffer = vim.fn.bufnr()

   -- Move the cursor into a node
   local pos = vim.api.nvim_win_get_cursor(0)
   vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })

   local current_node = vim.treesitter.get_node { ignore_injecions = false }
   if not current_node then
      pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
      vim.api.nvim_feedkeys("t", "n", true)
      return
   end

   local class_node = find_node_ancestor({ "class_definition" }, current_node)
   if not class_node then
      pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
      vim.api.nvim_feedkeys("t", "n", true)
      return
   end

   -- Detect __init__ function
   local function_node = nc({ "function_definition" }, nc({ "block" }, class_node))
   if function_node then
      pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
      vim.api.nvim_feedkeys("t", "n", true)
      local function_name_node = nc({ "identifier" }, function_node)
      if not function_name_node then
         pos = vim.api.nvim_win_get_cursor(0)
         vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
         vim.api.nvim_feedkeys("t", "n", true)
         return
      end
      local function_name = vim.treesitter.get_node_text(function_name_node)
      if function_name == "__init__" then
         pos = vim.api.nvim_win_get_cursor(0)
         vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
         vim.api.nvim_feedkeys("t", "n", true)
         return
      end
   end


   local block_node = nc({ "block" }, class_node)
   if not block_node then
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
      return
   end
   local start_row, start_col = block_node:start()
   local end_row, end_col = block_node:end_()
   vim.api.nvim_buf_set_text(buffer, start_row, start_col, end_row, end_col,
      { "def __init__( self ) -> None: pass " })
   vim.cmd("execute \"norm $6bema$bi\\<Enter>\\<Esc>embviw\"")
   local pos = vim.api.nvim_win_get_cursor(0)
   vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + 1 })
   vim.cmd("Esc")
end

vim.keymap.set("i", "t", function()
   auto_init()
end)
