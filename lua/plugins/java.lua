local java_filetypes = { "java" }
local eclipse_formatter_url = vim.fn.expand("~/.config/nvim/java/eclipse-java-style.xml")

local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom)
  end
  return config
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = java_filetypes,
    opts = function(_, opts)
      opts = opts or {}
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }
      if not vim.tbl_contains(opts.cmd, "--jvm-arg=-Xmx4G") then
        table.insert(opts.cmd, "--jvm-arg=-Xmx4G")
      end
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.inlayHints = opts.settings.java.inlayHints or {
        parameterNames = {
          enabled = "all",
        },
      }
      opts.settings.java.format = opts.settings.java.format or {
        enabled = true,
        settings = {
          url = eclipse_formatter_url,
          profile = "Default",
        },
      }
      return opts
    end,
    init = function()
      vim.api.nvim_create_user_command("StartJdts", function()
        local lazy = require("lazy")
        if not package.loaded["jdtls"] then
          lazy.load({ plugins = { "nvim-jdtls" } })
        end

        if vim.bo.filetype ~= "java" then
          vim.notify("请在 Java buffer 中执行 :StartJdts", vim.log.levels.WARN)
          return
        end

        vim.b.start_jdtls = true
        vim.api.nvim_exec_autocmds("FileType", {
          pattern = "java",
          modeline = false,
        })
      end, { desc = "Start/attach jdtls Java LSP" })
    end,
    config = function(_, opts)
      local LazyVim = require("lazyvim.util")
      local bundles = {}

      if LazyVim.has("mason.nvim") then
        local mason_registry = require("mason-registry")
        if opts.dap and LazyVim.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
          bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
          if opts.test and mason_registry.is_installed("java-test") then
            vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))
          end
        end
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        if fname == "" or vim.bo.filetype ~= "java" then
          return
        end

        local root_dir = opts.root_dir(fname)
        local started_roots = vim.g._start_jdtls_roots or {}
        if not vim.b.start_jdtls and not (root_dir and started_roots[root_dir]) then
          return
        end

        vim.b.start_jdtls = nil
        if root_dir then
          started_roots[root_dir] = true
          vim.g._start_jdtls_roots = started_roots
        end

        local config = extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = root_dir,
          init_options = {
            bundles = bundles,
          },
          settings = opts.settings,
          capabilities = LazyVim.has("blink.cmp") and require("blink.cmp").get_lsp_capabilities()
            or LazyVim.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities()
            or nil,
        }, opts.jdtls)

        require("jdtls").start_or_attach(config)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local wk = require("which-key")
            wk.add({
              {
                mode = "n",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
                { "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
                { "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
                { "<leader>cgS", require("jdtls.tests").goto_subjects, desc = "Goto Subjects" },
                { "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
              },
            })
            wk.add({
              {
                mode = "x",
                buffer = args.buf,
                { "<leader>cx", group = "extract" },
                {
                  "<leader>cxm",
                  [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                  desc = "Extract Method",
                },
                {
                  "<leader>cxv",
                  [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                  desc = "Extract Variable",
                },
                {
                  "<leader>cxc",
                  [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                  desc = "Extract Constant",
                },
              },
            })

            if LazyVim.has("mason.nvim") then
              local mason_registry = require("mason-registry")
              if opts.dap and LazyVim.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
                require("jdtls").setup_dap(opts.dap)
                if opts.dap_main then
                  require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
                end

                if opts.test and mason_registry.is_installed("java-test") then
                  wk.add({
                    {
                      mode = "n",
                      buffer = args.buf,
                      { "<leader>t", group = "test" },
                      {
                        "<leader>tt",
                        function()
                          require("jdtls.dap").test_class({
                            config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
                          })
                        end,
                        desc = "Run All Test",
                      },
                      {
                        "<leader>tr",
                        function()
                          require("jdtls.dap").test_nearest_method({
                            config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
                          })
                        end,
                        desc = "Run Nearest Test",
                      },
                      { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
                    },
                  })
                end
              end
            end

            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end,
      })
    end,
  },
}
