local function unbind()
   vim.api.nvim_feedkeys(" ", "i", false)
   vim.keymap.del("i", "<Leader>")
   vim.keymap.del("i", "<Leader><Leader>")
   vim.keymap.del("i", "<Esc>")
   vim.keymap.del("i", "<C-c>")
end

local function bind()
   vim.api.nvim_feedkeys("i", "n", false)
   Key("i", "<Leader>", "_", "Temporary binding for _ seporation in snake case")
   Key("i", "<Leader><Leader>", function()
      unbind()
   end, "Unbind for snake case")
   Key("i", "<C-c>", function()
      unbind()
   end, "Unbind for snake case")
   Key("i", "<Esc>", function()
      unbind()
   end, "Unbind for snake case")
end

Key("n", "s", function() bind() end, "Binds the snake case writing tool")
