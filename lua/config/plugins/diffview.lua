return {
      "sindrets/diffview.nvim",
      config = function()
         require("diffview").setup({
            enhanced_diff_hl = true,
            view = {
               default = {
                  layout = "diff2_horizontal",
                  winbar_info = true,
               },
               file_history = {
                  layout = "diff2_horizontal",
                  winbar_info = true,
               },
            },
         })
         vim.opt.fillchars:append { diff = " " }
      end

}
