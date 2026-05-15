return {
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>gd", false },
      { "<leader>gD", false },
      { "<leader>gh", false },
      { "<leader>gH", false },
      { "<leader>gf", false },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    init = function()
      local function open_compare(opts)
        vim.cmd("DiffviewOpen " .. opts.args)
      end

      vim.api.nvim_create_user_command("DiffCompare", open_compare, {
        nargs = 1,
        desc = "Open Diffview against target branch",
      })

      vim.api.nvim_create_user_command("Dfc", open_compare, {
        nargs = 1,
        desc = "Open Diffview against target branch",
      })

      vim.cmd.cnoreabbrev(
        "<expr> diff_compare getcmdtype() == ':' && getcmdline() == 'diff_compare' ? 'DiffCompare' : 'diff_compare'"
      )
      vim.cmd.cnoreabbrev("<expr> dfc getcmdtype() == ':' && getcmdline() == 'dfc' ? 'Dfc' : 'dfc'")
    end,
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff last commit" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current)" },
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Diff close" },
      {
        "<leader>gv",
        function()
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local function get_repo_key()
            local r = vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait()
            return r.code == 0 and r.stdout:gsub("%s+", "") or ""
          end

          local store_path = vim.fn.stdpath("data") .. "/diffview_branches.json"

          local function load_store()
            local f = io.open(store_path, "r")
            if not f then
              return {}
            end
            local content = f:read("*a")
            f:close()
            local ok, data = pcall(vim.json.decode, content)
            return ok and data or {}
          end

          local function save_store(data)
            local f = io.open(store_path, "w")
            if f then
              f:write(vim.json.encode(data))
              f:close()
            end
          end

          local function get_default_branch()
            local store = load_store()
            return store[get_repo_key()] or "origin/main"
          end

          local function set_default_branch(branch)
            local store = load_store()
            store[get_repo_key()] = branch
            save_store(store)
            vim.notify("Default branch set: " .. branch)
          end

          vim.system({ "git", "fetch", "--all", "--quiet" }):wait()
          local raw = vim.fn.systemlist("git branch -r --no-color")
          local branches = {}
          for _, b in ipairs(raw) do
            b = b:gsub("^%s+", ""):gsub("%s+$", "")
            if b ~= "" and not b:find("HEAD") then
              table.insert(branches, b)
            end
          end
          if #branches == 0 then
            vim.notify("No remote branches found", vim.log.levels.WARN)
            return
          end

          local function make_finder(default_branch)
            return finders.new_table({
              results = branches,
              entry_maker = function(b)
                local tag = (b == default_branch) and "  *default*" or ""
                return {
                  value = b,
                  display = b .. tag,
                  ordinal = b,
                }
              end,
            })
          end

          pickers
            .new({}, {
              prompt_title = "Target branch (<cr> diff  <c-d> set default)",
              layout_strategy = "vertical",
              finder = make_finder(get_default_branch()),
              sorter = conf.generic_sorter({}),
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  local branch = action_state.get_selected_entry().value
                  actions.close(prompt_bufnr)
                  vim.cmd("DiffviewOpen " .. branch)
                end)

                map("n", "q", actions.close)
                map("i", "<c-q>", actions.close)

                local function set_and_refresh()
                  local branch = action_state.get_selected_entry().value
                  set_default_branch(branch)
                  local picker = action_state.get_current_picker(prompt_bufnr)
                  picker:refresh(make_finder(branch), { reset_prompt = false })
                end

                map("i", "<c-d>", set_and_refresh)
                map("n", "<c-d>", set_and_refresh)

                return true
              end,
            })
            :find()
        end,
        desc = "Review diff (pick branch)",
      },
      {
        "<leader>gV",
        function()
          local store_path = vim.fn.stdpath("data") .. "/diffview_branches.json"
          local repo_key = (vim.system({ "git", "remote", "get-url", "origin" }, { text = true }):wait().stdout or ""):gsub(
            "%s+",
            ""
          )
          local branch = "origin/main"
          local f = io.open(store_path, "r")
          if f then
            local ok, data = pcall(vim.json.decode, f:read("*a"))
            f:close()
            if ok and data[repo_key] then
              branch = data[repo_key]
            end
          end
          vim.notify("Target branch: " .. branch)
          vim.cmd("DiffviewOpen " .. branch)
        end,
        desc = "Review diff (default branch)",
      },
    },
    opts = function()
      local actions = require("diffview.actions")

      return {
        view = {
          default = {
            layout = "diff2_horizontal",
          },
          file_history = {
            layout = "diff2_horizontal",
          },
        },
        file_panel = {
          win_config = {
            width = 50,
          },
        },
        file_history_panel = {
          win_config = {
            position = "left",
            width = 50,
          },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
            vim.keymap.set("n", "j", "gj", { buffer = bufnr, silent = true, desc = "Next Screen Line" })
            vim.keymap.set("n", "k", "gk", { buffer = bufnr, silent = true, desc = "Previous Screen Line" })
          end,
        },
        keymaps = {
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "下一个文件" } },
            { "n", "k", actions.prev_entry, { desc = "上一个文件" } },
            { "n", "<cr>", actions.select_entry, { desc = "打开文件 diff" } },
            { "n", "E", actions.goto_file_edit, { desc = "打开源文件" } },
            { "n", "s", actions.toggle_stage_entry, { desc = "stage/unstage" } },
            { "n", "S", actions.stage_all, { desc = "stage 全部" } },
            { "n", "U", actions.unstage_all, { desc = "unstage 全部" } },
            { "n", "X", actions.restore_entry, { desc = "discard 改动" } },
            { "n", "R", actions.refresh_files, { desc = "刷新" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "下一个文件" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "上一个文件" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "关闭" } },
          },
          view = {
            { "n", "]x", actions.next_conflict, { desc = "下一个冲突" } },
            { "n", "[x", actions.prev_conflict, { desc = "上一个冲突" } },
            { "n", "E", actions.goto_file_edit, { desc = "打开源文件" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "下一个文件" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "上一个文件" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "关闭" } },
          },
          file_history_panel = {
            { "n", "j", actions.next_entry, { desc = "下一条" } },
            { "n", "k", actions.prev_entry, { desc = "上一条" } },
            { "n", "<cr>", actions.select_entry, { desc = "查看这次 commit" } },
            { "n", "y", actions.copy_hash, { desc = "复制 commit hash" } },
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "关闭" } },
          },
        },
      }
    end,
  },
}
