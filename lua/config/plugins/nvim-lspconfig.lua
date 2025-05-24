return {{
   "neovim/nvim-lspconfig",
   dependencies = {{
      "folke/lazydev.nvim",
      ft ="lua",
      opts = { 
         library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
         },
      },
   }},
   config = function()
      -- Init Lsps --
      require( "lspconfig" ).lua_ls.setup {}
      require( "lspconfig" ).basedpyright.setup {}
      require( "lspconfig" ).rust_analyzer.setup {}
   end,
}}
