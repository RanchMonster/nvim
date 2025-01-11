local function jump_to(node)
   if not node then return end
   local node_row, _ = node:start()
   vim.api.nvim_win_set_cursor(0, { node_row, 0 })
end

local function last_function()
   local node = vim.treesitter.get_node { ignore_injectoins = false }
   if not node then return end
   local current_function = find_node_ancestor({ "function_definition" }, node)
   if not current_function then return end
   local cursor_row, _ = vim.api.nvim_win_get_cursor(0)
   local function_row, _ = current_function:start()
   if not cursor_row == function_row then
      jump_to(current_function)
      return
   end
   local tree = node:tree()
   if not tree then return end
   local root = tree:root()
   if not root then return end
   local function_nodes = find_node_child({ "function_definition" }, root, 10)
   for i, function_ in pairs(function_nodes) do
      if function_ == current_function then
         if i == 1 then
            jump_to(current_function)
            return
         else
            local last_function_ = current_function[i - 1]
            jump_to(last_function_)
            return
         end
      end
   end
end


local function last_class()
   local buffer = vim.fn.bufnr
end

local function next_function()
   local buffer = vim.fn.bufnr
end

local function next_class()
   local buffer = vim.fn.bufnr
end

-- vim.keymap.set("n", "[", function()
--    last_function()
-- end)
-- vim.keymap.set("n", "]", function()
--    next_function()
-- end)
-- vim.keymap.set("n", "{", function()
--    last_class()
-- end)
-- vim.keymap.set("n", "{", function()
--    next_class()
-- end)
