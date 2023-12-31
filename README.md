<!-- panvimdoc-ignore-start -->

<img src="https://github.com/mikesmithgh/borderline.nvim/assets/10135646/04153c58-5113-45d7-987b-c9a0130ff21a" alt="borderlinesquirrel" style="width: 25%" align="right" />

<!-- panvimdoc-ignore-end -->

# 🔳 borderline.nvim
Neovim plugin to globally define border style for all floating windows (see `:h api-floatwin`).

<!-- panvimdoc-ignore-start -->
[![neovim: v0.9+](https://img.shields.io/static/v1?style=for-the-badge&label=neovim&message=v0.9%2b&logo=neovim&labelColor=282828&logoColor=8faa80&color=414b32)](https://neovim.io/)

:shipit::warning::shipit: This project is still a work in progress and not considered stable :shipit::warning::shipit:


https://github.com/mikesmithgh/borderline.nvim/assets/10135646/da91139e-4031-471b-97b2-02c6e43b674e


<!-- panvimdoc-ignore-end -->

## 🤔 Motivation
Configuring floating window border styles is a per window configuration (see `:h nvim_open_win()`). Depending on plugin usage,
window options to configure borders may or may not be exposed. In addition, there are alternate ways of rendering a border depending
on the underlying implementation. Alternative methods of providing a border include:

- Drawing the border characters directly in the buffer
- Creating a separate floating window positioned behind the primary window and adding the border to the backmost window.
- Creating a separate floating window positioned behind the primary window and drawing the border characters directly to the backmost window.

Handling all of these scenarios can be difficult and time consuming. borderline.nvim is a solution to provide an easy to configure and
consistent border to all floating windows.

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
 {
  'mikesmithgh/borderline.nvim',
  enabled = true,
  lazy = true,
  event = 'VeryLazy',
  config = function()
    require('borderline').setup({
        --  ...
    })
  end,
 }
```

### Using Neovim's built-in package support [pack](https://neovim.io/doc/user/usr_05.html#05.4)
```bash
mkdir -p "$HOME/.local/share/nvim/site/pack/mikesmithgh/start/"
cd $HOME/.local/share/nvim/site/pack/mikesmithgh/start
git clone git@github.com:mikesmithgh/borderline.nvim.git
nvim -u NONE -c "helptags borderline.nvim/doc" -c q
mkdir -p "$HOME/.config/nvim"
echo "require('borderline').setup()" >> "$HOME/.config/nvim/init.lua" 
```

## 🫡 Commands and Lua API
| Command                        | API                                                        | Description                                                             |
| ----------------------------   | ---------------------------------------------------------- | ----------------------------------------------------------------------- |
| `:Borderline {bordername}`     | `require('borderline.api').borderline(string\|table\|nil)` |                                                                         |
| `:BorderlineNext`              | n/a                                                        |                                                                         |
| `:BorderlinePrevious`          | n/a                                                        |                                                                         |
| `:BorderlineStartNextTimer`    | n/a                                                        |                                                                         |
| `:BorderlineStopNextTimer`     | n/a                                                        |                                                                         |
| `:BorderlineRegister {name}`   | `require('borderline.api').register(string\|nil)`          |                                                                         |
| `:BorderlineDeregister {name}` | `require('borderline.api').deregister(string\|nil)`        |                                                                         |
| `:BorderlineInfo`              | `require('borderline.api').info()`                         |                                                                         |
| `:BorderlineDev`               | n/a                                                        |                                                                         |

<!-- panvimdoc-ignore-start -->
<!-- [![neovim: nightly](https://img.shields.io/static/v1?style=for-the-badge&label=neovim&message=nightly&logo=neovim&labelColor=282828&logoColor=8faa80&color=414b32)](https://neovim.io/) -->
<!-- [![last commit](https://img.shields.io/github/last-commit/mikesmithgh/gruvsquirrel.nvim?style=for-the-badge&logo=git&labelColor=282828&logoColor=ff6961&color=ff6961)](https://github.com/mikesmithgh/gruvsquirrel/pulse) -->
<!-- [![semantic-release: angular](https://img.shields.io/static/v1?style=for-the-badge&label=semantic-release&message=angular&logo=semantic-release&labelColor=282828&logoColor=d8869b&color=8f3f71)](https://github.com/semantic-release/semantic-release) -->

<!-- panvimdoc-ignore-end -->

## 🤝 Ackowledgements
- [nui.vnim](https://github.com/MunifTanjim/nui.nvim)
- [plenary.vnim](https://github.com/nvim-lua/plenary.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- 🐿️ [gruvsquirrel.nvim](https://github.com/mikesmithgh/gruvsquirrel.nvim) Neovim colorscheme written in Lua inspired by gruvbox
