local M = {}

function M.get(file_names)
  file_names = file_names or { '.root', '.git' }
  -- Get the current file path
  local current_dir = vim.fn.expand '%:p:h'

  -- Iterate through the directory and its parent directories
  local last_dir
  while current_dir ~= '/' do
    -- Check if all files exist in the current directory
    local found = false
    for _, file_name in ipairs(file_names) do
      local file_path = current_dir .. '/' .. file_name
      local stat = vim.loop.fs_stat(file_path)
      if stat and stat.type == 'file' then
        found = true
      end
    end

    -- If all files are found, update the last directory
    if found then
      last_dir = current_dir
    end

    -- Move up one directory
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  -- Return the last directory found containing all files
  return last_dir
end

return M
