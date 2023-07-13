---@mod borderline.standard Borderline standard nvim implementation
local util = require('borderline.util')
local cache = require('borderline.cache')

local M = {}

---@type BorderlineOptions
local opts = {} ---@diagnostic disable: unused-local

local orig = {
  nvim_open_win = vim.api.nvim_open_win,
  nvim_win_set_config = vim.api.nvim_win_set_config,
  nvim_win_get_config = vim.api.nvim_win_get_config,
}

local function is_float(winopts)
  return winopts and (winopts.relative or "") ~= ""
end

local borderline_nvim_open_win = function(buffer, enter, winopts)
  if not M.is_registered() then
    return orig.nvim_open_win(buffer, enter, winopts)
  end
  if not is_float(winopts) then
    return orig.nvim_open_win(buffer, enter, winopts)
  end
  util.normalize_config()
  return orig.nvim_open_win(buffer, enter, util.override_border(winopts))
end

local borderline_nvim_win_set_config = function(winid, winopts)
  if not M.is_registered() or not is_float(winopts) then
    return orig.nvim_win_set_config(winid, winopts)
  end
  util.normalize_config()
  if cache.nvim_had_border[winid] == nil then
    cache.nvim_had_border[winid] = util.has_border(winopts.border)
    if not cache.nvim_had_border[winid] then
      winopts.border = util.border_styles().none
    end
  end
  return orig.nvim_win_set_config(winid, util.override_border(winopts, cache.nvim_had_border[winid]))
end

local borderline_nvim_win_get_config = function(window)
  local winopts = orig.nvim_win_get_config(window)
  if not M.is_registered() or not is_float(winopts) then
    return winopts
  end
  util.normalize_config()
  return util.override_border(winopts)
end

M.update_borders = function()
  if not M.is_registered() then
    return
  end
  local wins = vim.api.nvim_list_wins()
  for _, w in pairs(wins) do
    local winopts = vim.api.nvim_win_get_config(w)
    if is_float(winopts) then
      vim.api.nvim_win_set_config(w, winopts)
    end
  end
end

local registered = nil

M.is_registered = function()
  return registered
end

M.register = function()
  vim.api.nvim_open_win = borderline_nvim_open_win
  vim.api.nvim_win_set_config = borderline_nvim_win_set_config
  vim.api.nvim_win_get_config = borderline_nvim_win_get_config
  registered = true
end

M.deregister = function()
  vim.api.nvim_open_win = orig.nvim_open_win
  vim.api.nvim_win_set_config = orig.nvim_win_set_config
  vim.api.nvim_win_get_config = orig.nvim_win_get_config
  registered = false
end

M.setup = function(borderline_opts)
  opts = borderline_opts
  M.register()
end


return M
