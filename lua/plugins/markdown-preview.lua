return {
  -- render-markdown.nvim - 最推荐的 Markdown 预览插件
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- 代码块样式
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      -- 标题样式
      heading = {
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Preview" },
    },
  },
}
