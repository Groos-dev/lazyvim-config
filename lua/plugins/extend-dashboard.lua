return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}

      -- 覆盖默认的 header 格式，不使用居中对齐
      opts.dashboard.formats = opts.dashboard.formats or {}
      opts.dashboard.formats.header = { "%s", align = "left" }

      opts.dashboard.sections = {
        {
          header = [[
████████╗ █████╗ ██╗  ██╗███████╗    ██╗████████╗    ███████╗ █████╗ ███████╗██╗   ██╗
╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝    ██║╚══██╔══╝    ██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝
   ██║   ███████║█████╔╝ █████╗      ██║   ██║       █████╗  ███████║███████╗ ╚████╔╝
   ██║   ██╔══██║██╔═██╗ ██╔══╝      ██║   ██║       ██╔══╝  ██╔══██║╚════██║  ╚██╔╝
   ██║   ██║  ██║██║  ██╗███████╗    ██║   ██║       ███████╗██║  ██║███████║   ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝   ╚═╝       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝

    Enjoy the journey, one commit at a time!
]],
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      }
    end,
  },
}
