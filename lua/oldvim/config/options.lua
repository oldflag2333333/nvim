-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- vim.g.autoformat = true
-- vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

local opt = vim.opt

-- [[ Setting options ]]
-- See `:help opt`
-- NOTE: For more options `:help option-list`

-- Make line numbers default
opt.number = true
-- You can also add relative line numbers, for help with jumping.
opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = 'a'

-- Confirm to save changes before exiting modified buffer
opt.confirm = true

-- Don't show the mode, since it's already in status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
opt.clipboard = 'unnamedplus'

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true
-- Use spaces instead of tabs
opt.expandtab = true

-- Round indent
opt.shiftround = true
-- Size of an indent
opt.shiftwidth = 2

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 4

-- Set highlight on search, but clear on pressing <Esc> in normal mode
opt.hlsearch = true

-- True color support
opt.termguicolors = true
