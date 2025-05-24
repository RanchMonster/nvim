return {
   {
      "saghen/blink.cmp",
      dependencies = "rafamadriz/friendly-snippets",
      version = "v0.*",
      opts = {
         keymap = { preset = "default" },
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
