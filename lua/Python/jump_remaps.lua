function last_function()
   local buffer = vim.fn.bufnr
end
function last_class()
   local buffer = vim.fn.bufnr
end
function next_function()
   local buffer = vim.fn.bufnr
end
function next_class()
   local buffer = vim.fn.bufnr
end


vim.keymap.set( "n", "[", last_function )
vim.keymap.set( "n", "]", next_function )
vim.keymap.set( "n", "{", last_class )
vim.keymap.set( "n", "{", next_class )
