local config_path = vim.fn.stdpath("config") .. "/settings.json"

-- Function to get or set a setting
function Setting(key, value)
   -- If a value is provided, set it
   if value ~= nil then
      _G.settings[key] = value
   end

   -- Return the setting value
   return _G.settings[key]
end

local function save_settings()
   local file = io.open(config_path, "w")
   if file then
      file:write(vim.fn.json_encode(_G.settings))
      file:close()
      print("Saved Settings")
   end
end
local function load_settings()
   local file = io.open(config_path, "r")
   if file then
      local content = file:read("*a")
      file:close()
      _G.settings = vim.fn.json_decode(content)
      print("Load Settings")
   else
      _G.settings = {}
   end
end
load_settings()
vim.api.nvim_create_user_command("SaveSettings", save_settings, {})
vim.api.nvim_create_user_command("LoadSettings", load_settings, {})
-- Create a custom group to avoid overwriting existing callbacks
local group = vim.api.nvim_create_augroup("MyExitGroup", { clear = false })

vim.api.nvim_create_autocmd("VimLeave", {
   group = group, -- Use the custom group
   callback = function()
      -- Your cleanup code here
      save_settings()
   end,
})

-- Make the Setting function globally accessible
vim.g.Setting = Setting
