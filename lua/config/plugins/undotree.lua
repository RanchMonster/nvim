return {
   {
      "mbbill/undotree",
      opts = {},
      config = function()
         Key("n", "<leader>u", vim.cmd.UndotreeToggle, "Toggles the undotree")
      end
   }
}
