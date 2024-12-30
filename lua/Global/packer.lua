vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself

	use 'wbthomason/packer.nvim'
  use ({
     "Shadorain/shadotheme"   ,
		config = function()
			vim.cmd( "colorscheme shado" )
		end
   })
   use {
    'williamboman/mason.nvim',
    run = ':MasonUpdate' -- Optional: run :MasonUpdate after installation/update
  }

   use "ThePrimeagen/vim-be-good"

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	} 
   use ({ "xiyaowong/transparent.nvim",
      })
	use ({ 
		"rose-pine/neovim",
		as = "rose-pine",
	})
   use ({ 
      "lukas-reineke/virt-column.nvim",
      opts = 
      {
         char = "a",
         virtcolumn = "10",
         hilight = { "NonText" }
      }
   })
	use ( "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use ( "nvim-treesitter/playground" )
	use ( "theprimeagen/harpoon" )
	use ( "mbbill/undotree" )
	use ( "tpope/vim-fugitive" )
   use { "akinsho/toggleterm.nvim", tag="*", config = function() 
      require("toggleterm").setup{
         direction = "float",
         shell = vim.o.shell,
         persist_mode = true,
         auto_scroll = true,
         float_opts = {
            boarder = "curved",
            title_pos = "left",
         },
         
      }
   end}
end )
