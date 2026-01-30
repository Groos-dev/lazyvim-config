return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- 在这里定义你自己的 header
      local new_header = [[
████████╗ █████╗ ██╗  ██╗███████╗    ██╗████████╗    ███████╗ █████╗ ███████╗██╗   ██╗
╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝    ██║╚══██╔══╝    ██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝
   ██║   ███████║█████╔╝ █████╗      ██║   ██║       █████╗  ███████║███████╗ ╚████╔╝
   ██║   ██╔══██║██╔═██╗ ██╔══╝      ██║   ██║       ██╔══╝  ██╔══██║╚════██║  ╚██╔╝
   ██║   ██║  ██║██║  ██╗███████╗    ██║   ██║       ███████╗██║  ██║███████║   ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝   ╚═╝       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝

    Enjoy the journey, one commit at a time!
]]

      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = new_header
      -- 替换默认的 header
    end,
  },
}
