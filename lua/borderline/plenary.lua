---@mod borderline.plenary Borderline plenary implementation
local cache = require('borderline.cache')
local util = require('borderline.util')
local M = {}

local success, plenary_window_border = pcall(require, 'plenary.window.border')
if not success then
  return M
end

---@type BorderlineOptions
---@diagnostic disable-next-line: unused-local
local opts = {}

local orig = {
  new = plenary_window_border.new,
  move = plenary_window_border.move,
}

local borders = {}

M.standard_to_plenary_border = function(border_orig)
  local b = vim.tbl_deep_extend('force', {}, border_orig or util.border_styles().none)
  for idx, border in pairs(b) do
    if type(border) == 'table' and type(border[1] == 'string') then
      b[idx] = border[1]
    elseif type(border) ~= 'string' then
      b[idx] = ' '
    end
  end
  return { b[2], b[4], b[6], b[8], b[1], b[3], b[5], b[7] }
end

M.standard_to_plenary_border_map = function(b)
  local plenary_border = M.standard_to_plenary_border(b)
  if plenary_border == nil then
    return nil
  end
  local b_top, b_right, b_bot, b_left, b_topleft, b_topright, b_botright, b_botleft =
    unpack(plenary_border)
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

M.is_plenary_border_map = function(b)
  return type(b) == 'table'
    and (
      b.border_thickness
      or b.bot
      or b.botleft
      or b.botright
      or b.left
      or b.right
      or b.top
      or b.topleft
      or b.topright
    )
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
-- output: { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }
---@param b any
---@return table?
M.plenary_to_standard_border = function(b)
  if b == nil then
    return util.border_styles().none
  elseif type(b) ~= 'table' then
    vim.notify(
      'borderline.nvim: plenary border is not of type table' .. vim.inspect(b),
      vim.log.levels.ERROR,
      {}
    )
    return util.border_styles().none
  elseif M.is_plenary_border_map(b) then
    return { b.topleft, b.top, b.topright, b.right, b.botright, b.bot, b.botleft, b.left }
  elseif #b == 1 then
    return { b[1], b[1], b[1], b[1], b[1], b[1], b[1], b[1] }
  elseif #b == 2 then
    local b_char = b[1]
    local c_char = b[2]
    return M.plenary_to_standard_border({
      b_char,
      b_char,
      b_char,
      b_char,
      c_char,
      c_char,
      c_char,
      c_char,
    })
  elseif #b == 8 then
    return { b[5], b[1], b[6], b[2], b[7], b[3], b[8], b[4] }
  end
  vim.notify('borderline.nvim: unknown plenary border ' .. vim.inspect(b), vim.log.levels.ERROR, {})
  return util.border_styles().none
end

local plenary_border_override = function(borderchars, force)
  local standard_borderchars = M.plenary_to_standard_border(borderchars)
  local target_border = M.standard_to_plenary_border(
    util.override_border({ border = standard_borderchars }, force).border
  )
  return target_border
end

local get_border_opts = function(border_opts)
  border_opts = border_opts or {}
  -- if no border is defined, plenary defaults to double borderchars
  local default_borderchars =
    M.standard_to_plenary_border_map(util.override_border(util.border_styles().double))
  local borderchars =
    plenary_border_override(vim.tbl_deep_extend('force', border_opts, default_borderchars))
  local border_override =
    M.standard_to_plenary_border_map(M.plenary_to_standard_border(borderchars))
  return vim.tbl_deep_extend('force', border_opts, border_override)
end

local function set_border_cache(winid, border, border_opts)
  if winid then
    borders[winid] = border
    cache.plenary_had_border[winid] = util.has_border(M.plenary_to_standard_border(border_opts))
    cache.plenary_prev_title[winid] = border_opts.title
  end
end

local borderline_new = function(
  self,
  content_bufnr,
  content_win_id,
  content_win_options,
  border_win_options
)
  if not M.is_registered() then
    return orig.new(self, content_bufnr, content_win_id, content_win_options, border_win_options)
  end
  util.normalize_config()
  local border_opts = get_border_opts(border_win_options)
  local border = orig.new(self, content_bufnr, content_win_id, content_win_options, border_opts)
  set_border_cache(content_win_id, border, border_opts)
  return border
end

local borderline_move = function(self, content_win_options, border_win_options)
  if not M.is_registered() then
    return orig.move(self, content_win_options, border_win_options)
  end
  util.normalize_config()
  local border_opts = get_border_opts(border_win_options)
  orig.move(self, content_win_options, border_opts)
  set_border_cache(self.win_id, self, border_opts)
end

M.update_borders = function()
  if not M.is_registered() then
    return
  end
  util.normalize_config()
  for winid, plenary_border in pairs(borders) do
    local standard_border = M.plenary_to_standard_border(plenary_border._border_win_options)
    if cache.plenary_had_border[winid] == nil then
      cache.plenary_had_border[winid] = util.has_border(standard_border)
    end
    local border_override = plenary_border_override(
      M.standard_to_plenary_border(standard_border),
      cache.plenary_had_border[winid]
    )
    local standard_border_override = M.plenary_to_standard_border(border_override)

    local content_win_options = plenary_border.content_win_options
    content_win_options.noautocmd = nil

    local plenary_border_map = M.standard_to_plenary_border_map(standard_border_override)
    local border_win_options =
      vim.tbl_deep_extend('force', plenary_border._border_win_options, plenary_border_map)
    border_win_options.noautocmd = nil
    if util.has_title(standard_border_override) then
      if not border_win_options.title then
        border_win_options.title = cache.plenary_prev_title[winid]
        cache.plenary_prev_title[winid] = nil
      end
    else
      if border_win_options.title then
        cache.plenary_prev_title[winid] = border_win_options.title
      end
      border_win_options.title = nil
    end

    success, _ = pcall(plenary_border.move, plenary_border, content_win_options, border_win_options)
    if not success then
      vim.notify(
        'borderline.nvim: failed to update plenary border for winid ' .. winid,
        vim.log.levels.DEBUG,
        {}
      )
      borders[winid] = nil
    end
  end
end

local registered = nil

M.is_registered = function()
  return registered
end

M.register = function()
  plenary_window_border.new = borderline_new
  plenary_window_border.move = borderline_move
  registered = true
end

M.deregister = function()
  plenary_window_border.new = orig.new
  plenary_window_border.move = orig.move
  registered = false
end

M.setup = function(borderline_opts)
  ---@diagnostic disable-next-line: unused-local
  opts = borderline_opts
  M.register()
end

return M
