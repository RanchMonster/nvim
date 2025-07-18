return {
   {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local harpoon = require("harpoon")
         local opts = {
            settings = {
               save_on_toggle = true,
               sync_on_ui_close = true
            }
         }
         harpoon:setup(opts)
         vim.api.nvim_create_augroup("harpoon2", { clear = true })
         Key("n", "<leader>a", function() harpoon:list():add() end, "Adds an entry to the harpoon list.")
         Key("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Toggles the harpoon menu popup.")
         Key("n", "<C-h>", function() harpoon:list():select(1) end, "Adds an entry to the harpoon list")
         Key("n", "<C-t>", function() harpoon:list():select(2) end, "Adds an entry to the harpoon list")
         Key("n", "<C-n>", function() harpoon:list():select(3) end, "Adds an entry to the harpoon list")
         Key("n", "<C-s>", function() harpoon:list():select(4) end, "Adds an entry to the harpoon list")
      end
   },
}
