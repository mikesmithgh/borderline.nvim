---@mod borderline.borders Borderline Default Borders

-- border index position
-- 1 2 3
-- 8   4
-- 7 6 5

local M = {
  ---@type nil
  undefined = nil,
  ---@type table
  -- no border
  none = { '', '', '', '', '', '', '', '' },
  ---@type table
  -- ╔═══╗
  -- ║   ║
  -- ╚═══╝
  double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  ---@type table
  -- ┌───┐
  -- │   │
  -- └───┘
  single = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  ---@type table
  -- ```
  --     ░  where ░ is ' ' with highlight 'FloatShadowThrough'
  --     ▒    and ▒ is ' ' with highlight 'FloatShadow'
  -- ░▒▒▒▒
  -- ```
  shadow = {
    '',
    '',
    { ' ', 'FloatShadowThrough' },
    { ' ', 'FloatShadow' },
    { ' ', 'FloatShadow' },
    { ' ', 'FloatShadow' },
    { ' ', 'FloatShadowThrough' },
    '',
  },
  ---@type table
  -- ╭───╮
  -- │   │
  -- ╰───╯
  rounded = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  ---@type table
  -- █████ where █ is ' '
  -- █   █
  -- █████
  solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  ---@type table
  -- ▛▀▀▀▜
  -- ▌   ▐
  -- ▙▄▄▄▟
  -- ---
  -- nui refers to block as solid
  -- fzf-lua refers to block as thiccc
  block = { '▛', '▀', '▜', '▐', '▟', '▄', '▙', '▌' },
  ---@type table
  -- ▄▄▄
  -- ▌ ▐
  -- ▀▀▀
  inner_block = { ' ', '▄', ' ', '▌', ' ', '▀', ' ', '▐' },
  ---@type table
  -- 🭽▔▔▔🭾
  -- ▏   ▕
  -- 🭼▁▁▁🭿
  thinblock = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  ---@type table
  --  ▁▁▁
  -- ▕   ▏
  --  ▔▔▔
  inner_thinblock = { ' ', '▁', ' ', '▏', ' ', '▔', ' ', '▕' },
  ---@type table
  -- •••••
  -- •   •
  -- •••••
  bullet = { '•', '•', '•', '•', '•', '•', '•', '•' },
  ---@type table
  -- ```
  -- *****
  -- *   *
  -- *****
  -- ```
  star = { '*', '*', '*', '*', '*', '*', '*', '*' },
  ---@type table
  -- ```
  -- +---+
  -- |   |
  -- +---+
  -- ```
  simple = { '+', '-', '+', '|', '+', '-', '+', '|' },
  ---@type table
  -- ┏━━━┓
  -- ┃   ┃
  -- ┗━━━┛
  -- fzf-lua refers to heavy_single as thicc
  heavy_single = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
  ---@type table
  -- ░░░░░
  -- ░   ░
  -- ░░░░░
  light_shade = { '░', '░', '░', '░', '░', '░', '░', '░' },
  ---@type table
  -- ▒▒▒▒▒
  -- ▒   ▒
  -- ▒▒▒▒▒
  medium_shade = { '▒', '▒', '▒', '▒', '▒', '▒', '▒', '▒' },
  ---@type table
  -- ▓▓▓▓▓
  -- ▓   ▓
  -- ▓▓▓▓▓
  dark_shade = { '▓', '▓', '▓', '▓', '▓', '▓', '▓', '▓' },
  ---@type table
  -- ↗→→→↘
  -- ↓   ↑
  -- ↖←←←↙
  arrow = { '↗', '→', '↘', '↓', '↙', '←', '↖', '↑' },
  ---@type table
  -- █████
  -- █   █
  -- █████
  -- fzf-lua refers to full_block as thicccc
  full_block = { '█', '█', '█', '█', '█', '█', '█', '█' },
  ---@type table
  -- ┌───┐  where all characters are highlighted with the highlight `DiffText`
  -- │   │
  -- └───┘
  diff = {
    { '┌', 'DiffText' },
    { '─', 'DiffText' },
    { '┐', 'DiffText' },
    { '│', 'DiffText' },
    { '┘', 'DiffText' },
    { '─', 'DiffText' },
    { '└', 'DiffText' },
    { '│', 'DiffText' },
  },
}

return M
