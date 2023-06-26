local util = require "borderline.util"
local M = {}

---@type BorderlineOptions
local opts = {}

local orig = {}

local popups = {}

M.standard_to_plenary_border = function(b)
  if b == nil then
    return nil
  end
  return { b[2], b[4], b[6], b[8], b[1], b[3], b[5], b[7] }
end

M.standard_to_plenary_border_map = function(b)
  local plenary_border = M.standard_to_plenary_border(b)
  if plenary_border == nil then
    return nil
  end
  local b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft = unpack(plenary_border)
  return {
    top = b_top,
    bot = b_bot,
    right = b_right,
    left = b_left,
    topleft = b_topleft,
    topright = b_topright,
    botright = b_botright,
    botleft = b_botleft,
  }
end

-- input:  { "═", "║", "═", "║", "╔", "╗", "╝", "╚" }
--           [1]  [2]  [3]  [4]  [5]  [6]  [7]  [8]
--            │    │    │    │    │    │    │    │
--            │    │    │    └────┼────┼─┐  │    │
--            │    │    └─────────┼──┐ │ │  │    │
--            │    └─────────┐  ┌─┘  │ │ │  │    │
--            └────┐         │  │ ┌──┼─┼─┼──┘    │
--            ┌────┼─────────┼──┘ │  │ │ │  ┌────┘
--            │    │    ┌────┼────┼──┼─┘ └──┼────┐
--            │    │    │    │    │  └─┐    │    │
--            ▼    ▼    ▼    ▼    ▼    ▼    ▼    ▼
--           [5]  [1]  [6]  [2]  [7]  [3]  [8]  [4]
-- output: { "╔", "═", "╗", "║", "╝", "╗", "═", "║" }
---@param b any
---@return table?
M.plenary_to_standard_border = function(b)
  if b == nil then
    return nil
  elseif #b == 1 then
    return { b[1], b[1], b[1], b[1], b[1], b[1], b[1], b[1], }
  elseif #b == 2 then
    local b_char = b[1]
    local c_char = b[2]
    return M.plenary_to_standard_border({ b_char, b_char, b_char, b_char, c_char, c_char, c_char, c_char, })
  elseif #b == 8 then
    return { b[5], b[1], b[6], b[2], b[7], b[3], b[8], b[4], }
  end
  vim.notify('borderline.nvim: unknown plenary border ' .. b, vim.log.levels.ERROR, {})
  return nil
end

local plenary_border_override = function(borderchars)
  local standard_borderchars = M.plenary_to_standard_border(borderchars)
  local target_border = M.standard_to_plenary_border(
    util.override_border({ border = standard_borderchars }).border
  )
  return target_border
end


local borderline_create = function(what, vim_options)
  util.normalize_config()
  if not orig.create then
    vim.notify('borderline.nvim: could not find plenary.popup.create()', vim.log.levels.ERROR, {})
    return
  end
  if vim_options.borderchars then
    local border_override = plenary_border_override(vim_options.borderchars)
    vim_options.borderchars = border_override
  end
  local winid, popup = orig.create(what, vim_options)
  popups[winid] = popup
  return winid, popup
end


M.setup = function(borderline_opts)
  opts = borderline_opts
  local success, plenary_popup = pcall(require, 'plenary.popup')
  if success then
    orig.create = plenary_popup.create
    plenary_popup.create = borderline_create
  end
end


M.update_borders = function()
  for winid, popup in pairs(popups) do
    local plenary_border = popup.border

    local content_win_options = plenary_border.content_win_options
    content_win_options.noautocmd = nil

    local plenary_border_map = M.standard_to_plenary_border_map(opts.border)
    local border_win_options = vim.tbl_deep_extend("force", plenary_border._border_win_options, plenary_border_map)
    border_win_options.noautocmd = nil

    local success, error = pcall(plenary_border.move, plenary_border, content_win_options, border_win_options)
    if not success then
      popups[winid] = nil
    end
  end
end

return M





--- left here, TODO: add validation for formats that don't match plenary
