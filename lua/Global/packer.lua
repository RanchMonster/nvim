vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- LSP & Autocomplete
	use 'neovim/nvim-lspconfig'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/vim-vsnip'
	use 'stevanmilic/nvim-lspimport'

	-- Additional Plugins
	use "github/copilot.vim"
	use "tpope/vim-surround"
	use { "folke/lazydev.nvim", ft = "lua" }
	use { "nvim-lualine/lualine.nvim", requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
	use "ThePrimeagen/vim-be-good"
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.8', requires = { 'nvim-lua/plenary.nvim' } }
	use "theprimeagen/harpoon"
	use "mbbill/undotree"
	use "tpope/vim-fugitive"

	-- Treesitter
	use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/playground"
	use {
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" }
		}
	}


	-- Themes
	use { "Mofiqul/vscode.nvim", config = function() vim.cmd("colorscheme vscode") end }
	use "xiyaowong/transparent.nvim"
	use { "rose-pine/neovim", as = "rose-pine" }
	use { "lukas-reineke/virt-column.nvim", opts = { char = "a", virtcolumn = "10", hilight = { "NonText" } } }

	-- Mason & Auto LSP Setup
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/vim-vsnip' -- I added this as it is needed for most lsp autocomplete which is something I think we both *should* use
	use "Mofiqul/vscode.nvim"
	use "github/copilot.vim"
	use "tpope/vim-surround"
	use { "folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{
					path = "${3rd}/luv/library",
					words = { "vim%.uv" }
				},
			},
		},
	}
	use 'stevanmilic/nvim-lspimport'
	use { "neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").get_lsp_capabilities()
			require("lspconfig").basedpyright.setup { capabilities = capabilities }
			require("lspconfig").lua_ls.setup { capabilities = capabilities }
			require("lspconfig").rust_analyzer.setup { capabilities = capabilities }
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local c = vim.lsp.get_client_by_id(args.data.client_id)
					if not c then return end
					if c.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
							end,
						})
					end
				end,
			})
		end,
	}
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use 'wbthomason/packer.nvim'
	use {
		"williamboman/mason.nvim",
		run = ":MasonUpdate",
	}
end)
