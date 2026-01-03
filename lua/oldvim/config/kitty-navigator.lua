-- Kitty + Neovim 无缝窗口导航
-- 使用 Ctrl+Shift+h/j/k/l 在 Neovim 和 Kitty 窗口之间导航
-- 直接加载，不使用 lazy.nvim

-- 检查是否在 kitty 环境中运行
local in_kitty = vim.env.KITTY_LISTEN_ON ~= nil

if not in_kitty then
  -- 不在 kitty 中，使用默认窗口导航
  vim.keymap.set({ 'n', 't' }, '<C-S-h>', '<C-w>h', { desc = 'Go to left window', silent = true })
  vim.keymap.set({ 'n', 't' }, '<C-S-j>', '<C-w>j', { desc = 'Go to lower window', silent = true })
  vim.keymap.set({ 'n', 't' }, '<C-S-k>', '<C-w>k', { desc = 'Go to upper window', silent = true })
  vim.keymap.set({ 'n', 't' }, '<C-S-l>', '<C-w>l', { desc = 'Go to right window', silent = true })
  return
end

-- Neovim 方向 → Kitty 方向映射
local direction_map = {
  h = 'left',
  j = 'bottom',
  k = 'top',
  l = 'right',
}

-- 调用 kitty remote control 切换到相邻窗口
local function navigate_kitty(direction)
  local socket = vim.env.KITTY_LISTEN_ON
  local kitty_direction = direction_map[direction]

  if not socket or not kitty_direction then
    return
  end

  -- 使用 kitty @ focus-window 命令
  local cmd = string.format(
    'kitty @ --to=%s focus-window --match neighbor:%s 2>/dev/null',
    vim.fn.shellescape(socket),
    kitty_direction
  )

  -- 异步执行，避免阻塞
  vim.fn.system(cmd)
end

-- 检测当前窗口是否是浮动窗口
local function is_floating_window()
  local win_config = vim.api.nvim_win_get_config(0)
  return win_config.relative ~= ''
end

-- 主导航函数
local function navigate(direction)
  -- 如果是浮动窗口，直接导航到 kitty panel
  if is_floating_window() then
    navigate_kitty(direction)
    return
  end

  -- 记录当前窗口号
  local current_win = vim.fn.winnr()

  -- 尝试在 Neovim 内移动
  vim.cmd('wincmd ' .. direction)

  -- 获取移动后的窗口号
  local new_win = vim.fn.winnr()

  -- 如果窗口号没变，说明在边界，尝试切换 kitty 窗口
  if current_win == new_win then
    navigate_kitty(direction)
  end
end

-- 设置快捷键
local map_opts = { silent = true, noremap = true }

vim.keymap.set(
  { 'n', 't' },
  '<C-S-h>',
  function()
    navigate 'h'
  end,
  vim.tbl_extend('force', map_opts, { desc = 'Navigate left (Neovim/Kitty)' })
)

vim.keymap.set(
  { 'n', 't' },
  '<C-S-j>',
  function()
    navigate 'j'
  end,
  vim.tbl_extend('force', map_opts, { desc = 'Navigate down (Neovim/Kitty)' })
)

vim.keymap.set(
  { 'n', 't' },
  '<C-S-k>',
  function()
    navigate 'k'
  end,
  vim.tbl_extend('force', map_opts, { desc = 'Navigate up (Neovim/Kitty)' })
)

vim.keymap.set(
  { 'n', 't' },
  '<C-S-l>',
  function()
    navigate 'l'
  end,
  vim.tbl_extend('force', map_opts, { desc = 'Navigate right (Neovim/Kitty)' })
)
