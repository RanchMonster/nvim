-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Lang
vim.opt.spelllang = "en_us"

-- Formatting
-- Tabs
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.smartindent = true
-- Wrapping
vim.opt.wrap = true

-- Backups/Saves
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Searching
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Coloring
vim.opt.termguicolors = true

-- File Scrolling
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
