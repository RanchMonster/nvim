return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- optional
    config = true
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        -- List of servers to automatically install
        ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "tsserver", "html", "cssls" },
        automatic_installation = true,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
    end,
  }
}
