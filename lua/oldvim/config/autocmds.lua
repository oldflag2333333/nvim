local util = require 'oldvim.util'
local augroup = util.augroup
local autocmd = util.autocmd

autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = augroup 'highlight_yank',
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd({ 'VimResized' }, {
  desc = 'resize splits if window got resized',
  group = augroup 'resize_splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  desc = 'Check if we need to reload the file when it changed',
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

autocmd('FileType', {
  desc = 'Wrap and check for spell in text filetypes',
  group = augroup 'wrap_spell',
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd({ 'FileType' }, {
  desc = 'Fix conceallevel for json files',
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

autocmd({ 'BufWritePre' }, {
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+://' then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

autocmd('FileType', {
  desc = 'Close some filetypes with <q>',
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
    'oil',
    'netrw',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})
