---@return string[] exclude_rules
local function exclude_rules()
   local default_exclude_rules = {
      "node_modules",
      ".git",
      "__pycache__",
      "venv",
      ".target",
   }
   ---@type string[]
   local rules = {}
   for _, rule in ipairs(default_exclude_rules) do
      table.insert(rules, "--exclude")
      table.insert(rules, rule)
   end
   ---@type string
   local other_exclude_rules_str = vim.env.TELESCOPE_EXCLUDE_RULES
   if other_exclude_rules_str == nil or other_exclude_rules_str == "" then
      return rules
   end
   -- attempt to parse TELESCOPE_EXCLUDE_RULES as a comma-separated list of rules
   local success, result = pcall(vim.split, other_exclude_rules_str, ",")
   if not success then
      vim.notify("Error parsing TELESCOPE_EXCLUDE_RULES: " .. result, vim.log.levels.ERROR)
      return default_exclude_rules
   end

   -- add the rules to the exclude_rules table
   for _, rule in ipairs(result) do
      table.insert(rules, "--exclude")
      table.insert(rules, rule)
   end
   return rules
end

return {
   "nvim-telescope/telescope.nvim",
   dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim",
      {
         "burntsushi/ripgrep",
         build = "cargo build --release",
         config = function(plugin)
            local rg_bin = vim.fs.joinpath(plugin.dir, "/target/release")
            vim.env.PATH = rg_bin .. ":" .. vim.env.PATH
         end,
      },
      {
         "sharkdp/fd",
         build = "cargo build --release",
         config = function(plugin)
            local fd_bin = vim.fs.joinpath(plugin.dir, "/target/release")
            vim.env.PATH = fd_bin .. ":" .. vim.env.PATH
         end,
      },
   },
   config = function()
      local find_command = { "fd", "--type", "f", "--hidden" }
      local rules = exclude_rules()
      vim.list_extend(find_command, rules)
      table.insert(find_command, "--strip-cwd-prefix")
      require("telescope").setup({
         pickers = {
            find_command = find_command,

         },
         defaults = {
            -- border = false, -- disables all borders
            hidden = true, -- hides the UI
         },
         extensions = {
            fzf = {},
         },
      })
      local builtin = require("telescope.builtin")
      ---@diagnostic disable-next-line: unused-local
      local telescope = require("telescope")
      -- Nav & Git
      require("telescope").load_extension("fzf")
      Key("n", "<leader>ff", function() builtin.find_files({ find_command = find_command }) end,
         "( Telescope ) Find Files")
      Key("n", "<leader>fh", builtin.help_tags, "( Telescope ) Find Help")
      Key("n", "<leader>Gf", builtin.git_files, "( Telescope ) Find Git Files")
      Key("n", "<leader>Gb", builtin.git_branches, "( Telescope ) Find Git Branches")
      local live_grep = require("config.Telescope.live_grep")
      Key("n", "<C-g>", live_grep.multigrep, "( Telescope ) Live Grep")
   end,
}
