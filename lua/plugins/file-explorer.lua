return {
  -- LazyVim 使用 snacks.nvim 文件浏览器
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- 显示隐藏文件
            ignored = true, -- 显示被 gitignore 忽略的文件
            exclude = { ".git" }, -- 排除 .git 文件夹
          },
        },
      },
    },
  },
}
