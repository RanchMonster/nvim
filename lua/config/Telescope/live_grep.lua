local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values
local Job = require "plenary.job"

local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  pickers.new(opts, {
    prompt_title = "Multi Grep",
    finder = finders.new_job(function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      -- Split by single space, not double space
      local pieces = vim.split(prompt, " ", { plain = true })

      local args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      }

      if #pieces >= 1 and pieces[1] ~= "" then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if #pieces >= 2 then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return { "rg", unpack(args) }
    end, make_entry.gen_from_vimgrep(opts), {
      cwd = opts.cwd,
    }),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

M.setup = function() 
   vim.keymap.set("n", "<C-g>", live_multigrep)
end
M.live_multigrep = live_multigrep

return M

