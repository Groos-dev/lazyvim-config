# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on the LazyVim starter template. It uses lazy.nvim for plugin management and extends LazyVim's defaults with custom configurations.

## Architecture

```
~/.config/nvim/
├── init.lua                    # Entry point, loads config.lazy
├── lua/
│   ├── config/
│   │   ├── lazy.lua            # lazy.nvim bootstrap and plugin setup
│   │   ├── options.lua         # Vim options (loaded before lazy.nvim)
│   │   ├── keymaps.lua         # Custom keymaps (loaded on VeryLazy)
│   │   └── autocmds.lua        # Custom autocommands (loaded on VeryLazy)
│   └── plugins/
│       └── *.lua               # Plugin specs (auto-imported by lazy.nvim)
```

### Load Order

1. `init.lua` → `config.lazy`
2. `config/options.lua` (before lazy.nvim startup)
3. LazyVim core plugins
4. All files in `lua/plugins/` (merged into plugin specs)
5. `config/keymaps.lua` and `config/autocmds.lua` (on VeryLazy event)

## Key Customizations

### Options (`lua/config/options.lua`)
- 4-space indentation (expandtab, shiftwidth=4, tabstop=4)
- Relative line numbers enabled

### Keymaps (`lua/config/keymaps.lua`)
- `jk` in insert mode → escape to normal mode
- Extensive VSCode-Neovim integration when `vim.g.vscode` is true (code navigation, debugging, git operations, folding)

### Autocmds (`lua/config/autocmds.lua`)
- Auto-save on InsertLeave and TextChanged events

## Adding/Modifying Plugins

Create or edit files in `lua/plugins/`. Each file should return a table of plugin specs:

```lua
return {
  -- Add a new plugin
  { "author/plugin-name" },

  -- Override LazyVim plugin options
  {
    "existing/plugin",
    opts = { ... },
  },

  -- Disable a LazyVim plugin
  { "plugin/to-disable", enabled = false },
}
```

## Commands

```bash
# Check Neovim health
nvim --headless "+checkhealth" "+qa"

# Open lazy.nvim UI (from within Neovim)
:Lazy

# Sync plugins
:Lazy sync

# Check for Lua syntax errors
luacheck lua/
```

## References

- LazyVim defaults: https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/config
- lazy.nvim plugin spec: https://lazy.folke.io/spec
