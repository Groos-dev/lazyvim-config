return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*:]],
      before = "",
      keyword = "wide",
      after = "fg",
    },
    keywords = {
      REVIEW = {
        icon = " ",
        color = "hint",
        alt = { "REFACTOR", "OPTIMIZE" },
      },
    },
  },
  keys = {
    { "<leader>cT", "<cmd>TodoInsertTODO<CR>", desc = "Insert TODO" },
    { "<leader>cF", "<cmd>TodoInsertFIXME<CR>", desc = "Insert FIXME" },
    { "<leader>cR", "<cmd>TodoInsertREVIEW<CR>", desc = "Insert REVIEW" },
    { "<leader>cN", "<cmd>TodoInsertNOTE<CR>", desc = "Insert NOTE" },
    { "<leader>cH", "<cmd>TodoInsertHACK<CR>", desc = "Insert HACK" },
    { "<leader>cW", "<cmd>TodoInsertWARN<CR>", desc = "Insert WARN" },
    { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo (Telescope)" },
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

    for _, tag in ipairs({ "TODO", "FIXME", "REVIEW", "NOTE", "HACK", "WARN" }) do
      vim.api.nvim_create_user_command("TodoInsert" .. tag, function()
        insert_tag(tag)
      end, {})
    end
  end,
}
