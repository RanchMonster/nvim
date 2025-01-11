vim.keymap.set("n", "<Leader>c", "mpyiwoif not <esc>pA:<enter>return<esc>`p")

local function get_arg_node()
   local node = vim.treesitter.get_node { ignore_injections = false }
   if not node then
      print("node")
      return
   end
   local function_node = find_node_ancestor({ "function_definition" }, node)
   if not function_node then
      print("function")
      return
   end
   local args = nc({ "parameters" }, function_node)
   if not args then
      print("args")
      return
   end
   local iden = args:child(args:child_count() - 1)
   if not iden then
      print(args:type())
      return
   end
   return iden
end

vim.keymap.set("n", "<leader>ga", function()
   local arg_node = get_arg_node()
   if not arg_node then
      return
   end
   local end_row, end_col = arg_node:end_()
   vim.api.nvim_win_set_cursor(0, { end_row, end_col })
   vim.cmd("norm vi(")
end)
vim.keymap.set("n", "<leader>aa", function()
   local arg_node = get_arg_node()
   local end_row, end_col = arg_node:end_()
   vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 3 })
   vim.api.nvim_feedkeys("a, ", "n", true)
   -- vim.cmd("Esc")
end)

vim.keymap.set(
   "n",
   "<leader>tc",
   "otry:<enter>pass<enter>catch:<enter>pass<C-c>makkS"
)
