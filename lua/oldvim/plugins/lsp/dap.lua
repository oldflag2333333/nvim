local function executable(names)
  for _, name in ipairs(names) do
    local path = vim.fn.exepath(name)
    if path ~= '' then
      return path
    end
  end
end

local function notify_missing(names)
  vim.notify('DAP adapter not found. Install one of: ' .. table.concat(names, ', '), vim.log.levels.WARN)
end

local function program_prompt()
  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local function load_launchjs()
  require('dap.ext.vscode').load_launchjs(nil, {
    codelldb = { 'c', 'cpp', 'rust' },
    lldb = { 'c', 'cpp', 'rust' },
    gdb = { 'c', 'cpp', 'rust' },
  })
end

local function define_sign(name, icon)
  local text = icon
  local texthl = name
  local linehl = ''

  if type(icon) == 'table' then
    text = icon[1]
    texthl = icon[2] or texthl
    linehl = icon[3] or linehl
  end

  vim.fn.sign_define(name, { text = text, texthl = texthl, linehl = linehl, numhl = '' })
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local widgets = require 'dap.ui.widgets'
    local bind = require('oldvim.util').bind

    local codelldb_names = { 'codelldb' }
    local lldb_names = { 'lldb-dap', 'lldb-vscode' }
    local gdb_names = { 'gdb' }

    dap.adapters.codelldb = function(callback)
      local command = executable(codelldb_names)
      if not command then
        notify_missing(codelldb_names)
        return
      end

      callback {
        type = 'server',
        port = '${port}',
        executable = {
          command = command,
          args = { '--port', '${port}' },
        },
      }
    end

    dap.adapters.lldb = function(callback)
      local command = executable(lldb_names)
      if not command then
        notify_missing(lldb_names)
        return
      end

      callback {
        type = 'executable',
        command = command,
        name = 'lldb',
      }
    end

    dap.adapters.gdb = function(callback)
      local command = executable(gdb_names)
      if not command then
        notify_missing(gdb_names)
        return
      end

      callback {
        type = 'executable',
        command = command,
        args = { '-i', 'dap' },
      }
    end

    dap.configurations.cpp = {
      {
        name = 'Launch executable (CodeLLDB)',
        type = 'codelldb',
        request = 'launch',
        program = program_prompt,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Attach to process (CodeLLDB)',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        program = program_prompt,
        cwd = '${workspaceFolder}',
      },
      {
        name = 'Launch executable (LLDB DAP)',
        type = 'lldb',
        request = 'launch',
        program = program_prompt,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
      {
        name = 'Launch executable (GDB)',
        type = 'gdb',
        request = 'launch',
        program = program_prompt,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    bind('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    bind('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    bind('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    bind('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    bind('n', '<F9>', dap.terminate, { desc = 'Debug: Terminate' })
    bind('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    bind('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })
    bind('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run Last' })
    bind('n', '<leader>dp', dap.pause, { desc = 'Debug: Pause' })
    bind('n', '<leader>dr', dap.repl.toggle, { desc = 'Debug: Toggle REPL' })
    bind('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
    bind('n', '<leader>dw', widgets.hover, { desc = 'Debug: Hover Widget' })
    bind('n', '<leader>dL', load_launchjs, { desc = 'Debug: Load launch.json' })

    vim.api.nvim_create_user_command('DapLoadLaunchJson', load_launchjs, { desc = 'Load .vscode/launch.json for nvim-dap' })

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    local icons = require('oldvim.config.misc').icons.dap
    define_sign('DapStopped', icons.Stopped)
    define_sign('DapBreakpoint', icons.Breakpoint)
    define_sign('DapBreakpointCondition', icons.BreakpointCondition)
    define_sign('DapBreakpointRejected', icons.BreakpointRejected)
    define_sign('DapLogPoint', icons.LogPoint)

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
  end,
}
