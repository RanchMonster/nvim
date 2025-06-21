return {
   {
      "saghen/blink.cmp",
      dependencies = "rafamadriz/friendly-snippets",
      version = "v0.*",
      opts = {
         keymap = {
            preset = "default",
            ["<C-space>"] = { "accept" },
         },
         appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "normal",
         },
         completion = {
            documentation = { auto_show = true, window = { border = 'rounded' } },
            menu = { border = 'rounded' },
         }
      },
      sourcess = {
         default = { "lsp", "path", "snippets", "buffer" },
      },
   }
}
