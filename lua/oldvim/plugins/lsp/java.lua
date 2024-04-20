local util = require 'oldvim.util'

local java_filetypes = { 'java' }

local function get_bundles()
  -- exported in devshell
  local java_dbg_path = os.getenv 'VSCODE_JAVA_DEBUG'
  local java_test_path = os.getenv 'VSCODE_JAVA_TEST'

  local jar_patterns = {
    java_dbg_path .. '/server/com.microsoft.java.debug.plugin-*.jar',
    java_test_path .. '/server/*.jar',
  }

  -- These jar are not 'bundle'.
  local exclude = {
    'com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies%.jar',
    'jacocoagent%.jar',
  }

  local bundles = {} ---@type string[]
  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
      if not util.contains(exclude, bundle) then
        print(bundle)
        table.insert(bundles, bundle)
      end
    end
  end

  return bundles
end

local function get_cmd(root_dir)
  local name = root_dir and vim.fs.basename(root_dir)

  local config_dir = vim.fn.stdpath 'cache' .. '/jdtls/' .. name .. '/config'
  local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls/' .. name .. '/workspace'

  local lombok_dir = os.getenv 'LOMBOK' .. '/share/java/lombok.jar'

  return {
    vim.fn.exepath 'jdtls',
    '--jvm-arg=-javaagent:' .. lombok_dir,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  }
end

local function get_setting()
  return {
    java = {
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath 'config' .. '/nvim/extra/eclipse-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
        importOrder = {
          'java',
          'javax',
          'com',
          'org',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      -- If you're starting eclipse.jdt.ls with a Java version
      -- that's different from the one the project uses,
      -- you need to configure the available Java runtimes.
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        -- runtimes = {
        --   name = 'java-17-openjdk',
        --   path = os.getenv 'JDK17',
        -- },
      },
    },
  }
end

local template = [[
package ${package_name};

/*
 * @author: ${user}
 * @since: ${since}
 */
public class ${class_name} {

}
]]

local function on_create(destination)
  local file = io.open(destination, 'a')

  if file then
    local pattern = '/java/(.-)/([^/]+)%.java$'
    local package_name, class_name = string.match(destination, pattern)

    local data = {
      package_name = string.gsub(package_name, '/', '.'),
      class_name = class_name,
      user = 'oldflag',
      since = os.date '%Y/%m/%d %H:%M',
    }

    local insert = require('oldvim.util').render_template(template, data)
    file:write(insert)
    file:close()
  end
end

return {
  'mfussenegger/nvim-jdtls',
  ft = java_filetypes,
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neo-tree/neo-tree.nvim',
  },
  config = function()
    local specs = { 'gradlew', '.git', 'mvnw', '.workspace' }
    local root_dir = require('oldvim.util').root.get_root(specs)

    local config = {
      cmd = get_cmd(root_dir),
      filetypes = java_filetypes,
      root_dir = root_dir,
      init_options = {
        bundles = get_bundles(),
      },
      capabilities = util.lsp.get_capabilities(),
      flags = {
        allow_incremental_sync = true,
      },
      settings = get_setting(),
      autostart = true,
    }

    local jdtls = require 'jdtls'
    local jdtls_dap = require 'jdtls.dap'
    local jdtls_setup = require 'jdtls.setup'

    config.on_attach = function(_, bufnr)
      jdtls.setup_dap {
        hotcodereplace = 'auto',
        config_overrides = {},
      }
      jdtls_dap.setup_dap_main_class_configs {}
      jdtls_setup.add_commands()

      local function fmt(_)
        vim.lsp.buf.format()
      end

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', fmt)
    end

    local function attach_jdtls()
      jdtls.start_or_attach(config)
      vim.lsp.set_log_level 'off'
    end

    util.autocmd('FileType', {
      pattern = java_filetypes,
      callback = attach_jdtls,
    })

    local ok, events = pcall(require, 'neo-tree.events')
    if ok then
      events.subscribe {
        event = events.FILE_ADDED,
        handler = on_create,
      }
    end

    attach_jdtls()
  end,
}
