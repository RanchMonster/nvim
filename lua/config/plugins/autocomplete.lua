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
      },
      sourcess = {
         default = { "lsp", "path", "snippets", "buffer" },
      },
   }
}
