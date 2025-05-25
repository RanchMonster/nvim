local util = require("lspconfig/util")
return {
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
               library = {
                  { path = "${3rd}/luv/library", words = { "vim%.uv" } },
               },
            },
         },
         {
            "saghen/blink.cmp",
         },
      },
      opts = {
         servers = {
            lua_ls = {
               cmd = { "lua-language-server" },
               root_makers = { ".luarc.json", ".luarc.jsonc", ".git" },
               settings = {
                  Lua = {
                     runtime = {
                        version = "LuaJIT",
                     },
                     diagnostics = {
                        globals = { "vim" },
                     }
                  }
               }
            },
            pyright = {
               on_attach = function(_, config)
                  local python_path = nil
                  local handle = io.popen("poetry env info -p 2>/dev/null")
                  if handle then
                     local result = handle:read("*a")
                     handle:close()
                     if result then
                        python_path = vim.fn.trim(result) .. "/bin/python"
                     end
                  end
                  if python_path then
                     config.settings = config.settings or {}
                     config.settings.python = config.settings.python or {}
                     config.settings.python.pythonPath = python_path
                     print("Using Poetry venv for Pyright:", python_path)
                  else
                     print("Warning: Could not find Poetry venv!")
                  end
               end,
               ---@diagnostic disable-next-line: deprecated
               root_dir = util.find_git_ancestor or util.path.dirname,
            },
            rust_analyzer = {
               cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
               settings = {
                  ["rust_analyzer"] = {
                     check = {
                        command = "clippy",
                     },
                     imports = {
                        granularity = {
                           group = "module",
                        },
                        prefix = "self",
                     },
                     cargo = {
                        allFeatures = true,
                        buildScripts = {
                           enable = true,
                        },
                     },
                     procMacro = {
                        enable = true,
                     },
                     inlayHints = {
                        enable = true,
                        typeHints = {
                           enable = true,
                        },
                     },
                     parameterHints = {
                        enable = true,
                     },
                  },
               },
               ---@diagnostic disable-next-line: unused-local
               on_attach = function(client, bufnr)
                  vim.lsp.inlay_hint(bufnr, true)
                  vim.lsp.inlay_hint.enable(true)
               end
            }
         }
      },
      config = function(_, opts)
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
         require("lspconfig").pyright.setup {}
         require("lspconfig").rust_analyzer.setup {}

         -- Lsp Key Maps
         local l = vim.lsp.buf
         Key("n", "<leader>gh", l.hover, "( Lsp ) Show Hover")
         Key("n", "<leader>gd", l.definition, "( Lsp ) Go to Definition")
         Key("n", "<leader>fr", l.references, "( Lsp ) Find Refrences")
         Key("n", "<leader>qe", function()
            vim.diagnostic.setqflist()
            vim.cmd("cope")
         end, "( Lsp ) Puts all of the error into a quickfix list.")

         -- Auto formatting on write with lsp
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

         local lspconfig = require("lspconfig")

         -- Configing lsps to use blink
         for server, config in pairs(opts.servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            vim.lsp.enable(server, true)
            vim.diagnostic.enable(true)
            -- lspconfig[server].setup(config)
         end
      end
   },
}
