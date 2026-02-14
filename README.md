# highlighter.nvim

A lightweight, no-nonsense Neovim plugin to highlight `TODO`, `FIXME`, and `NOTE` comments.

## Features

*   **Lightweight**: Under 100 lines of code.
*   **Zero dependencies**: Written in pure Lua.
*   **Customizable**: Easily toggle highlights or change colors on the fly.
*   **Automatic**: Highlights are applied automatically when you open or enter a buffer.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "paullotz/highlighter.nvim",
  config = function()
    require("highlighter").setup()
  end,
}
```

## Usage

The plugin works automatically out of the box.

### Commands

*   `:TodoHighlightToggle` - Enable or disable the highlighting.
*   `:TodoHighlightSetColors <todo_color> <fixme_color> <note_color>` - Set custom hex colors for the highlights.
    *   Example: `:TodoHighlightSetColors #ff0000 #00ff00 #0000ff`
