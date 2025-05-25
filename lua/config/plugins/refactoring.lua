return {
   {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-treesitter/nvim-treesitter",
      },
      lazy = false,
      opts = {},
      config = function()
         require('refactoring').setup({
            prompt_func_return_type = {
               go = false,
               java = false,

               cpp = false,
               c = false,
               h = false,
               hpp = false,
               cxx = false,
            },
            prompt_func_param_type = {
               go = false,
               java = false,

               cpp = false,
               c = false,
               h = false,
               hpp = false,
               cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = false, -- shows a message with information about the refactor on success

         })

         Key("nvx", "<leader>re", ":Refactor extract", "( Refactor ) Extract")                             -- Extracts highlighted text to new function
         Key("nvx", "<leader>rf", ":Refactor extract_to_file", "( Refactor ) Extract to File")             -- Extracts to a new function in a new file
         Key("nvx", "<leader>rv", ":Refactor extract_var", "( Refactor ) Extract Var")                     -- Extracts expression to variable
         Key("nvx", "<leader>ri", ":Refactor inline_var", "( Refactor ) Inline Var")                       -- Replaces all use of a variable with its definition
         Key("nvx", "<leader>rI", ":Refactor inline_func", "( Refactor ) Inline Func")                     -- Replaces all uses of a function with its definiton
         Key("nvx", "<leader>rb", ":Refactor extract_block", "( Refactor ) Extract Block")                 -- No clue yet
         Key("nvx", "<leader>rB", ":Refactor extract_block_to_file", "( Refactor ) Extract Block to File") -- No clue yet
      end

   },
}
