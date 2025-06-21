return {
   "3rd/image.nvim",
   dependencies = { "nvim-lua/plenary.nvim" },
   config = function()
      vim.api.nvim_create_user_command("ViewImage", function()
         require("image").setup {
            backend = "kitty", -- or "ueberzug" or "wezterm"
         }
      end
      , {})
   end
}
