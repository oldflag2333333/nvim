-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local map = require('oldvim.util').bind

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })

map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize window using <ctrl> arrow keys
map({ 'n', 't' }, '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map({ 'n', 't' }, '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map({ 'n', 't' }, '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map({ 'n', 't' }, '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

map('n', '<leader>e', '<cmd>Explore<cr>', { desc = 'Toggole Explore' })

-- stylua: ignore
map('n', '<leader>bd', function() require('mini.bufremove').delete() end, { desc = 'Delete buffer' })
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- stylua: ignore
-- map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
-- map('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
-- map('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
-- map('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
-- map('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
