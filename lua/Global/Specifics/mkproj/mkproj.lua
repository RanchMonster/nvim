local extensions = {
   Python = { ".py" },
   Lua = { ".lua" },
   C = { ".c" },
   Cpp = { ".cpp" },
   Java = { ".java" },
   JavaScript = { ".js" },
   TypeScript = { ".ts" },
   HTML = { ".html" },
   CSS = { ".css" },
   Shell = { ".sh" },
   Go = { ".go" },
   Rust = { ".rs" },
   Haskell = { ".hs" },

}

local extras = {
   Python = {
      {
         files = {
            requirements = "requirements.txt",
            pyrightconfig = "pyrightconfig.json",
         },
         commands = {
            setup = {
               install = "pip install -r requirements.txt",
            },
            execute = {
               run = "~/Code/Python/venv/bin/python3 main.py",
            },
         },
      }
   },
   Lua = {
      {
         files = {},
         commands = {
            setup = {},
            execute = {
               run = "lua main.lua",
            },
         },
      }
   },
   Rust = {
      {
         files = {},
         commands = {
            setup = {
               build = "cargo build",
            },
            execute = {
               run = "cargo run",
            }
         },
      }
   },
}

-- local function mapFileTree()
--    cwd = vim.fn.getcwd()
--    cwdContent = vim.fn.systemlist("ls -a -R " .. cwd)
--    print( table.concat(cwdContent, "\n") )
--
-- end
--
-- vim.api.nvim_create_user_command(
--    "Testing",
--    function()
--       mapFileTree()
--    end,
--    {
--       bang = false,
--    }
-- )


local function count_tabs( string )
   local counter = 0

   while ( string[counter] == " " ) do
      counter = counter + 1
   end

   -- Tab is 3 spaces
   return counter/3
end


local function remove_tabs( str )
   local counter = 1

   if str == nil then
      return ""
   end
   -- Skip past the white space
   while ( str[counter] == " " ) do
      counter = counter + 1
   end

   return string.sub( str, counter, #str )
end 

local function parse_mkproj()

   local buffer = vim.api.nvim_get_current_buf()
   local lines = vim.api.nvim_buf_get_lines( buffer, 0, -1, false )
   local main_lang = lines[1]
   local other_langs = {}

   -- Remove the main lang
   table.remove( lines, 1 )

   -- Creates a counter to keep track of the current line
   local counter = 1

   -- Handles the languages for the project
   while ( lines[counter] ) do
      if ( lines[counter] ~= "" ) then
         table.insert( other_langs, lines[ counter ] )
      end
      counter = counter + 1
   end

   local file_tree = {}
   local dir_stack = {"./"}
   local last_indent = 0

   -- Handles the file tree
   while ( lines[counter] ~= "/" and counter <= #lines ) do
      -- Check that it's not an empty line
      if ( remove_tabs(lines[counter]) ~= "" ) then
         -- Check if the item is a directory
         if ( lines[counter][#lines[counter]] == "/") then
            if ( count_tabs( lines[counter] ) < last_indent ) then
               -- Back out based on indenting
               for _ = 1, last_indent - count_tabs( lines[counter] ) do
                  table.remove( dir_stack, #dir_stack )
               end
            end
            table.insert( dir_stack, lines[counter] )
            table.insert( file_tree, table.concat( dir_stack, "" ) )
         -- Otherwise it's a file
         else
            table.insert( file_tree, table.concat( dir_stack, "" ) .. lines[counter] )
         end
      end

      counter = counter + 1
   end

   return {
      main_lang = main_lang,
      other_langs = other_langs,
      file_tree = file_tree,
   }
end

parse_mkproj( "" )
remove_tabs()

local function mkproj()
   local main_lang, other_langs, file_tree = parse_mkproj( vim.api.nvim_get_current_buf() )
end

vim.api.nvim_create_user_command(
   "Mkproj",
   function()
      vim.cmd("e mkproj")
      vim.cmd("w")
   end,
   {
      bang = false,
   }
)

local autoCmdGroup = vim.api.nvim_create_augroup( "Mkproj", { clear = true })

vim.api.nvim_create_autocmd( { "BufWrite" }, 
   {
      callback = function()
         mkproj()
      end,
      pattern = "mkproj",
      group = autoCmdGroup,
   }
)
