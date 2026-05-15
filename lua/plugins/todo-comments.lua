return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>cF")
          pcall(vim.keymap.del, "n", "<leader>cR")
          local map = vim.keymap.set
          map("n", "<leader>cF", "<cmd>TodoInsertFIXME<CR>", { desc = "Insert FIXME" })
          map("n", "<leader>cR", "<cmd>TodoInsertREVIEW<CR>", { desc = "Insert REVIEW" })
        end,
      })
    end,
    opts = {
      merge_keywords = false,
      highlight = {
        pattern = [[.*<(KEYWORDS)(\([^)]*\))?\s*:]],
        before = "",
        keyword = "wide",
        after = "fg",
      },
      search = {
        pattern = [[\b(KEYWORDS)(\([^)]*\))?:]],
      },
      keywords = {
        BUG = { icon = " ", color = "error" },
        FIXME = { icon = " ", color = "error" },
        REVIEW = { icon = " ", color = "hint" },
        OPTIMIZE = { icon = " ", color = "warning" },
        TODO = { icon = " ", color = "info" },
        NIT = { icon = "󰉿 ", color = "hint" },
        NOTE = { icon = " ", color = "hint" },
      },
    },
    keys = {
      { "<leader>cB", "<cmd>TodoInsertBUG<CR>", desc = "Insert BUG" },
      { "<leader>cF", "<cmd>TodoInsertFIXME<CR>", desc = "Insert FIXME" },
      { "<leader>cR", "<cmd>TodoInsertREVIEW<CR>", desc = "Insert REVIEW" },
      { "<leader>cO", "<cmd>TodoInsertOPTIMIZE<CR>", desc = "Insert OPTIMIZE" },
      { "<leader>cT", "<cmd>TodoInsertTODO<CR>", desc = "Insert TODO" },
      { "<leader>cI", "<cmd>TodoInsertNIT<CR>", desc = "Insert NIT" },
      { "<leader>cN", "<cmd>TodoInsertNOTE<CR>", desc = "Insert NOTE" },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)

      local function insert_tag(tag)
        local line = vim.api.nvim_get_current_line()
        local indent = line:match("^%s*") or ""
        local comment_string = vim.bo.commentstring:gsub("%%s", "")
        local tag_str = indent .. comment_string .. " " .. tag .. ": "
        local row = vim.api.nvim_win_get_cursor(0)[1]
        if line:match("^%s*$") then
          vim.api.nvim_buf_set_lines(0, row - 1, row, false, { tag_str })
        else
          vim.api.nvim_buf_set_lines(0, row, row, false, { tag_str })
          row = row + 1
        end
        vim.api.nvim_win_set_cursor(0, { row, #tag_str })
        vim.cmd("startinsert!")
      end

      for _, tag in ipairs({ "BUG", "FIXME", "REVIEW", "OPTIMIZE", "TODO", "NIT", "NOTE" }) do
        vim.api.nvim_create_user_command("TodoInsert" .. tag, function()
          insert_tag(tag)
        end, {})
      end
    end,
  },
}
