local cmp = require('cmp')

cmp.setup({
   snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
         vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
         -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
         -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

         -- For `mini.snippets` users:
         -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
         -- insert({ body = args.body }) -- Insert at cursor
         -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
         -- require("cmp.config").set_onetime({ sources = {} })
      end,
   },
   window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
   },
   mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
   }),
   sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
   }, {
      { name = 'buffer' },
   })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
)
equire("cmp_git").setup() ]] --

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
      { name = 'path' }
   }, {
      { name = 'cmdline' }
   }),
   matching = { disallow_symbol_nonprefix_matching = false }
})

-- require('lspconfig')['basedpyright'].setup {
--   capabilities = capabilities
-- }
-- require('lspconfig')['lua_ls'].setup {
--   capabilities = capabilities
-- }
-- require('lspconfig')['phpactor'].setup {
--    capabilities = capabilities
-- }
require("mason").setup()
require("mason-lspconfig").setup {
   automatic_installation = true,
}

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Custom error handling with vim.notify
local function notify_error(message)
   vim.notify(message, vim.log.levels.ERROR)
end

local function notify_info(message)
   vim.notify(message, vim.log.levels.INFO)
end

require("mason-lspconfig").setup_handlers {
   function(server_name) -- Auto-setup all installed LSPs
      -- Use pcall to safely attempt to load each LSP server
      if "rust_analyzer" == server_name then
         return
      end
      local status, err = pcall(function()
         lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
               if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_create_autocmd("BufWritePre", {
                     buffer = bufnr,
                     callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                     end,
                  })
               end
            end,
         }
      end)

      if status then
         --debug only thing
         -- notify_info("Successfully loaded LSP: " .. server_name)
      else
         notify_error("Failed to load LSP " .. server_name .. ": " .. tostring(err))
      end
   end,
}
-- Config rust lsp over here for full features
lspconfig.rust_analyzer.setup {
   capabilities = capabilities,
   settings = {
      ["rust-analyzer"] = {
         check = {
            command = "clippy", -- Use Clippy for better linting
         },
         cargo = {
            allFeatures = true, -- Enable all features in Cargo.toml
         },
         procMacro = {
            enable = true, -- Enable procedural macros
         },
         inlayHints = {
            enable = true,    -- Enable inlay hints
            typeHints = {
               enable = true, -- Show inferred types
            },
            parameterHints = {
               enable = true, -- Show parameter hints in function calls
            },
         },
      },
   },
   on_attach = function(client, bufnr)
      -- Enable inlay hints if the Neovim version supports it
      if client.server_capabilities.inlayHintProvider then
         vim.lsp.inlay_hint.enable(true)
      end

      -- Keybindings for LSP actions
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
   end,
}
