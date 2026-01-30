return {
  -- LazyVim 使用 snacks.nvim 文件浏览器
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- 配置 picker 的 explorer 默认选项
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = {
        hidden = true, -- 显示隐藏文件
        ignored = true, -- 显示被 gitignore 忽略的文件
      }
      return opts
    end,
  },
}

