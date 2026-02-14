-- Kitty + Neovim seamless window navigation
-- Use Ctrl+Shift+h/j/k/l to navigate between Neovim and Kitty windows
-- Loaded directly, not using lazy.nvim

local function get_kitty_socket()
  local env_socket = vim.env.KITTY_LISTEN_ON
  if not env_socket or env_socket == "" then
    return nil
  end
  local socket_path = env_socket:gsub("^unix:", "")
  if vim.fn.filereadable(socket_path) == 1 then
    return env_socket
  end
  local handle = io.popen("ls " .. socket_path .. "-* 2>/dev/null | head -1")
  if handle then
    local result = handle:read("*l")
    handle:close()
    if result and result ~= "" then
      return "unix:" .. result
    end
  end
  return env_socket
end

local kitty_socket = get_kitty_socket()
local in_kitty = kitty_socket ~= nil

if not in_kitty then
  vim.notify("Kitty-nav: Not in kitty environment", vim.log.levels.WARN)
end

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

local function navigate_kitty(direction)
  local kitty_direction = direction_map[direction]

  if not kitty_socket or not kitty_direction then
    vim.notify("Kitty-nav: socket or direction missing", vim.log.levels.ERROR)
    return
  end

  local cmd = string.format(
    'kitten @ --to=%s focus-window --match neighbor:%s',
    kitty_socket,
    kitty_direction
  )

  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  if exit_code ~= 0 then
    vim.notify(string.format("Kitty-nav ERROR: cmd=%s\nexit=%d\nresult=%s", cmd, exit_code, result), vim.log.levels.ERROR)
  end
end

-- 检测当前窗口是否是浮动窗口
local function is_floating_window()
  local win_config = vim.api.nvim_win_get_config(0)
  return win_config.relative ~= ''
end

-- 主导航函数
local function navigate(direction)
  local current_win = vim.fn.winnr()

  if is_floating_window() then
    navigate_kitty(direction)
    return
  end

  vim.cmd('wincmd ' .. direction)

  local new_win = vim.fn.winnr()
  if current_win == new_win then
    navigate_kitty(direction)
  end
end

vim.api.nvim_create_user_command('KittyNavTest', function()
  vim.notify("Kitty socket: " .. tostring(kitty_socket), vim.log.levels.INFO)
  if kitty_socket then
    local cmd = string.format('kitten @ --to=%s ls', kitty_socket)
    local result = vim.fn.system(cmd)
    vim.notify("Test cmd: " .. cmd .. "\nResult: " .. result, vim.log.levels.INFO)
  end
end, { desc = 'Test kitty navigator connection' })

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
