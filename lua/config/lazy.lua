-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
   if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
         { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
         { out,                            "WarningMsg" },
         { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
   end
end
vim.opt.rtp:prepend(lazypath)
local uv = vim.uv
-- Ensure needed deps to build packages from source are installed
local cargo_path = vim.fn.system("command -v cargo")
if not cargo_path or cargo_path == "" then
   vim.notify("This neovim setup requires cargo to be installed to build plugins", vim.log.levels.ERROR)
   return
end
-- Setup lazy.nvim
require("lazy").setup({
   spec = {
      { import = "config.plugins" },
   },
   checker = { enabled = true },
})
