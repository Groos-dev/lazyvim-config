return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.preview_config = vim.tbl_deep_extend("force", opts.preview_config or {}, {
        border = "rounded",
      })
    end,
    keys = {
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next Hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Prev Hunk" },
      { "<leader>gph", function() require("gitsigns").preview_hunk() end, desc = "Preview Hunk" },
      { "<leader>gb", function() require("gitsigns").blame_line() end, desc = "Blame Line" },
      { "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame Line Full" },
    },
  },
}
