vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
   -- Packer can manage itself

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
         local capabilities = require("blink.cmp").get_lsp_capabilities()
         require("lspconfig").pyright.setup { capabilities = capabilities }
         require("lspconfig").lua_ls.setup { capabilities = capabilities }
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
   use({
      "rose-pine/neovim",
      as = "rose-pine",
   })
   use({
      "lukas-reineke/virt-column.nvim",
      opts =
      {
         char = "a",
         virtcolumn = "10",
         hilight = { "NonText" }
      }
   })
   use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
   use("nvim-treesitter/playground")
   use("theprimeagen/harpoon")
   use("mbbill/undotree")
   use("tpope/vim-fugitive")
   use { "saghen/blink.cmp",
      requires = "rafamadriz/friendly-snippets",
      version = "v0.*",
      opts = {
         sources = {
            default = { "lazydev", "lsp", "path", "snippits", "buffer" },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.intergrations.blink",
                  score_offsets = 100,
               }
            }
         },
         keymap = { present = "default" },
         apperance = {
            use_nvim_cmp_as_defualt = true,
         },
         signature = { enabled = true },
      },
      opts_extend = { "sources.defualt" },
   }
end)
