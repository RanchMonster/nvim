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
      builtin = require("telescope.builtin")
      telescope = require( "telescope" )
      
      -- Nav & Git
      require( "telescope" ).load_extension( "fzf" )
      Key( "n", "<leader>ff", builtin.find_files, "( Telescope ) Find Files" )
      -- Key( "n", "<C-g>", function()
      --    builtin.live_grep( vim.input() )
      -- end, "( Telescope ) Find Grep" )
      Key( "n", "<leader>fh", builtin.help_tags, "( Telescope ) Find Help" )
      Key( "n", "<leader>fgf", builtin.git_files, "( Telescope ) Find Git Files" )
      Key( "n", "<leader>fgb", builtin.git_branches, "( Telescope ) Find Git Branches" )
      Key( "ni", "<C-l>", builtin.spell_suggest, "( Telescope ) Spell Suggest" )

      -- Lsp
      Key( "n", "<leader>gd", telescope.lsp_definition, "( Telescope ) Go to Definition" )
      Key( "n", "<leader>fr", telescope.lsp_refrences, "( Telescope ) Find Refrences" )

      require("config.Telescope.live_grep").setup()
   end,
}

