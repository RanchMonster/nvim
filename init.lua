-- EzKey

---@param mode string string of the modes used in the keybind, NOT a table
---@param key string The keys to be pressed to trigger the bind
---@param map string|function What the map does, Do NOT pass in a function call
---@param desc string The description of the bind, NOT required
function Key(mode, key, map, desc)
   desc = desc or ""
   local modes = {}
   for i = 1, #mode do
      modes[i] = mode:sub(i, i)
   end
   vim.keymap.set(modes, key, map, { desc = desc })
end

---@param mode string string of the modes used in the keybind, NOT a table
---@param key string The keys to be pressed to trigger the bind
---@param map string|function What the map does, Do NOT pass in a function call
---@param desc string The description of the bind, NOT required
function LspKey(mode, key, map, desc, buf_opts)
   desc = desc or ""
   local modes = {}
   for i = 1, #mode do
      modes[i] = mode:sub(i, i)
   end
   buf_opts.desc = desc
   vim.keymap.set(modes, key, map, buf_opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("config.lazy")
require("mconfig")
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH
