return {
   "nvim-telescope/telescope.nvim",
   dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim",
   },
   ops = {
      extensions = {
         fzf = {},
      },
   },
   config = function()
      local builtin = require("telescope.builtin")
      ---@diagnostic disable-next-line: unused-local
      local telescope = require("telescope")

      -- Nav & Git
      require("telescope").load_extension("fzf")
      Key("n", "<leader>ff", builtin.find_files, "( Telescope ) Find Files")
      Key("n", "<leader>fh", builtin.help_tags, "( Telescope ) Find Help")
      Key("n", "<leader>fgf", builtin.git_files, "( Telescope ) Find Git Files")
      Key("n", "<leader>fgb", builtin.git_branches, "( Telescope ) Find Git Branches")
      Key("ni", "<C-l>", builtin.spell_suggest, "( Telescope ) Spell Suggest")

      require("config.Telescope.live_grep").setup()
   end,
}
