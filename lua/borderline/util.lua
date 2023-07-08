---@mod borderline.util Borderline utility functions
local bl_borders = require('borderline.borders')
local bl_config = require('borderline.config')

local M = {}

---@type BorderlineOptions
local opts = {}

---@type BorderlineOptions?
M.initial_opts = nil

M.setup = function(borderline_opts)
  opts = borderline_opts
  if not M.initial_opts then
    M.initial_opts = vim.tbl_deep_extend("force", {}, borderline_opts)
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
    local stripped_border = M.strip_border(border)
    local nonempty_chars = vim.tbl_filter(function(borderchar)
      return borderchar ~= nil and borderchar ~= '' -- and borderchar ~= ' '
    end, stripped_border)
    return #nonempty_chars > 0
  end

  -- unknown format
  vim.notify("borderline.nvim unknown border format", vim.log.levels.WARN, {})
  return nil
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

M.strip_border = function(border)
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
        vim.notify('borderline.nvim: cannot string border of type string ' .. b, vim.log.levels.ERROR, {})
        stripped_border[idx] = nil
      end
    end

    return stripped_border
  end
  return border
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
      return target_border_style
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
      return target_border_style
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
  border_next_timer = vim.fn.timer_start(time, function()
    local next_border = M.border_next()
    callback(next_border)
  end, {
    ['repeat'] = -1,
  })
end

return M
