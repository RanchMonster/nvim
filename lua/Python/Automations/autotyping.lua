local function item_in_table( item, table )
   for _, item_ in pairs( table ) do
      if item == item_ then
         return true
      end
   end
   return false
end

local function combine_types( table_, sep )
   local sep = sep or " | "
   if item_in_table( "Any", table_ ) then
      return "Any"
   end
   return table.concat( table_, sep )
end

local function set_return_type( type, node )
   local start_row, start_col = node:start()
   local end_row, end_col = node:end_()
   vim.api.nvim_buf_set_text( vim.fn.bufnr(), start_row, start_col, end_row, end_col, { type } )
end

local function return_statement_type( node ) 

   if not node then
      return {}
   end

   local return_types = {}

   for type in node:iter_children() do 
      if type:type() == "integer" then
         if not item_in_table( "int", return_types ) then
            table.insert( return_types, 1, "int" )
         end
      end
      if type:type() == "true" or type:type() == "false" then
         if not item_in_table( "bool", return_types ) then
            table.insert( return_types, 1, "bool" )
         end
      end
      if type:type() == "none" then
         if not item_in_table( "None", return_types ) then
            table.insert( return_types, 1, "None" )
         end
      end
      if type:type() == "string" then
         if not item_in_table( "str", return_types ) then
            table.insert( return_types, 1, "str" )
         end
      end
      if type:type() == "list" then
         local temp = return_statement_type( type )
         local type_str = "list"
         if not ( #temp == 0 ) then
            local type_str = "list[ " .. combine_types( temp, ", " ) .. " ]"
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         else
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         end
      end
      if type:type() == "tuple" then
         local temp = return_statement_type( type )
         local type_str = "tuple"
         if not ( #temp == 0 ) then
            local type_str = "tuple[ " .. combine_types( temp, ", " ) .. " ]"
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         else
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         end
      end

      if type:type() == "dictionary" then
         local key_types = {}
         local value_types = {}
         for pair in type:iter_children() do
            local key_type = return_statement_type( pair:child( 1 )) 
            if key_type then
               for _, temp in pairs( key_type ) do
                  if not item_in_table( temp, key_types ) then 
                     table.insert( key_types, 1, temp )
                  end
               end
            end
            
            local value_type =  return_statement_type( pair:child( 2 ) ) 
            if not value_type then
               for _, temp in pairs( value_type ) do
                  if not item_in_table( temp, value_types ) then 
                     table.insert( value_types, 1, temp )
                  end
               end
            end
         end
         local temp_ = ""
         if #key_types > 0 or #value_types > 0 then
            if #key_types == 0 then
               temp_ = "dict[ Any, " .. combine_types( value_types ) .. " ]"
            elseif #value_types == 0 then
               temp_ = "dict[ " .. combine_types( key_types ) .. ", Any ]"
            else
               temp_ = "dict[ " .. combine_types( key_types ) .. ", " .. combine_types( value_types ) .. " ]"
            end
         else
            temp_ = "dict"
         end
         if not item_in_table( temp, return_types ) then
            table.insert( return_types, 1, temp_ )
         end

      end
      if type:type() == "set" then
         local temp = return_statement_type( type )
         local type_str = "set"
         if not ( #temp == 0 ) then
            local type_str = "set[ " .. combine_types( temp ) .. " ]"
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         else
            if not item_in_table( type_str, return_types ) then
               table.insert( return_types, 1, type_str )
            end
         end
      end
      if type:type() == "expression_list" then
         local temp = return_statement_type( type )
         for _, type_ in pairs( temp ) do
            if not item_in_table( type_, return_types ) then
               table.insert( return_types, 1, type_ )
            end
         end
      end
      if type:type() == "identifier" then
         local temp = find_var_type( type )
         for _, temp_ in pairs( temp ) do 
            if not item_in_table( temp_, return_types ) then
               table.insert( return_types, 1, temp_ )
            end
         end
      end
      if type:type() == "type" then
         local type_ = vim.treesitter.get_node_text( type, 0 )
         if not item_in_table( type_, return_types ) then
            table.insert( return_types, 1, type_ )
         end
      end
   end
   return return_types
end
function find_var_type( node ) 

   if not node then
      return {}
   end
   
   local var_name = vim.treesitter.get_node_text( node, 0 )
   if not var_name then
      return {}
   end
   local root_node = node:tree():root()
   local buffer_node = node
   local function_node = find_node_ancestor( { "function_definition" }, node )
   if not function_node then
      return {}
   end
   local arguments = nc( { "parameters" }, function_node )
   if not arguments then
      return {}
   end
   local total_types = {}
   for node_ in arguments:iter_children() do
      if node_:type() == "identifier" then
         if not node_ then
            print( 1 )
            return {}
         end
         if vim.treesitter.get_node_text( node_, 0 ) == var_name then
            print( 1 )
			   return { "Any" }
         end
      end
      if node_:type() == "typed_parameter" then
         identifier_node = nc( { "identifier" }, node_ )   
         if not identifier_node then
            print( 1 )
            return { "Any" }
         end
         if vim.treesitter.get_node_text( identifier_node, 0 ) == var_name then
         
            print( 1 )
            local type = nc( { "type" }, node_ )
            if not type then
               return { "Any" }
            end
            local union = nc( { "union_type" }, type )
            if not union then
               return { vim.treesitter.get_node_text( type, 0 ) }
            else
               return return_statement_type( union )
            end
         end
      end
	end

   local assignments = find_node_child( { "assignment" }, root_node, 200 )
   for _, node_ in pairs( assignments ) do
      
      local identifier_node = nc( { "identifier" }, node_ )
      
      if not identifier_node then
         print( 2 )
         return {}
      end

      local local_name = vim.treesitter.get_node_text( identifier_node, 0 )

      if var_name == local_name then

         local type = nc( { "type" }, node_ )
         if not type then
            return { "Any" } 
         end
         local union = nc( { "union_type" }, type )
         if not union then
            return { vim.treesitter.get_node_text( type, 0 ) }
         else
            return return_statement_type( union ) 
         end
      end
   end
end

function return_type() 
   local buffer = vim.fn.bufnr()
   local current_node = vim.treesitter.get_node { ignore_injections = false }
   if not current_node then
      print( "No current Node" )
      return
   end
   local function_node = find_node_ancestor( { "function_definition" }, current_node )
   if not function_node then
      print( "No function Node" )
      return
   end
   local function_identifier = nc(  {"identifier"}, function_node )
   if not function_identifier then
      print( "No function identifier" )
      return
   end
   local function_name = vim.treesitter.get_node_text( function_identifier, 0 )
   if not function_name then
      print( "No Function Name" )
      return
   end
   local return_type_ = nc( { "type" }, function_node )
   if not return_type_ then
      print( "No return type" )
      local parameters = nc( { "parameters" }, function_node )
      if not parameters then
         print( "No parameters" )
         return
      end
      local end_row, end_col = parameters:end_()
      vim.api.nvim_buf_set_text( buffer, end_row, end_col, end_row, end_col, { " -> None" } )
      local function_node = find_node_ancestor( { "function_definition" }, current_node )
      local return_type_ = nc( { "type" }, function_node )
      if not return_type_ then
         print( "No after return type" )
         return
      end
   end

   local return_types = {}
   local return_statements = find_node_child( { "return_statement" }, function_node, 100, { "function_definition" } )
   if not return_statements or ( #return_statements == 0 ) then
      set_return_type( "None", return_type_ )
      print( "No return statements" )
      return
   end

   for _, return_statement in pairs( return_statements ) do
      if return_statement:child_count() == 0 then
         table.insert( return_types, 1, "None" ) 
      else 

         local types = return_statement_type( return_statement )
         for _, type in pairs( types ) do
            if not item_in_table( type, return_types ) then
               table.insert( return_types, 1, type )  
            end
         end
         -- print( table.concat( types, " " ))
      end
   end
   if #return_types == 0 then
      set_return_type( "None", return_type_ )
      return
   end
   local final = combine_types( return_types )
   set_return_type( final, return_type_ )
end

