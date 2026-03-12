local enable_jdtls = false

return {
  {
    "mfussenegger/nvim-jdtls",
    enabled = enable_jdtls,
    opts = function(_, opts)
      opts.cmd = opts.cmd or { vim.fn.exepath("jdtls") }
      if not vim.tbl_contains(opts.cmd, "--jvm-arg=-Xmx4G") then
        table.insert(opts.cmd, "--jvm-arg=-Xmx4G")
      end
    end,
  },
}
