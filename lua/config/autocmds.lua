-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- 禁用 LazyVim 默认的拼写检查
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! wall",
  desc = "auto save",
})

vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost" }, {
  pattern = "*",
  command = "silent! wshada!",
  desc = "save shada",
})

-- Mute diffview delete line highlighting
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local bg = "#3d0100"
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = bg, fg = bg })
    vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = bg, fg = bg })
    vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { bg = bg, fg = bg })
  end,
  desc = "Mute diffview delete line colors",
})

-- Apply immediately on startup
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3d0100", fg = "#3d0100" })
vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = "#3d0100", fg = "#3d0100" })
vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { bg = "#3d0100", fg = "#3d0100" })
