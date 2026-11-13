return {
   {
      "maxpaulus43/llama-cmp.nvim",
      config = function()
         require("llama-cmp").setup({
            model = "qwen2.5-coder:7b",
            preset = "qwen",
            endpoint = vim.env.OLLAMA_HOST or "http://localhost:11434",
            timeout = nil,
            keymaps = {
               accept = "<C-k>",
               dismiss = "<C-l>",
               trigger = "<C-j>",
            },
         })
      end
   },
}
