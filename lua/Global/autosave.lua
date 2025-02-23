vim.g.auto_save_enabled = true

-- Create the AutoSaveGroup if it doesn't exist
local auto_save_group = vim.api.nvim_create_augroup("AutoSaveGroup", { clear = true })
if vim.g.auto_save_enabled then
   vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
   group = auto_save_group, -- Use the created group
   command = "silent! write"
   })
end
local function toggle_autosave()
    vim.g.auto_save_enabled = not vim.g.auto_save_enabled
    if vim.g.auto_save_enabled then
        vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
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

