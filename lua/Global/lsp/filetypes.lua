local autofiletype = vim.api.nvim_create_augroup( "autofiletype", { clear = true })
vim.api.nvim_create_autocmd( { "BufEnter" }, { 
	pattern = "*.slint",
	group = autofiletype,
	callback = function()
		print( "Setting filetype to slint" )
		vim.cmd( "set filetype=slint" )
	end
}
)
