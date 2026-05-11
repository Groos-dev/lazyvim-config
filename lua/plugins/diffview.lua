return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>gd", false },
      { "<leader>gD", false },
      { "<leader>gh", false },
      { "<leader>gH", false },
      { "<leader>gf", false },
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
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff working tree" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>",   desc = "Diff last commit" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>",   desc = "File history (repo)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>",         desc = "Diff close" },
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
          file_panel = {
            { "n", "j",       actions.next_entry,         { desc = "下一个文件" } },
            { "n", "k",       actions.prev_entry,         { desc = "上一个文件" } },
            { "n", "<cr>",    actions.select_entry,       { desc = "打开文件 diff" } },
            { "n", "s",       actions.toggle_stage_entry, { desc = "stage/unstage" } },
            { "n", "S",       actions.stage_all,          { desc = "stage 全部" } },
            { "n", "U",       actions.unstage_all,        { desc = "unstage 全部" } },
            { "n", "X",       actions.restore_entry,      { desc = "discard 改动" } },
            { "n", "R",       actions.refresh_files,      { desc = "刷新" } },
            { "n", "<tab>",   actions.select_next_entry,  { desc = "下一个文件" } },
            { "n", "<s-tab>", actions.select_prev_entry,  { desc = "上一个文件" } },
            { "n", "q",       "<cmd>DiffviewClose<cr>",   { desc = "关闭" } },
          },
          view = {
            { "n", "]x",      actions.next_conflict,      { desc = "下一个冲突" } },
            { "n", "[x",      actions.prev_conflict,      { desc = "上一个冲突" } },
            { "n", "<tab>",   actions.select_next_entry,  { desc = "下一个文件" } },
            { "n", "<s-tab>", actions.select_prev_entry,  { desc = "上一个文件" } },
            { "n", "q",       "<cmd>DiffviewClose<cr>",   { desc = "关闭" } },
          },
          file_history_panel = {
            { "n", "j",    actions.next_entry,       { desc = "下一条" } },
            { "n", "k",    actions.prev_entry,       { desc = "上一条" } },
            { "n", "<cr>", actions.select_entry,     { desc = "查看这次 commit" } },
            { "n", "y",    actions.copy_hash,        { desc = "复制 commit hash" } },
            { "n", "q",    "<cmd>DiffviewClose<cr>", { desc = "关闭" } },
          },
        },
      }
    end,
  },
}
