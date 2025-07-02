return {
   {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
         library = {
            "/home/Jacob/.config/lua-globals",
            -- See the configuration section for more details
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
         },
      },
   },
   {
      "saghen/blink.cmp",
      dependencies = {
         "rafamadriz/friendly-snippets",
         {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
               library = {
                  -- See the configuration section for more details
                  -- Load luvit types when the `vim.uv` word is found
                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
               },
            },
         }
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
            -- ghost_text = { enabled = true },
            menu = { border = 'rounded' },
            documentation = { auto_show = true, window = { border = 'rounded' } },
         },

         signature = { enabled = true, window = { border = "rounded", show_documentation = true, } },
         sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer", },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  -- make lazydev completions top priority (see `:h blink.cmp`)
               },
            },
         },
      }
   },
}
