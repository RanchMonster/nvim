return {
   {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
         library = {
            -- Add these essential paths for proper Lua development
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "lazy.nvim",          words = { "lazy" } },
            -- Add your Neovim config path
            vim.fn.stdpath("config"),
            -- If you have custom Lua globals, add them here
            -- { path = "/home/Jacob/.config/lua-globals" },
         },
      },
   },
   {
      "saghen/blink.cmp",
      dependencies = {
         "rafamadriz/friendly-snippets",
         "folke/lazydev.nvim", -- Keep as dependency but remove duplicate config
      },
      version = "v0.*",
      opts = {
         keymap = {
            preset = "default",
            ["<C-space>"] = { "accept" },
            ["<C-k>"] = {},
         },
         appearance = {
            highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
         },
         completion = {
            ghost_text = { enabled = true },
            menu = { border = 'rounded' },
            documentation = { auto_show = true, window = { border = 'rounded' } },
         },
         signature = {
            enabled = true,
            window = {
               border = "rounded",
               show_documentation = true,
            }
         },
         sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  -- Priority will be handled automatically
               },
            },
         },
      },
      config = function(_, opts)
         local blink = require("blink.cmp")
         blink.setup(opts)

         -- Ensure lazydev is properly integrated
         require("lazydev").setup({
            library = {
               { path = "luvit-meta/library", words = { "vim%.uv" } },
               { path = "lazy.nvim",          words = { "lazy" } },
               vim.fn.stdpath("config"),
            },
         })
      end
   },
}
