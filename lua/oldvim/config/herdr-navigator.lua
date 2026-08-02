-- Use Ctrl+h/j/k/l to navigate seamlessly between Neovim windows and Herdr panes.
local directions = {
  h = 'left',
  j = 'down',
  k = 'up',
  l = 'right',
}

local function focus_herdr(direction)
  if not vim.env.HERDR_PANE_ID then
    return
  end

  vim.system({
    'herdr',
    'pane',
    'focus',
    '--direction',
    direction,
    '--current',
  }, { detach = true })
end

local function navigate(key)
  local current_window = vim.api.nvim_get_current_win()
  vim.cmd('wincmd ' .. key)

  if current_window == vim.api.nvim_get_current_win() then
    focus_herdr(directions[key])
  end
end

for key, direction in pairs(directions) do
  vim.keymap.set({ 'n', 't' }, '<C-' .. key .. '>', function()
    navigate(key)
  end, {
    desc = 'Navigate ' .. direction .. ' (Neovim/Herdr)',
    silent = true,
  })
end
