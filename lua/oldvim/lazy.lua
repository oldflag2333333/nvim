-- Setup lazy vim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local exists, plugins = pcall(require, 'oldvim.plugins')
if not exists then
  print 'Plugins config error!'
  return
end

-- lazy vim settings
local opts = {
  -- local plugins location
  dev = { path = '~/.local/share/nvim/nix' },
}

local lazy = require 'lazy'
local util = require 'oldvim.util'
util.lazy = lazy

lazy.setup(plugins, opts)
