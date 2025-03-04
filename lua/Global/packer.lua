vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
   -- Packer can manage itself

   use "nvim-tree/nvim-web-devicons" -- optional, for file icons
   use { "prichrd/netrw.nvim",
      config = function()
         require("netrw").setup({
           -- File icons to use when `use_devicons` is false or if
           -- no icon is found for the given file type.
           icons = {
             symlink = '',
             directory = '',
             file = '',
           },
           -- Uses mini.icon or nvim-web-devicons if true, otherwise use the file icon specified above
           use_devicons = true,
           mappings = { },
         })
      end
   }

   use {
      "ThePrimeagen/refactoring.nvim",
      requires = {
         { "nvim-lua/plenary.nvim" },
         { "nvim-treesitter/nvim-treesitter" }
      }
   }
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
   use({
      "Shadorain/shadotheme",
      config = function()
         vim.cmd("colorscheme shado")
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
      requires = { { 'nvim-lua/plenary.nvim' } }
   }
   use({ "xiyaowong/transparent.nvim",
   })
   use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
   use("nvim-treesitter/playground")
   use("theprimeagen/harpoon")
   use("mbbill/undotree")
   use("tpope/vim-fugitive")
end)
