return {
   "nvim-telescope/telescope.nvim",
   dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim",
   },
   config = function()
      require("telescope").setup({
         defaults = {
            -- border = false, -- disables all borders
         },
         extensions = {
            fzf = {},
         },
      })
      local builtin = require("telescope.builtin")
      ---@diagnostic disable-next-line: unused-local
      local telescope = require("telescope")

      -- Nav & Git
      require("telescope").load_extension("fzf")
      Key("n", "<leader>ff", builtin.find_files, "( Telescope ) Find Files")
      Key("n", "<leader>fh", builtin.help_tags, "( Telescope ) Find Help")
      Key("n", "<leader>Gf", builtin.git_files, "( Telescope ) Find Git Files")
      Key("n", "<leader>Gb", builtin.git_branches, "( Telescope ) Find Git Branches")
      local live_grep = require("config.Telescope.live_grep")
      Key("n", "<C-g>", live_grep.multigrep, "( Telescope ) Live Grep")
   end,
}
