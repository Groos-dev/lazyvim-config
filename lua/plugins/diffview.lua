return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>gd", false },
      { "<leader>gD", false },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    init = function()
      local function open_compare(opts)
        vim.cmd("DiffviewOpen " .. opts.args)
      end

      vim.api.nvim_create_user_command("DiffCompare", open_compare, {
        nargs = 1,
        desc = "Open Diffview against target branch",
      })

      vim.api.nvim_create_user_command("Dfc", open_compare, {
        nargs = 1,
        desc = "Open Diffview against target branch",
      })

      vim.cmd.cnoreabbrev(
        "<expr> diff_compare getcmdtype() == ':' && getcmdline() == 'diff_compare' ? 'DiffCompare' : 'diff_compare'"
      )
      vim.cmd.cnoreabbrev("<expr> dfc getcmdtype() == ':' && getcmdline() == 'dfc' ? 'Dfc' : 'dfc'")
    end,
    keys = {
      { "<leader>g", group = "Git" },
      { "<leader>gv", group = "Git History" },
      { "<leader>gvo", "<cmd>DiffviewOpen HEAD<cr>", desc = "Open Diffview" },
      { "<leader>gvq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gvf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gvr", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
      { "<leader>gvc", "<cmd>DiffviewOpen HEAD^!<cr>", desc = "HEAD Commit Diff" },
    },
    opts = function()
      local actions = require("diffview.actions")

      return {
        view = {
          default = {
            layout = "diff2_horizontal",
          },
          file_history = {
            layout = "diff2_horizontal",
          },
        },
        file_panel = {
          win_config = {
            width = 50,
          },
        },
        file_history_panel = {
          win_config = {
            position = "left",
            width = 50,
          },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.keymap.set("n", "j", "gj", { buffer = bufnr, silent = true, desc = "Next Screen Line" })
            vim.keymap.set("n", "k", "gk", { buffer = bufnr, silent = true, desc = "Previous Screen Line" })
          end,
        },
        keymaps = {
          view = {
            { "n", "E", actions.goto_file_edit, { desc = "Edit Source File" } },
            { "n", "<Left>", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "<Right>", actions.select_next_entry, { desc = "Next File" } },
            { "n", "K", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "J", actions.select_next_entry, { desc = "Next File" } },
          },
          file_panel = {
            { "n", "E", actions.goto_file_edit, { desc = "Edit Source File" } },
            { "n", "<Right>", actions.focus_entry, { desc = "Open and Focus Entry" } },
            { "n", "K", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "J", actions.select_next_entry, { desc = "Next File" } },
          },
          file_history_panel = {
            { "n", "E", actions.goto_file_edit, { desc = "Edit Source File" } },
            { "n", "<Right>", actions.focus_entry, { desc = "Open and Focus Entry" } },
            { "n", "K", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "J", actions.select_next_entry, { desc = "Next File" } },
          },
        },
      }
    end,
  },
}
