local function get_gitlab_host()
  local r = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
  if r.code ~= 0 then
    return nil
  end
  local url = r.stdout:gsub("%s+", "")
  local host = url:match("https?://([^/]+)") or url:match("git@([^:]+)")
  return host
end

local function is_gitlab_project()
  local host = get_gitlab_host()
  if not host then
    return false
  end
  return not host:find("github%.com") and not host:find("bitbucket%.org")
end

local function ensure_auth(callback)
  if not is_gitlab_project() then
    vim.notify("Not a GitLab repository", vim.log.levels.WARN)
    return
  end

  local host = get_gitlab_host()
  if not host then
    vim.notify("Cannot detect GitLab host from remote", vim.log.levels.ERROR)
    return
  end

  local status = vim.system({ "glab", "auth", "status" }, { text = true }):wait()
  local output = (status.stdout or "") .. (status.stderr or "")
  if output:find("Logged in to " .. host) then
    callback()
    return
  end

  vim.notify("Not logged in to " .. host .. ". Run: glab auth login --hostname " .. host, vim.log.levels.ERROR)
end

local function fetch_and_diff(mr_id, target_branch)
  vim.notify("Fetching MR !" .. mr_id .. " ...", vim.log.levels.INFO)
  vim.fn.jobstart(
    { "git", "fetch", "-f", "origin", string.format("merge-requests/%s/head:mr/%s", mr_id, mr_id), target_branch },
    {
      on_exit = function(_, code)
        if code ~= 0 then
          vim.notify("Fetch MR failed", vim.log.levels.ERROR)
          return
        end
        local target = "origin/" .. target_branch
        vim.cmd(string.format("DiffviewOpen %s...mr/%s", target, mr_id))
      end,
    }
  )
end

local function open_mr_picker()
  local result = vim.system({ "glab", "mr", "list", "--output", "json" }, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify("glab mr list failed:\n" .. (result.stderr or result.stdout), vim.log.levels.ERROR)
    return
  end

  local ok, mrs = pcall(vim.json.decode, result.stdout)
  if not ok or type(mrs) ~= "table" or #mrs == 0 then
    vim.notify("No merge requests found", vim.log.levels.WARN)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "GitLab Merge Requests",
      layout_strategy = "vertical",
      finder = finders.new_table({
        results = mrs,
        entry_maker = function(mr)
          return {
            value = mr,
            display = string.format(
              "%s -> %s  !%s  %s",
              mr.source_branch,
              mr.target_branch or "main",
              mr.iid,
              mr.title
            ),
            ordinal = mr.source_branch .. " " .. (mr.target_branch or "") .. " " .. mr.iid .. " " .. mr.title,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          local mr = selection.value
          fetch_and_diff(mr.iid, mr.target_branch or "main")
        end)

        map("n", "q", actions.close)
        map("i", "<c-q>", actions.close)
        return true
      end,
    })
    :find()
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>gm",
      function()
        ensure_auth(open_mr_picker)
      end,
      desc = "GitLab MR -> Diffview",
    },
  },
}
