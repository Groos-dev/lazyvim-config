local store_path = vim.fn.stdpath("data") .. "/snacks_explorer.json"
local current_width = nil

local function store_key()
  local r = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
  if r.code == 0 then
    return r.stdout:gsub("%s+", "")
  end
  return vim.fn.getcwd()
end

local function read_store()
  local f = io.open(store_path, "r")
  if not f then
    return {}
  end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return ok and data or {}
end

local function read_width()
  return read_store()[store_key()] or 36
end

local function save_width()
  if not current_width then
    return
  end
  local store = read_store()
  store[store_key()] = current_width
  local f = io.open(store_path, "w")
  if f then
    f:write(vim.json.encode(store))
    f:close()
  end
end

local function set_width(width)
  current_width = math.max(20, width)
  vim.cmd("vertical resize " .. current_width)
end

local function explorer_opts(cwd)
  return {
    cwd = cwd,
    layout = {
      layout = {
        width = read_width(),
      },
    },
  }
end

return {
  -- LazyVim 使用 snacks.nvim 文件浏览器
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          Snacks.explorer(explorer_opts(LazyVim.root()))
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>fE",
        function()
          Snacks.explorer(explorer_opts())
        end,
        desc = "Explorer Snacks (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
    },
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- 显示隐藏文件
            ignored = true, -- 显示被 gitignore 忽略的文件
            exclude = { ".git" }, -- 排除 .git 文件夹
            win = {
              list = {
                keys = {
                  ["<"] = function()
                    set_width(vim.api.nvim_win_get_width(0) - 5)
                  end,
                  [">"] = function()
                    set_width(vim.api.nvim_win_get_width(0) + 5)
                  end,
                  ["="] = function()
                    set_width(36)
                  end,
                },
              },
            },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd({ "BufWinLeave", "WinClosed" }, {
        callback = function()
          if vim.bo.filetype == "snacks_picker_list" then
            save_width()
          end
        end,
        desc = "save snacks explorer width",
      })
    end,
  },
}
