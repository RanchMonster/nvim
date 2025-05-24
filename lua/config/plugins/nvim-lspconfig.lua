return { {
   "neovim/nvim-lspconfig",
   dependencies = { {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
         library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
         },
      },
   } },
   config = function()
      -- For inline error messages
      vim.diagnostic.config({
         virtual_text = true, -- show inline text
         signs = true,        -- show signs in gutter
         underline = true,    -- underline errors
         update_in_insert = false,
         severity_sort = true,
      })

      -- Init Lsps --
      require("lspconfig").lua_ls.setup {}
      require("lspconfig").basedpyright.setup {}
      require("lspconfig").rust_analyzer.setup {}

      -- Lsp Key Maps
      l = vim.lsp.buf
      Key("n", "<leader>gh", l.hover, "( Lsp ) Show Hover")
      Key("n", "<leader>gd", l.definition, "( Lsp ) Go to Definition")
      Key("n", "<leader>fr", l.references, "( Lsp ) Find Refrences")

      vim.api.nvim_create_autocmd("LspAttach", {
         callback = function(args)
            -- Get the current lsp client
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end
            -- Checking if there is an lsp for the language
            -- The next line was made using "gra"
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            if client.supports_method("textDocument/formatting") then
               vim.api.nvim_create_autocmd("BufWritePre", { -- Autocmd: When atempting to write stack( this, write )
                  buffer = args.buf,                        -- args.buf: source of current buffer
                  callback = function()
                     -- Formats the current buffer, using the current lsp
                     vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                  end
               })
            end
         end,
      })
   end,
} }
