local auto_save_enabled = vim.g.Setting("auto_save_enabled")
if auto_save_enabled == nil then
   vim.g.Setting("auto_save_enabled", true)
end
-- Create the AutoSaveGroup if it doesn't exist
local auto_save_group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true })
if auto_save_enabled then
   vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
      group = auto_save_group, -- Use the created group
      command = "silent! write"
   })
end
local function toggle_autosave()
   auto_save_enabled = vim.g.Setting("auto_save_enabled", not auto_save_enabled)
   if auto_save_enabled then
      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
         group = auto_save_group, -- Use the created group
         command = "silent! write"
      })
      print("AutoSave Enabled")
   else
      vim.api.nvim_clear_autocmds({ group = auto_save_group })
      print("AutoSave Disabled")
   end
end

vim.api.nvim_create_user_command("ToggleAutoSave", toggle_autosave, {})
