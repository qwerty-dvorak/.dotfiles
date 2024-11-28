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
local package_path_str = "/home/afish/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?.lua;/home/afish/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?/init.lua;/home/afish/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?.lua;/home/afish/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/afish/.cache/nvim/packer_hererocks/2.1.1727870382/lib/lua/5.1/?.so"
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
  LuaSnip = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nf\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\1\foptions\0\1\0\1\ntheme\fgruvbox\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    after = { "nvim-lspconfig" },
    config = { "\27LJ\2\nü\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21ensure_installed\1\0\2\21ensure_installed\0\27automatic_installation\2\1\4\0\0\vclangd\vlua_ls\ngopls\nsetup\20mason-lspconfig\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/afish/.local/share/nvim/site/pack/packer/opt/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    config = { "\27LJ\2\n¶\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\aui\1\0\1\aui\0\nicons\1\0\1\nicons\0\1\0\3\22package_installed\b‚úì\24package_uninstalled\b‚úó\20package_pending\b‚ûú\nsetup\nmason\frequire\0" },
    loaded = true,
    only_config = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequire¨\3\1\0\b\0\24\0)6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0003\5\3\0=\5\5\4=\4\a\0035\4\n\0009\5\b\0009\5\t\5B\5\1\2=\5\v\0049\5\b\0009\5\f\5B\5\1\2=\5\r\0049\5\b\0009\5\14\0055\a\15\0B\5\2\2=\5\16\0049\5\b\0009\5\17\5B\5\1\2=\5\18\4=\4\b\0039\4\19\0009\4\20\0044\6\4\0005\a\21\0>\a\1\0065\a\22\0>\a\2\0065\a\23\0>\a\3\6B\4\2\2=\4\20\3B\1\2\1K\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\fsources\vconfig\n<C-e>\nclose\n<C-y>\1\0\1\vselect\2\fconfirm\n<C-p>\21select_prev_item\n<C-n>\1\0\4\n<C-p>\0\n<C-y>\0\n<C-n>\0\n<C-e>\0\21select_next_item\fmapping\fsnippet\1\0\3\fsources\0\fsnippet\0\fmapping\0\vexpand\1\0\1\vexpand\0\0\nsetup\bcmp\frequire\0" },
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\ns\0\0\4\0\6\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0014\3\0\0B\1\2\0019\1\4\0009\1\3\0014\3\0\0B\1\2\0019\1\5\0009\1\3\0014\3\0\0B\1\2\1K\0\1\0\ngopls\vlua_ls\nsetup\vclangd\14lspconfig\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/afish/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14nvim-tree\frequire\0" },
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nª\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\14highlight\1\0\1\venable\2\21ensure_installed\1\0\2\21ensure_installed\0\14highlight\0\1\5\0\0\blua\15javascript\thtml\bcss\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/afish/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\nf\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\foptions\1\0\1\foptions\0\1\0\1\ntheme\fgruvbox\nsetup\flualine\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nª\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\14highlight\1\0\1\venable\2\21ensure_installed\1\0\2\21ensure_installed\0\14highlight\0\1\5\0\0\blua\15javascript\thtml\bcss\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n¶\1\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\aui\1\0\1\aui\0\nicons\1\0\1\nicons\0\1\0\3\22package_installed\b‚úì\24package_uninstalled\b‚úó\20package_pending\b‚ûú\nsetup\nmason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\nC\0\1\4\0\4\0\a6\1\0\0'\3\1\0B\1\2\0029\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\15lsp_expand\fluasnip\frequire¨\3\1\0\b\0\24\0)6\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0003\5\3\0=\5\5\4=\4\a\0035\4\n\0009\5\b\0009\5\t\5B\5\1\2=\5\v\0049\5\b\0009\5\f\5B\5\1\2=\5\r\0049\5\b\0009\5\14\0055\a\15\0B\5\2\2=\5\16\0049\5\b\0009\5\17\5B\5\1\2=\5\18\4=\4\b\0039\4\19\0009\4\20\0044\6\4\0005\a\21\0>\a\1\0065\a\22\0>\a\2\0065\a\23\0>\a\3\6B\4\2\2=\4\20\3B\1\2\1K\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\rnvim_lsp\fsources\vconfig\n<C-e>\nclose\n<C-y>\1\0\1\vselect\2\fconfirm\n<C-p>\21select_prev_item\n<C-n>\1\0\4\n<C-p>\0\n<C-y>\0\n<C-n>\0\n<C-e>\0\21select_next_item\fmapping\fsnippet\1\0\3\fsources\0\fsnippet\0\fmapping\0\vexpand\1\0\1\vexpand\0\0\nsetup\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd mason-lspconfig.nvim ]]

-- Config for: mason-lspconfig.nvim
try_loadstring("\27LJ\2\nü\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\21ensure_installed\1\0\2\21ensure_installed\0\27automatic_installation\2\1\4\0\0\vclangd\vlua_ls\ngopls\nsetup\20mason-lspconfig\frequire\0", "config", "mason-lspconfig.nvim")

vim.cmd [[ packadd nvim-lspconfig ]]

-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\ns\0\0\4\0\6\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0009\1\3\0014\3\0\0B\1\2\0019\1\4\0009\1\3\0014\3\0\0B\1\2\0019\1\5\0009\1\3\0014\3\0\0B\1\2\1K\0\1\0\ngopls\vlua_ls\nsetup\vclangd\14lspconfig\frequire\0", "config", "nvim-lspconfig")

time([[Sequenced loading]], false)

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
