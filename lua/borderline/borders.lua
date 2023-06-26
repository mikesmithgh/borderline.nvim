local M = {
  undefined       = nil,
  none            = { '', '', '', '', '', '', '', '' }, -- '' turns off a border char
  double          = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  single          = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  shadow          = { '', '', { ' ', 'FloatShadowThrough' }, { ' ', 'FloatShadow' }, { ' ', 'FloatShadow' },
    { ' ', 'FloatShadow' }, { ' ', 'FloatShadowThrough' }, '' },
  rounded         = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  solid           = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  block           = { '▛', '▀', '▜', '▐', '▟', '▄', '▙', '▌' }, -- nui refers to this as solid
  inner_block     = { ' ', '▄', ' ', '▌', ' ', '▀', ' ', '▐' },
  thinblock       = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
  inner_thinblock = { ' ', '▁', ' ', '▏', ' ', '▔', ' ', '▕' },
  bullet          = { '•', '•', '•', '•', '•', '•', '•', '•' },
  star            = { '*', '*', '*', '*', '*', '*', '*', '*' },
  simple          = { '+', '-', '+', '|', '+', '-', '+', '|' },
  girder          = { '/', '=', '\\', '|', '/', '=', '\\', '|' },
  heavy_single    = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
  light_shade     = { '░', '░', '░', '░', '░', '░', '░', '░' },
  medium_shade    = { '▒', '▒', '▒', '▒', '▒', '▒', '▒', '▒' },
  dark_shade      = { '▓', '▓', '▓', '▓', '▓', '▓', '▓', '▓' },
  stick_figure    = { '🯇', '🯅', '🯈', '🯆', '🯈', '🯉', '🯇', '🯆' },
  vim             = { '', '', '', '', '', '', '', '' },
  arrow           = { '↗', '→', '↘', '↓', '↙', '←', '↖', '↑' },
}


-- ** start nui
-- local Text = require("nui.text")
--
-- local index_name = {
--   "top_left",
--   "top",
--   "top_right",
--   "right",
--   "bottom_right",
--   "bottom",
--   "bottom_left",
--   "left",
-- }
-- local function to_border_map(border)
--   local count = vim.tbl_count(border) --[[@as integer]]
--   if count < 8 then
--     -- fillup all 8 characters
--     for i = count + 1, 8 do
--       local fallback_index = i % count
--       local char = border[fallback_index == 0 and count or fallback_index]
--       if type(char) == "table" then
--         char = char.content and Text(char) or vim.deepcopy(char)
--       end
--       border[i] = char
--     end
--   end
--
--   local named_border = {}
--   for index, name in ipairs(index_name) do
--     named_border[name] = border[index]
--   end
--   return named_border
-- end
--
-- local nui_borders = {
--   double = to_border_map({ "╔", "═", "╗", "║", "╝", "═", "╚", "║" }),
--   none = "none",
--   rounded = to_border_map({ "╭", "─", "╮", "│", "╯", "─", "╰", "│" }),
--   shadow = "shadow",
--   single = to_border_map({ "┌", "─", "┐", "│", "┘", "─", "└", "│" }),
--   solid = to_border_map({ "▛", "▀", "▜", "▐", "▟", "▄", "▙", "▌" }),
-- }
-- ** end nui


return M
