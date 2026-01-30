-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
keymap.set("i", "jk", "<ESC>", { desc = "change to normal mode" })

-- VSCode specific keymaps when running in VSCode with Neovim
if vim.g.vscode then
  -- you can add keymaps in this place
  --Move
  -- keymap.set("n", "j", "<cmd>call VSCodeNotify('cursorDown')<CR>")
  -- keymap.set("n", "k", "<cmd>call VSCodeNotify('cursorUp')<CR>")

  -- Code navigation
  keymap.set("n", "gr", "<cmd>call VSCodeNotify('editor.action.goToReferences')<CR>")
  keymap.set("n", "gD", "<cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>")
  keymap.set("n", "gd", "<cmd>call VSCodeNotify('editor.action.goToDeclaration')<CR>")
  keymap.set("n", "gh", "<cmd>call VSCodeNotify('editor.action.peekDefinition')<CR>")
  keymap.set("n", "gH", "<cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>")
  keymap.set("n", "gi", "<cmd>call VSCodeNotify('editor.action.peekImplementation')<CR>")
  keymap.set("n", "gI", "<cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")
  keymap.set("n", "gX", "<cmd>call VSCodeNotify('revealFileInOS')<CR>")
  keymap.set("n", "<leader>sg", "<cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>")
  -- Explorer
  keymap.set(
    "n",
    "<leader>e",
    "<cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>",
    { desc = "Toggle file explorer" }
  )
  keymap.set(
    "n",
    "<leader>E",
    "<cmd>call VSCodeNotify('workbench.view.explorer')<CR>",
    { desc = "Toggle file explorer and focus" }
  )
  -- Code formatting
  keymap.set("n", "<leader>cf", "<cmd>call VSCodeNotify('editor.action.formatDocument')<CR>")

  -- Terminal
  keymap.set("n", "<leader>tt", "<cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>")

  -- bottom panel
  keymap.set(
    "n",
    "<leader>tc",
    '<cmd>call VSCodeNotify("workbench.action.closePanel")<CR>',
    { noremap = true, silent = true }
  )

  -- LSP actions
  keymap.set("n", "<leader>ca", "<cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
  keymap.set("n", "<leader>cr", "<cmd>call VSCodeNotify('editor.action.rename')<CR>")

  -- Run
  keymap.set("n", "<leader>rr", "<cmd>call VSCodeNotify('code-runner.run')<CR>", { desc = "Run code" })

  --Task
  keymap.set("n", "<leader>tr", "<cmd>call VSCodeNotify('workbench.action.tasks.runTask')<CR>", { desc = "Run task" })

  -- Debug
  keymap.set(
    "n",
    "<leader>da",
    "<cmd>call VSCodeNotify('workbench.action.debug.start')<CR>",
    { desc = "Debug: Start/Continue" }
  )
  keymap.set(
    "n",
    "<leader>dc",
    "<cmd>call VSCodeNotify('workbench.action.debug.continue')<CR>",
    { desc = "Debug: Continue" }
  )
  keymap.set(
    "n",
    "<leader>ds",
    "<cmd>call VSCodeNotify('workbench.action.debug.stepOver')<CR>",
    { desc = "Debug: Step Over" }
  )
  keymap.set(
    "n",
    "<leader>di",
    "<cmd>call VSCodeNotify('workbench.action.debug.stepInto')<CR>",
    { desc = "Debug: Step Into" }
  )
  keymap.set(
    "n",
    "<leader>do",
    "<cmd>call VSCodeNotify('workbench.action.debug.stepOut')<CR>",
    { desc = "Debug: Step Out" }
  )
  keymap.set(
    "n",
    "<leader>db",
    "<cmd>call VSCodeNotify('editor.debug.action.toggleBreakpoint')<CR>",
    { desc = "Debug: Toggle Breakpoint" }
  )
  keymap.set(
    "n",
    "<leader>dB",
    "<cmd>call VSCodeNotify('editor.debug.action.conditionalBreakpoint')<CR>",
    { desc = "Debug: Conditional Breakpoint" }
  )
  keymap.set("n", "<leader>dx", "<cmd>call VSCodeNotify('workbench.action.debug.stop')<CR>", { desc = "Debug: Stop" })
  keymap.set(
    "n",
    "<leader>dr",
    "<cmd>call VSCodeNotify('workbench.action.debug.restart')<CR>",
    { desc = "Debug: Restart" }
  )
  keymap.set(
    "n",
    "<leader>dd",
    "<cmd>call VSCodeNotify('workbench.action.debug.disconnect')<CR>",
    { desc = "Debug: Disconnect" }
  )
  keymap.set(
    "n",
    "<leader>dC",
    "<cmd>call VSCodeNotify('editor.debug.action.runToCursor')<CR>",
    { desc = "Debug: Run to Cursor" }
  )

  -- Debug Watch/Evaluate
  keymap.set(
    "n",
    "<leader>dwa",
    "<cmd>call VSCodeNotify('editor.debug.action.selectionToWatch')<CR>",
    { desc = "Debug: Watch word under cursor" }
  )
  keymap.set(
    "v",
    "<leader>dwa",
    "<cmd>call VSCodeNotify('editor.debug.action.selectionToWatch')<CR>",
    { desc = "Debug: Watch selection" }
  )
  keymap.set(
    "n",
    "<leader>dwp",
    "<cmd>call VSCodeNotify('workbench.debug.action.focusWatchView')<CR>",
    { desc = "Debug: Focus Watch view" }
  )
  keymap.set(
    "n",
    "<leader>dwr",
    "<cmd>call VSCodeNotify('workbench.debug.viewlet.action.removeAllWatchExpressions')<CR>",
    { desc = "Debug: Remove watch expression" }
  )
  keymap.set(
    "n",
    "<leader>dwc",
    "<cmd>call VSCodeNotify('workbench.debug.viewlet.action.removeAllWatchExpressions')<CR>",
    { desc = "Debug: Clear all watches" }
  )

  -- Quit
  keymap.set(
    "n",
    "<leader>qq",
    "<cmd>call VSCodeNotify('workbench.action.closeWindow')<CR>;<cmd>call VSCodeNotify('workbench.action.closeFolder')<CR>",
    { desc = "Quit window and close project" }
  )
  keymap.set("n", "<leader>qQ", "<cmd>call VSCodeNotify('workbench.action.quit')<CR>", { desc = "Quit VSCode" })

  -- Fold
  keymap.set("n", "zc", "<cmd>call VSCodeNotify('editor.fold')<CR>")
  keymap.set("n", "zo", "<cmd>call VSCodeNotify('editor.unfold')<CR>")
  keymap.set("n", "zC", "<cmd>call VSCodeNotify('editor.foldAll')<CR>")
  keymap.set("n", "zO", "<cmd>call VSCodeNotify('editor.unfoldAll')<CR>")

  local map = vim.keymap.set
  -- Git commands (communicating with VS Code's native functions)
  map("n", "<leader>gg", "<cmd>call VSCodeNotify('workbench.view.scm')<CR>", { desc = "Git Status (SCM View)" })
  map("n", "<leader>gl", "<cmd>call VSCodeNotify('git.viewHistory')<CR>", { desc = "Git Log (File History)" })
  map("n", "<leader>gb", "<cmd>call VSCodeNotify('git.checkout')<CR>", { desc = "Git Branches (Checkout)" })
  map("n", "<leader>gp", "<cmd>call VSCodeNotify('git.push')<CR>", { desc = "Git Push" })
  map("n", "<leader>gP", "<cmd>call VSCodeNotify('git.pull')<CR>", { desc = "Git Pull" })

  -- Hunk and file-specific commands
  map("v", "<leader>hs", "<cmd>call VSCodeNotify('git.stageSelectedRanges')<CR>", { desc = "Hunk Stage Selected" })
  map("v", "<leader>hr", "<cmd>call VSCodeNotify('git.unstageSelectedRanges')<CR>", { desc = "Hunk Reset Selected" })

  map("n", "<leader>hS", "<cmd>call VSCodeNotify('git.stage')<CR>", { desc = "Hunk Stage All (File)" })
  map("n", "<leader>hR", "<cmd>call VSCodeNotify('git.unstage')<CR>", { desc = "Hunk Reset All (File)" })

  map("n", "<leader>hp", "<cmd>call VSCodeNotify('git.openChange')<CR>", { desc = "Hunk Preview (File Diff)" })
  map("n", "<leader>hb", "<cmd>call VSCodeNotify('git.toggleBlame')<CR>", { desc = "Hunk Blame File" })
  map("n", "<leader>hB", "<cmd>call VSCodeNotify('git.toggleBlame')<CR>", { desc = "Hunk Blame File (Toggle)" })

  map("n", "<leader>hd", "<cmd>call VSCodeNotify('git.openChange')<CR>", { desc = "Hunk Diff vs. Index" })
  map(
    "n",
    "<leader>hD",
    "<cmd>call VSCodeNotify('git.viewHistory')<CR>",
    { desc = "Hunk Diff vs. Previous (Open History)" }
  )
  -- Buffer
  keymap.set(
    "n",
    "<leader>bd",
    "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>",
    { desc = "Close current buffer" }
  )
  keymap.set(
    "n",
    "<leader>bD",
    "<cmd>call VSCodeNotify('workbench.action.closeAllEditors')<CR>",
    { desc = "Close all buffers" }
  )

  -- window
  keymap.set(
    "n",
    "<leader>sw",
    "<cmd>call VSCodeNotify('workbench.action.switchWindow')<CR>",
    { desc = "Switch VS Code window" }
  )
end
