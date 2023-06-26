local bl_borders = require('borderline.borders')
local bl_config = require('borderline.config')

local M = {}

---@type BorderlineOptions
local opts = {}

---@type BorderlineOptions?
M.initial_opts = nil

M.setup = function(borderline_opts)
  opts = borderline_opts
  if not initial_opts then
    M.initial_opts = vim.tbl_deep_extend("force", {}, borderline_opts)
  end
end

M.normalize_border = function(border)
  if border == nil then
    return bl_borders.undefined
  end
  if type(border) == 'boolean' then
    if border then
      border = bl_borders.rounded
    else
      border = bl_borders.none
    end
  end
  if type(border) == 'string' then
    local border_styles = M.border_styles()
    local border_tbl = border_styles[border]
    if border_tbl == nil then
      vim.notify('borderline.nvim: unknown border name ' .. border, vim.log.levels.ERROR, {})
      return bl_borders.undefined
    end
    border = border_tbl
  end
  if type(border) == 'table' and vim.tbl_islist(border) and next(border) == nil then
    border = bl_borders.none
  end
  return border
end

M.has_border = function(border)
  -- assumption: already normalized

  if type(border) == 'string' then
    return border ~= 'none'
  end

  if type(border) == 'table' and vim.tbl_islist(border) then
    local nonempty_chars = vim.tbl_filter(function(borderchar)
      return borderchar ~= nil and borderchar ~= '' -- and borderchar ~= ' '
    end, border)
    return next(border) ~= nil and #nonempty_chars > 0
  end

  -- TODO: nui map

  -- unknown format
  return nil
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

return M
