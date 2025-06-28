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
            ts_ls = {
               cmd = { "typescript-language-server", "--stdio" },
               settings = {
                  typescript = {
                     inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                     },
                     preferences = {
                        importModuleSpecifierPreference = "relative",
                        includeCompletionsForModuleExports = true,
                        includeCompletionsWithInsertText = true,
                     },
                     suggest = {
                        includeCompletionsForImportStatements = true,
                     },
                  },
                  javascript = {
                     inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                     },
                     preferences = {
                        importModuleSpecifierPreference = "relative",
                     },
                     suggest = {
                        includeCompletionsForImportStatements = true,
                     },
                  },
               },
               init_options = {
                  hostInfo = "neovim",
               },
            },
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
            basedpyright = {
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
                     print("Using Poetry venv for basedpyright:", python_path)
                  else
                     print("Warning: Could not find Poetry venv!")
                  end
               end,
               ---@diagnostic disable-next-line: deprecated
               settings = {
                  basedpyright = {
                     analysis = {
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace", -- "openFilesOnly" for performance
                        typeCheckingMode = "strict",  -- options: "off", "basic", "strict"
                        stubPath = "typings",         -- optional: useful for custom type stubs

                        inlayHints = {
                           variableTypes = true,
                           functionReturnTypes = true,
                           parameterNames = true,
                        },
                     },
                  },
               },
            },
            intelephense = {
               cmd = { vim.fn.stdpath("data") .. "/mason/bin/intelephense", "--stdio" },
               filetypes = { "php" },
               root_dir = function(fname)
                  local util = require("lspconfig/util")
                  return util.root_pattern("composer.json", ".git")(fname)
                      or util.path.dirname(fname)
               end,
               settings = {
                  intelephense = {
                     environment = {
                        includePaths = { "vendor" }, -- or add custom stub dirs
                     },
                     diagnostics = {
                        enable = true,
                     },
                     completion = {
                        fullyQualifyGlobalConstantsAndFunctions = true,
                     },
                     files = {
                        maxSize = 5000000, -- in bytes
                     },
                     telemetry = {
                        enabled = false,
                     },
                  },
               },
            },
            rust_analyzer = {
               cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
               settings = {
                  ["rust_analyzer"] = {
                     check = {
                        command = "clippy",
                        features = "all",
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
                        variableTypes = true,
                        functionReturnTypes = true,
                        parameterNames = true,
                        bindingModeHints = {
                           enable = true,
                        },
                        implicitDrops = {
                           enable = true,
                        },
                        enable = true,
                        typeHints = {
                           enable = true,
                        },
                     },
                     parameterHints = {
                        enable = true,
                     },
                     completion = {
                        privateEditable = {
                           enable = true,
                        },
                     },
                     diagnostics = {
                        styleLints = {
                           enable = true,
                        },
                     }
                  },
               },
            },
            clangd = {
               cmd = { vim.fn.stdpath("data") .. "/mason/bin/clangd" }, -- or just "clangd" if in PATH
               filetypes = { "c", "cpp", "hpp", "h", "objc", "objcpp", "cuda", "proto" },
               root_dir = function(fname)
                  local util = require("lspconfig/util")
                  return util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
               end,
               capabilities = {},          -- Will be filled later in config loop
               init_options = {
                  clangdFileStatus = true, -- provides file status updates
                  usePlaceholders = true,
                  completeUnimported = true,
                  semanticHighlighting = true,
               },
               settings = {
                  clangd = {
                     fallbackFlags = {
                        "-std=c++20",
                        "-Wall",
                        "-Wextra",
                        "-Wpedantic",
                     },
                  },
               },
            }
         },
      },


      config = function(_, opts)
         vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_inbsert = false,
            severity_sort = true,
         })

         vim.api.nvim_create_augroup("nvim-lspconfig", { clear = true })
         -- Lsp Key Maps
         local l = vim.lsp.buf
         Key("n", "<leader>h", l.hover, "( Lsp ) Show Hover")
         Key("n", "<leader>gd", l.definition, "( Lsp ) Go to Definition")
         Key("n", "<leader>fr", l.references, "( Lsp ) Find Refrences")
         Key("n", "<leader>rn", l.rename, "( Lsp ) Rename")
         Key("n", "<leader>gD", l.declaration, "( Lsp ) Go to Declaration")
         Key("n", "<leader>ca", l.code_action, "( Lsp ) Code Action")
         Key("n", "<leader>q", function()
            vim.diagnostic.setqflist()
            vim.cmd("cope")
         end, "( Lsp ) Puts all errors into a quickfix list.")

         -- Format on save
         vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
               local client = vim.lsp.get_client_by_id(args.data.client_id)
               if not client then return end
               if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_create_autocmd("BufWritePre", {
                     buffer = args.buf,
                     callback = function()
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                     end
                  })
               end
            end,
         })
         vim.api.nvim_create_autocmd("BufEnter", {
            group = "nvim-lspconfig",
            callback = function()
               vim.lsp.inlay_hint.enable(true)
            end,
         })
         -- Final LSP setup
         local lspconfig = require("lspconfig")
         local util = require("lspconfig/util")
         opts.servers.basedpyright.root_dir = util.find_git_ancestor or util.path.dirname
         for server, config in pairs(opts.servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            vim.lsp.enable(server, true)
            vim.diagnostic.enable(true)
            -- lspconfig[server].setup(config)
         end
      end
   },
}
