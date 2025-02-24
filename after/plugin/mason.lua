function setup()
   -- Mason Configuration
   require("mason").setup({
       -- You can add your own configuration here
       -- Check the configuration options: https://github.com/williamboman/mason.nvim#configuration
       ui = {
           icons = {
               package_installed = "✓",
               package_pending = "➜",
               package_uninstalled = "✗"
           }
       }
   })

end
pcall( setup )
