local M = {}

local function close()
   if LogoBuffer ~= nil and uiOpen then
      vim.api.nvim_buf_delete(LogoBuffer, {})
      local autocmds = vim.api.nvim_get_autocmds({
         group = "FileTreeIcon",
      })
      vim.api.nvim_del_autocmd(autocmds[1].id)
      LogoBuffer = nil
   end
end

local function filetree_icon_open()
   -- Creates the split
   local oil_buffer = vim.api.nvim_get_current_buf()

   vim.cmd("topleft new")
   vim.cmd("resize 19") -- height matches logo height

   local logo = {
      "                   -`                    ",
      "                  .o+`                   ",
      "                 `ooo/                   ",
      "                `+oooo:                  ",
      "               `+oooooo:                 ",
      "               -+oooooo+:                ",
      "             `/:-:++oooo+:               ",
      "            `/++++/+++++++:              ",
      "           `/++++++++++++++:             ",
      "          `/+++ooooooooooooo/`           ",
      "         ./ooosssso++osssssso+`          ",
      "        .oossssso-````/ossssss+`         ",
      "       -osssssso.      :ssssssso.        ",
      "      :osssssss/        osssso+++.       ",
      "     /ossssssss/        +ssssooo/-       ",
      "   `/ossssso+/:-        -:/+osssso+-     ",
      "  `+sso+:-`                 `.-/+oso:    ",
      " `++:.                           `-/+/   ",
      " .`                                 `/   ",
   }

   vim.api.nvim_buf_set_lines(0, 0, -1, false, logo)
   local bufnr = vim.api.nvim_get_current_buf()
   -- Set as global for simplicity
   LogoBuffer = bufnr

   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, logo)


   -- Optional cleanup and polisvim.api.nvim_set_hl(0, "PinkBright", { fg = "#ff87d7", bold = true }) -- *.c
   vim.api.nvim_set_hl(0, "Magenta", { fg = "#d787ff", bold = true })     -- *.h
   vim.api.nvim_set_hl(0, "Lavender", { fg = "#af87d7", bold = false })   -- *.o
   vim.api.nvim_set_hl(0, "PurpleDark", { fg = "#875faf", bold = false }) -- dark base

   -- You can change this list to fine-tune line-by-line colors
   local hl_groups = {
      "PinkBright", "PinkBright", "Magenta", "Magenta", "Magenta",
      "Lavender", "Lavender", "Lavender", "Lavender", "Lavender",
      "PurpleDark", "PurpleDark", "PurpleDark", "Lavender", "Lavender",
      "Magenta", "Magenta", "PinkBright", "PinkBright",
   }

   for i = 0, #logo - 1 do
      ---@diagnostic disable-next-line: deprecated
      vim.api.nvim_buf_add_highlight(bufnr, -1, hl_groups[i + 1] or "Normal", i, 0, -1)
   end
   vim.bo.buftype = "nofile"
   vim.bo.bufhidden = "wipe"
   vim.bo.swapfile = false
   vim.bo.modifiable = false
   vim.wo.number = false
   vim.wo.relativenumber = false

   vim.api.nvim_feedkeys("<C-w>j", "n", true)
   vim.api.nvim_create_augroup("FileTreeIcon", { clear = true })
   vim.api.nvim_create_autocmd("BufLeave", {
      group = "FileTreeIcon",
      pattern = "oil://*",
      callback = close,
   })
   vim.api.nvim_win_set_buf(0, oil_buffer)
end

M.open = function()
   filetree_icon_open()
end

filetree_icon_open()
return M
