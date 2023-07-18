---@mod borderline.util Borderline utility functions
local bl_borders = require('borderline.borders')
local bl_config = require('borderline.config')

local M = {}

---@type BorderlineOptions
local opts = {}

---@type BorderlineOptions?
M.initial_opts = nil

M.current_border_name = nil
M.initial_border_name = nil

M.setup = function(borderline_opts)
  opts = borderline_opts
  if not M.initial_opts then
    M.initial_opts = vim.tbl_deep_extend("force", {}, borderline_opts)
    if type(opts.border) == 'string' then
      M.current_border_name = opts.border
      M.initial_border_name = opts.border
    end
  end
end

M.normalize_border = function(border)
  if not border then
    return M.border_styles().none
  end
  if type(border) == 'boolean' then
    if border then
      border = M.border_styles().rounded
    else
      border = M.border_styles().none
    end
  end
  if type(border) == 'string' then
    local border_styles = M.border_styles()
    local border_tbl = border_styles[border]
    if border_tbl == nil then
      vim.notify('borderline.nvim: unknown border name ' .. border, vim.log.levels.ERROR, {})
      return M.border_styles().undefined
    end
    border = border_tbl
  end
  if type(border) == 'table' and vim.tbl_islist(border) and not next(border) then
    border = M.border_styles().none
  end
  return border
end

M.has_border = function(border)
  -- assumption: already normalized

  if not border then
    return false
  end

  if type(border) == 'string' then
    return border ~= 'none'
  end

  if type(border) == 'table' then
    local stripped_border = M.strip_border_hl(border)
    local nonempty_chars = vim.tbl_filter(function(borderchar)
      return borderchar ~= nil and borderchar ~= '' -- and borderchar ~= ' '
    end, stripped_border)
    return #nonempty_chars > 0
  end

  -- unknown format
  vim.notify("borderline.nvim unknown border format", vim.log.levels.WARN, {})
  return false
end

-- check if has border and if has top title
M.has_title = function(border)
  if M.has_border(border) then
    local title_border = border[2]

    if title_border and type(title_border) == 'string' then
      return title_border ~= ''
    end

    if title_border and type(title_border) == 'table' then
      return title_border[1] ~= ''
    end
  end
  return false
end

M.strip_border_hl = function(border)
  if type(border) == 'table' then
    if not next(border) then
      return {}
    end
    -- remove highlights
    local stripped_border = vim.tbl_deep_extend("force", {}, border)
    for idx, b in pairs(border) do
      if type(b) == 'table' and type(b[1] == 'string') then
        stripped_border[idx] = b[1]
      elseif type(b) ~= 'string' then
        vim.notify('borderline.nvim: cannot strip border of type string ' .. b, vim.log.levels.ERROR, {})
        stripped_border[idx] = nil
      end
    end

    return stripped_border
  end
  return border
end

-- TODO: determine if I want to implement keeping empty border characters
---@diagnostic disable-next-line: unused-local
local replace_border_nonempty = function(border, target_border)
  local function is_empty(str)
    return not str or (str == '' or str == ' ')
  end
  local new_border = vim.tbl_deep_extend("force", {}, target_border)
  if type(border) == 'table' then
    if not next(border) then
      return M.border_styles().none
    end
    for idx, b in pairs(border) do
      if type(b) == 'table' and type(b[1] == 'string') then
        if is_empty(b[1]) then
          local new_b = new_border[idx]
          if type(new_b) == 'table' and type(new_b[1] == 'string') then
            new_b[1] = b[1]
          else
            new_border[idx] = b[1]
          end
        end
      elseif type(b) == 'string' then
        if is_empty(b) then
          local new_b = new_border[idx]
          if type(new_b) == 'table' and type(new_b[1] == 'string') then
            new_b[1] = b
          else
            new_border[idx] = b
          end
        end
      end
    end
  else
    vim.notify('borderline.nvim: cannot replace border not of type table ' .. border, vim.log.levels.ERROR, {})
  end
  return new_border
end

M.normalize_config = function()
  bl_config.border = M.normalize_border(bl_config.border)
end

M.override_border = function(config, force)
  if config == nil then
    return nil
  end
  local c = vim.tbl_deep_extend("force", {}, config or {})
  local border = M.normalize_border(c.border)
  if opts.enabled then
    local should_override_boulder = force or M.has_border(border)
    if should_override_boulder then
      c.border = M.normalize_border(opts.border)
    end
  else
    c.border = border
  end
  return c
end

M.border_styles = function()
  return vim.tbl_extend("force", bl_borders, opts.border_styles)
end

M.border_style_names = function()
  local sorted_names = {}
  for name in pairs(M.border_styles()) do
    table.insert(sorted_names, name)
  end
  table.sort(sorted_names)

  return sorted_names
end


local cur_border_idx = nil


M.border_next = function()
  local names = M.border_style_names()
  if not names or next(names) == nil then
    return
  end
  local no_cur_border_idx = not cur_border_idx
  if no_cur_border_idx or cur_border_idx > #names then
    cur_border_idx = 1
  else
    cur_border_idx = cur_border_idx + 1
  end
  local target_border_name = names[cur_border_idx]
  local border_styles = M.border_styles()
  local target_border_style = border_styles[target_border_name]
  local config_border = opts.border
  if type(opts.border) == 'string' then
    config_border = border_styles[opts.border]
  end
  if target_border_style then
    if not no_cur_border_idx or (no_cur_border_idx and table.concat(vim.tbl_flatten(target_border_style)) ~= table.concat(vim.tbl_flatten(config_border))) then
      return target_border_style, target_border_name
    end
  end
  return M.border_next()
end

M.border_previous = function()
  local names = M.border_style_names()
  if not names or next(names) == nil then
    return
  end
  local no_cur_border_idx = not cur_border_idx
  if no_cur_border_idx or cur_border_idx < 1 then
    cur_border_idx = #names
  else
    cur_border_idx = cur_border_idx - 1
  end
  local target_border_name = names[cur_border_idx]
  local border_styles = M.border_styles()
  local target_border_style = border_styles[target_border_name]
  local config_border = opts.border
  if type(opts.border) == 'string' then
    config_border = border_styles[opts.border]
  end
  if target_border_style then
    if not no_cur_border_idx or (no_cur_border_idx and table.concat(target_border_style) ~= table.concat(config_border)) then
      return target_border_style, target_border_name
    end
  end
  return M.border_previous()
end

local border_next_timer = nil

M.border_next_timer_stop = function()
  if border_next_timer then
    vim.fn.timer_stop(border_next_timer)
    border_next_timer = nil
  end
end

M.border_next_timer_start = function(time, callback)
  M.border_next_timer_stop()
  if not time then
    time = 1000
  end
  border_next_timer = vim.fn.timer_start(time, function()
    local next_border, next_border_name = M.border_next()
    callback(next_border, next_border_name)
  end, {
    ['repeat'] = -1,
  })
end

-- copied from lazy.nvim
M.center_window_options = function(width, height, columns, lines)
  local function size(max, value)
    return value > 1 and math.min(value, max) or math.floor(max * value)
  end
  return {
    width = size(columns, width),
    height = size(lines, height),
    row = math.floor((lines - height) / 2),
    col = math.floor((columns - width) / 2),
  }
end

M.border_tbl_to_map = function(border_tbl)
  local border_map = {}
  for i, b in pairs(border_tbl) do
    local i_str = tostring(i)
    border_map[i_str] = b
    if type(b) == 'table' then
      border_map[i_str] = M.border_tbl_to_map(b)
    end
  end
  return border_map
end

return M
