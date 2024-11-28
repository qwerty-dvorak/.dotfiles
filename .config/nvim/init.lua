
-- init.lua

-- Basic Neovim configuration

-- Bootstrap packer if it's not already installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand to reload Neovim whenever you save this init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]

-- Packer configuration
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Mason plugin
  use {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
          }
        }
      })
    end
  }

  -- Mason LSPConfig bridge
  use {
    'williamboman/mason-lspconfig.nvim',
    after = 'mason.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd', 'lua_ls', 'gopls', 'verible_ls' },
        automatic_installation = true
      })
    end
  }

  -- LSP Config
  use {
    'neovim/nvim-lspconfig',
    after = 'mason-lspconfig.nvim',
    config = function()
      local lspconfig = require('lspconfig')

      -- Clangd setup
      lspconfig.clangd.setup{}

      -- Lua Language Server setup
      lspconfig.lua_ls.setup{}

      -- Go Language Server setup
      lspconfig.gopls.setup{}

      -- Verilog Language Server setup
      lspconfig.verible_ls.setup{}
    end
  }

  -- Treesitter for syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'lua', 'javascript', 'html', 'css' }, -- Add languages as needed
        highlight = { enable = true },
      }
    end
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip' -- Snippet engine
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-e>'] = cmp.mapping.close(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' }
        })
      }
    end
  }

  -- File explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      require('nvim-tree').setup()
    end
  }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox'
        }
      }
    end
  }
end)

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

-- System settings
vim.opt.backup = false
vim.opt.swapfile = true
vim.opt.updatetime = 50

-- Mouse support
vim.opt.mouse = 'a'

-- Clipboard
vim.opt.clipboard = 'unnamedplus'
