return {
  -- Core layout dependency
  {
    "ldelossa/litee.nvim",
    config = function()
      require("litee.lib").setup()
    end
  },
  -- The main GitHub plugin
  {
    "ldelossa/gh.nvim",
    dependencies = { "ldelossa/litee.nvim" },
    config = function()
      require("litee.gh").setup()
    end
  }
}

