-- Isolated paths inside vim.fn.stdpath("data")
local data_dir = vim.fn.stdpath("data") .. "/plantuml-lsp"
local bin_path = data_dir .. "/bin/plantuml-lsp"
local storage_dir = data_dir .. "/storage"

return {
   -- 1. Syntax highlighting & proper filetype association
   {
      'aklt/plantuml-syntax',
      ft = { 'plantuml', 'puml' },
      init = function()
         vim.g.plantuml_set_makeprg = 0
      end
   },

   -- 2. Automated LSP build, installation, and routing pipeline
   {
      'ptdewey/plantuml-lsp',
      ft = { 'plantuml', 'puml' },
      -- Build hook compiles the binary locally inside stdpath("data") instead of globally
      build = function()
         -- Ensure target directory tree exists
         vim.fn.mkdir(data_dir .. "/bin", "p")
         vim.fn.mkdir(storage_dir, "p")

         print("Compiling plantuml-lsp locally...")
         local cmd = string.format(
            "GOBIN=%s/bin go install github.com/ptdewey/plantuml-lsp@latest",
            data_dir
         )

         local output = vim.fn.system(cmd)
         if vim.v.shell_error ~= 0 then
            vim.notify("Failed to compile plantuml-lsp:\n" .. output, vim.log.levels.ERROR)
         else
            vim.notify("plantuml-lsp compiled successfully!", vim.log.levels.INFO)
         end
      end,

      config = function()
         local lspconfig = require("lspconfig")
         local configs = require("lspconfig.configs")

         -- Register the custom language server configuration if missing
         if not configs.plantuml_lsp then
            configs.plantuml_lsp = {
               default_config = {
                  -- Point directly to the isolated binary compiled via the build hook
                  cmd = {
                     bin_path,
                     -- Pass custom arguments to redirect long-term server data if supported
                     -- "--data-dir=" .. storage_dir
                  },
                  filetypes = { "plantuml" },
                  root_dir = function(fname)
                     return lspconfig.util.root_pattern(".git")(fname) or lspconfig.util.path.dirname(fname)
                  end,
                  settings = {},
               },
            }
         end

         -- Spawn the localized server instance
         lspconfig.plantuml_lsp.setup({
            -- Pass system environment updates to make sure child runtimes align
            cmd_env = {
               XDG_DATA_HOME = storage_dir,
               XDG_CACHE_HOME = storage_dir .. "/cache",
            }
         })
      end
   }
}
