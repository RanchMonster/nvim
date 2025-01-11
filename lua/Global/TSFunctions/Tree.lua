function find_node_ancestor( types, node )
   if not node then
      return nil
   end
   if vim.tbl_contains(types, node:type()) then 
      return node
   end
   local parent = node:parent()
   return find_node_ancestor( types, parent )
end

function nc( types, node )
   if not node then
      return nil
   end
   for nodeChild in node:iter_children() do

      if vim.tbl_contains( types, nodeChild:type() ) then
         return nodeChild
      end
   end
end

function find_node_child( types, node, depth, break_if )

   break_if  =  break_if  or  {}

   local retNodes = {}

   if not node then
      return nil
   end

   for childNode in node:iter_children() do
      if vim.tbl_contains( types, childNode:type() ) then
         table.insert( retNodes, childNode )
      end
      if not vim.tbl_contains( break_if, childNode:type() ) then
         if depth ~= 0 then
            if childNode:child_count() ~= 0 then 
               for _, childsNode in pairs(find_node_child( types, childNode, ( depth -1 ), break_if )) do
                  table.insert( retNodes, childsNode )

               end
            end
         end
      end
   end
   
   return retNodes

end

function find_var_type( node ) 

   if not node then
      return
   end
   
   local var_name = vim.treesitter.get_node_text( node, 0 )
   if not var_name then
      return
   end
   local root_node = node:tree():root()
   local buffer_node = node
   local function_node = find_node_ancestor( { "function_definition" }, node )
   if not function_node then
      return
   end
   local arguments = nc( { "parameters" }, function_node )
   if not arguments then
      return
   end
   for node_ in arguments:iter_children() do
      if node_:type() == "identifier" then
         if not node_ then
            return
         end
         if vim.treesitter.get_node_text( node_, 0 ) == var_name then
			   return "Any"
         end
      end
      if node_:type() == "typed_parameter" then
         identifier_node = nc( { "identifier" }, node_ )   
         if not identifier_node then
            return "Any"
         end
         if vim.treesitter.get_node_text( identifier_node, 0 ) == var_name then
         
            local type = nc( { "type" }, node_ )
            if not type then
               return "Any"
            end
            return vim.treesitter.get_node_text( type, 0 )
         end
      end
	end

   local assignments = find_node_child( { "assignment" }, root_node, 20 )
   for _, node_ in pairs( assignments ) do
      
      local identifier_node = nc( { "identifier" }, node_ )
      
      if not identifier_node then
         return
      end

      local local_name = vim.treesitter.get_node_text( identifier_node, 0 )

      if var_name == local_name then

         local type = nc( { "type" }, node_ )
         if not type then
            return "Any"
         end
         return vim.treesitter.get_node_text( type, 0 )

      end
   end
end
