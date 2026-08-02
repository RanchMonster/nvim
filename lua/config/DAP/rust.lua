local function get_cargo_bin()
   -- Build the project and output progress as JSON
   local cmd = "cargo build --message-format=json 2>/dev/null"
   local lines = vim.fn.systemlist(cmd)

   -- Iterate backwards through the lines to find the actual artifact
   for i = #lines, 1, -1 do
      local line = lines[i]
      if line:match('"executable"') then
         -- Decode the JSON line to retrieve the path string safely
         local ok, decoded = pcall(vim.json.decode, line)
         if ok and decoded and decoded.executable then
            return decoded.executable
         end
      end
   end

   -- Fallback to manual selection prompt if cargo fails or has no binary
   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
end

return {
   rust = {
      {
         name = "Run",
         type = "codelldb",
         request = "launch",
         program = get_cargo_bin,
      },
   }
}
