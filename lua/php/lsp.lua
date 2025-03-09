require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "intelephense" }
})

local lspconfig = require("lspconfig")

lspconfig.intelephense.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        intelephense = {
            stubs = {
                "bcmath", "bz2", "calendar", "Core", "curl", "date", "dom", "fileinfo",
                "filter", "gd", "gettext", "hash", "iconv", "imap", "intl", "json", "ldap",
                "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password", "pcntl",
                "pcre", "PDO", "pdo_mysql", "Phar", "readline", "recode", "Reflection",
                "regex", "session", "SimpleXML", "soap", "sockets", "sodium", "SPL",
                "standard", "superglobals", "tokenizer", "xml", "xdebug", "xmlreader",
                "xmlwriter", "yaml", "zip", "zlib", "wordpress", "phpunit"
            },
            files = {
                maxSize = 5000000;
            },
        },
    },
})

vim.notify("Intelephense is now running", "info", { title = "LSP" })
