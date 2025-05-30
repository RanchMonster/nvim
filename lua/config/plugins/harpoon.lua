UiOpen = false
return {
   {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local harpoon = require("harpoon")
         harpoon:setup()
         vim.api.nvim_create_augroup("harpoon2", { clear = true })
         Key("n", "<leader>a", function() harpoon:list():add() end, "Adds an entry to the harpoon list.")
         Key("n", "<C-e>", function()
            if UiOpen then
               vim.cmd("w")
               UiOpen = false
            else
               UiOpen = true
            end
            harpoon.ui:toggle_quick_menu(harpoon:list())
         end, "Toggles the harpoon menu popup.")
         Key("n", "<C-h>", function() harpoon:list():select(1) end, "Adds an entry to the harpoon list")
         Key("n", "<C-t>", function() harpoon:list():select(2) end, "Adds an entry to the harpoon list")
         Key("n", "<C-n>", function() harpoon:list():select(3) end, "Adds an entry to the harpoon list")
         Key("n", "<C-s>", function() harpoon:list():select(4) end, "Adds an entry to the harpoon list")
      end
   },
}
