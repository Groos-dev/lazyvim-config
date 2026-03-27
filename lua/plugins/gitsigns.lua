return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.preview_config = vim.tbl_deep_extend("force", opts.preview_config or {}, {
        border = "rounded",
      })
    end,
    keys = {
      { "<leader>ghp", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
      { "<leader>ghb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
      { "<leader>ghB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line Full" },
    },
  },
}
