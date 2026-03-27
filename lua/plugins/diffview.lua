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
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewRefresh" },
    keys = {
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Git Hunk/History" },
      { "<leader>gd", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>ghf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
      { "<leader>ghF", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview Repo History" },
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
            { "n", "<Left>", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "<Right>", actions.select_next_entry, { desc = "Next File" } },
            { "n", "H", actions.select_prev_entry, { desc = "Previous File" } },
            { "n", "L", actions.select_next_entry, { desc = "Next File" } },
          },
          file_panel = {
            { "n", "<Right>", actions.focus_entry, { desc = "Open and Focus Entry" } },
            { "n", "L", actions.focus_entry, { desc = "Open and Focus Entry" } },
          },
          file_history_panel = {
            { "n", "<Right>", actions.focus_entry, { desc = "Open and Focus Entry" } },
            { "n", "L", actions.focus_entry, { desc = "Open and Focus Entry" } },
          },
        },
      }
    end,
  },
}
