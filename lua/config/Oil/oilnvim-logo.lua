local M = {}
local api = vim.api

local augroup = api.nvim_create_augroup("FileTreeIcon", { clear = true })

local LogoBuffer = nil
local UiOpen = false
local oil_bufnr = nil

local function close()
   if LogoBuffer and UiOpen then
      if api.nvim_buf_is_valid(LogoBuffer) then
         api.nvim_buf_delete(LogoBuffer, {})
      end
      LogoBuffer = nil
      UiOpen = false
   end
end

local function filetree_icon_open()
   if UiOpen then
      close()
   end
   UiOpen = true

   local oil_window = api.nvim_get_current_win()

   api.nvim_command("topleft new")
   api.nvim_command("resize 19")

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

   local bufnr = api.nvim_get_current_buf()
   LogoBuffer = bufnr

   api.nvim_buf_set_lines(bufnr, 0, -1, false, logo)

   api.nvim_set_hl(0, "Magenta", { fg = "#d787ff", bold = true })
   api.nvim_set_hl(0, "Lavender", { fg = "#af87d7", bold = false })
   api.nvim_set_hl(0, "PurpleDark", { fg = "#875faf", bold = false })
   api.nvim_set_hl(0, "PinkBright", { fg = "#ff87d7", bold = true })

   local hl_groups = {
      "PinkBright", "PinkBright", "Magenta", "Magenta", "Magenta",
      "Lavender", "Lavender", "Lavender", "Lavender", "Lavender",
      "PurpleDark", "PurpleDark", "PurpleDark", "Lavender", "Lavender",
      "Magenta", "Magenta", "PinkBright", "PinkBright",
   }

   for i = 0, #logo - 1 do
      ---@diagnostic disable-next-line: deprecated
      api.nvim_buf_add_highlight(bufnr, -1, hl_groups[i + 1] or "Normal", i, 0, -1)
   end

   vim.bo.buftype = "nofile"
   vim.bo.bufhidden = "wipe"
   vim.bo.swapfile = false
   vim.bo.modifiable = false
   vim.wo.number = false
   vim.wo.relativenumber = false

   api.nvim_set_current_win(oil_window)
end

-- Track entering Oil buffers
api.nvim_create_autocmd("BufEnter", {
   group = augroup,
   callback = function(args)
      local name = api.nvim_buf_get_name(args.buf)
      if name:match("^oil://") then
         oil_bufnr = args.buf
         if not UiOpen then
            filetree_icon_open()
         end
      end
   end,
})

-- Close the logo buffer if we enter a non-oil buffer and we had opened the icon
api.nvim_create_autocmd("BufEnter", {
   group = augroup,
   callback = function(args)
      local name = api.nvim_buf_get_name(args.buf)
      if not name:match("^oil://") and oil_bufnr and UiOpen then
         close()
         oil_bufnr = nil
      end
   end,
})

M.open = function()
   -- Open Oil, then open the logo bar
   vim.cmd("Oil") -- Open Oil normally
   filetree_icon_open()
end

return M
