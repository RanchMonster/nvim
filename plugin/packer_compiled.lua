-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/Jacob/.cache/nvim/packer_hererocks/2.1.1734355927/share/lua/5.1/?.lua;/home/Jacob/.cache/nvim/packer_hererocks/2.1.1734355927/share/lua/5.1/?/init.lua;/home/Jacob/.cache/nvim/packer_hererocks/2.1.1734355927/lib/luarocks/rocks-5.1/?.lua;/home/Jacob/.cache/nvim/packer_hererocks/2.1.1734355927/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/Jacob/.cache/nvim/packer_hererocks/2.1.1734355927/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["blink.cmp"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/blink.cmp",
    url = "https://github.com/saghen/blink.cmp"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  harpoon = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["lazydev.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/opt/lazydev.nvim",
    url = "https://github.com/folke/lazydev.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\ni\0\0\4\2\a\0\r6\0\0\0009\0\1\0009\0\2\0009\0\3\0005\2\4\0-\3\0\0009\3\2\3=\3\5\2-\3\1\0009\3\6\3=\3\6\2B\0\2\1K\0\1\0\0À\1À\aid\nbufnr\1\0\2\aid\0\nbufnr\0\vformat\bbuf\blsp\bvim‘\2\1\1\a\0\15\0\0276\1\0\0009\1\1\0019\1\2\0019\3\3\0009\3\4\3B\1\2\2\14\0\1\0X\2\1€2\0\17€9\2\5\1'\4\6\0B\2\2\2\15\0\2\0X\3\n€6\2\0\0009\2\a\0029\2\b\2'\4\t\0005\5\v\0009\6\n\0=\6\f\0053\6\r\0=\6\14\5B\2\3\0012\0\0€K\0\1\0K\0\1\0\rcallback\0\vbuffer\1\0\2\rcallback\0\vbuffer\0\bbuf\16BufWritePre\24nvim_create_autocmd\bapi\28textDocument/formatting\20supports_method\14client_id\tdata\21get_client_by_id\blsp\bvim±\2\1\0\6\0\17\0\0306\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0026\1\0\0'\3\3\0B\1\2\0029\1\4\0019\1\5\0015\3\6\0=\0\a\3B\1\2\0016\1\0\0'\3\3\0B\1\2\0029\1\b\0019\1\5\0015\3\t\0=\0\a\3B\1\2\0016\1\n\0009\1\v\0019\1\f\1'\3\r\0005\4\15\0003\5\14\0=\5\16\4B\1\3\1K\0\1\0\rcallback\1\0\1\rcallback\0\0\14LspAttach\24nvim_create_autocmd\bapi\bvim\1\0\1\17capabilities\0\vlua_ls\17capabilities\1\0\1\17capabilities\0\nsetup\fpyright\14lspconfig\25get_lsp_capabilities\14blink.cmp\frequire\0" },
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-lspimport"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/nvim-lspimport",
    url = "https://github.com/stevanmilic/nvim-lspimport"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rose-pine"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/rose-pine",
    url = "https://github.com/rose-pine/neovim"
  },
  shadotheme = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\22colorscheme shado\bcmd\bvim\0" },
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/shadotheme",
    url = "https://github.com/Shadorain/shadotheme"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["transparent.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/transparent.nvim",
    url = "https://github.com/xiyaowong/transparent.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-be-good"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/vim-be-good",
    url = "https://github.com/ThePrimeagen/vim-be-good"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["virt-column.nvim"] = {
    loaded = true,
    path = "/home/Jacob/.local/share/nvim/site/pack/packer/start/virt-column.nvim",
    url = "https://github.com/lukas-reineke/virt-column.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\ni\0\0\4\2\a\0\r6\0\0\0009\0\1\0009\0\2\0009\0\3\0005\2\4\0-\3\0\0009\3\2\3=\3\5\2-\3\1\0009\3\6\3=\3\6\2B\0\2\1K\0\1\0\0À\1À\aid\nbufnr\1\0\2\aid\0\nbufnr\0\vformat\bbuf\blsp\bvim‘\2\1\1\a\0\15\0\0276\1\0\0009\1\1\0019\1\2\0019\3\3\0009\3\4\3B\1\2\2\14\0\1\0X\2\1€2\0\17€9\2\5\1'\4\6\0B\2\2\2\15\0\2\0X\3\n€6\2\0\0009\2\a\0029\2\b\2'\4\t\0005\5\v\0009\6\n\0=\6\f\0053\6\r\0=\6\14\5B\2\3\0012\0\0€K\0\1\0K\0\1\0\rcallback\0\vbuffer\1\0\2\rcallback\0\vbuffer\0\bbuf\16BufWritePre\24nvim_create_autocmd\bapi\28textDocument/formatting\20supports_method\14client_id\tdata\21get_client_by_id\blsp\bvim±\2\1\0\6\0\17\0\0306\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0026\1\0\0'\3\3\0B\1\2\0029\1\4\0019\1\5\0015\3\6\0=\0\a\3B\1\2\0016\1\0\0'\3\3\0B\1\2\0029\1\b\0019\1\5\0015\3\t\0=\0\a\3B\1\2\0016\1\n\0009\1\v\0019\1\f\1'\3\r\0005\4\15\0003\5\14\0=\5\16\4B\1\3\1K\0\1\0\rcallback\1\0\1\rcallback\0\0\14LspAttach\24nvim_create_autocmd\bapi\bvim\1\0\1\17capabilities\0\vlua_ls\17capabilities\1\0\1\17capabilities\0\nsetup\fpyright\14lspconfig\25get_lsp_capabilities\14blink.cmp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: shadotheme
time([[Config for shadotheme]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\22colorscheme shado\bcmd\bvim\0", "config", "shadotheme")
time([[Config for shadotheme]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType lua ++once lua require("packer.load")({'lazydev.nvim'}, { ft = "lua" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
