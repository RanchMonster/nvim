-- EzKey
function Key(mode, key, map, desc)
   desc = desc or ""
   local modes = {}
   for i = 1, #mode do
      modes[i] = mode:sub(i, i)
   end
   vim.keymap.set(modes, key, map, { desc = desc })
end

-- File Navigation
Key("n", "<Leader>ft", function() vim.cmd("Oil") end, "Opens the file tree.")

-- Better Indentation
Key("i", "<Tab>", function() vim.cmd("norm >>") end, "Indent")
Key("i", "<S-Tab>", function() vim.cmd("norm <<") end, "Unindent")
Key("n", "<Tab>", ">>", "Indent")
Key("n", "<S-Tab>", "<<", "Unindent")
Key("v", "<Tab>", ">", "Indent")
Key("v", "<S-Tab>", "<", "Unindent")

-- General Util
Key("vi", "<C-c>", "<Esc>", "Allows for <C-c> to exit multiline.")
Key("n", "<leader><leader>", function()
   vim.cmd("so")
   vim.cmd("Lazy")
end, "Refreshes the config and the current file.")
Key("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace")

-- Formatting
Key("n", "<leader>fo", vim.lsp.buf.format, "Formats the file using the lsp.")

-- Navigation
Key("n", "E", "2be", "Moves to the end of the last word.")
Key("v", "J", ":m '>+1<CR>gv=gv", "Move block in visual mode")
Key("v", "K", ":m '<-2<CR>gv=gv", "Move block in visual mode")
Key("n", "J", "mzJ`z", "Cursor stays in place when merging lines")
Key("n", "K", "mzJ`z", "Cursor stays in place when merging lines")
Key("n", "<C-d>", "<C-d>zz", "Center screen after half page jump. ")
Key("n", "<C-u>", "<C-u>zz", "Center screen after half page jump. ")
Key("n", "n", "nzzzv", "Center after find next")
Key("n", "N", "Nzzzv", "Center after find next")
Key("n", "<C-k>", "<cmd>cnext<CR>zz", "Quick Fix Jump")
Key("n", "<C-j>", "<cmd>cprev<CR>zz", "Quick Fix Jump")
Key("n", "<leader>k", "<cmd>lnext<CR>zz", "Random Jump idrk")
Key("n", "<leader>j", "<cmd>lprev<CR>zz", "Random Jump idrk")

-- Better Bin Management
Key("nv", "<leader>d", "\"_d", "A delete that does not store the result.")
Key("n", "<leader>P", "viwp", "Pastes inside the current word.")
Key("x", "<leader>p", [["_dp]], "Paste from trash buffer.")

-- Home functionality
Key("nvi", "<Home>", function()
   local pos1 = vim.api.nvim_win_get_cursor(0)
   vim.cmd("norm ^")
   local pos2 = vim.api.nvim_win_get_cursor(0)
   if pos1[2] == pos2[2] then
      vim.cmd("norm 0")
   end
end, "Smart Home key")

-- DAP mappings
Key("n", "<F5>", function() require"dap".continue() end, "DAP Continue")
Key("n", "<F10>", function() require"dap".step_over() end, "DAP Step Over")
Key("n", "<F11>", function() require"dap".step_into() end, "DAP Step Into")
Key("n", "<F12>", function() require"dap".step_out() end, "DAP Step Out")
Key("n", "<Leader>b", function() require"dap".toggle_breakpoint() end, "DAP Toggle Breakpoint")
