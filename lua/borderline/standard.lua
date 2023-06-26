local util = require('borderline.util')

local M = {}

---@type BorderlineOptions
local opts = {}

local orig = {
  nvim_open_win = vim.api.nvim_open_win,
  nvim_win_set_config = vim.api.nvim_win_set_config,
  nvim_win_get_config = vim.api.nvim_win_get_config,
}

local borderline_nvim_open_win = function(buffer, enter, config)
  util.normalize_config()
  return orig.nvim_open_win(buffer, enter, util.override_border(config))
end

local borderline_nvim_win_set_config = function(window, config)
  util.normalize_config()
  return orig.nvim_win_set_config(window, util.override_border(config))
end

local borderline_nvim_win_get_config = function(window)
  util.normalize_config()
  local config = orig.nvim_win_get_config(window)
  local is_float = config ~= nil and (config.relative or "") ~= ""
  if is_float then
    return util.override_border(config)
  end
  return config
end

M.update_borders = function()
  local wins = vim.api.nvim_list_wins()
  for _, w in pairs(wins) do
    local winconfig = borderline_nvim_win_get_config(w)
    local is_float = winconfig and (winconfig.relative or "") ~= ""
    if winconfig and is_float then
      local c = util.override_border(winconfig, true)
      borderline_nvim_win_set_config(w, winconfig)
    end
  end
end

M.setup = function(borderline_opts)
  opts = borderline_opts
  vim.api.nvim_open_win = borderline_nvim_open_win
  vim.api.nvim_win_set_config = borderline_nvim_win_set_config
  vim.api.nvim_win_get_config = borderline_nvim_win_get_config
end

return M
