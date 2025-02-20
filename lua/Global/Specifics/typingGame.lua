local function startGame()
   -- Make a simple typing game the creates a nameless buffer full of a basic python script and you must type it out
   -- The game will keep track of how many characters you have typed and how many you have left
   -- The game will be in lua
   -- game will end when you have typed all the characters
end

vim.api.nvim_create_user_command("Game", function()
   startGame()
end, { bang = false })
