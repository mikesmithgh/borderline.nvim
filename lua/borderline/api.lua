---@mod borderline.api Borderline API

local M = {}
local bl_util = require('borderline.util')
local bl_standard = require('borderline.standard')
local bl_fzflua = require('borderline.fzf-lua')
local bl_plenary = require('borderline.plenary')
local bl_nui = require('borderline.nui')

---@type BorderlineOptions
local opts = {} ---@diagnostic disable-line: unused-local

---@tag borderline.api.setup
---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts ---@diagnostic disable-line: unused-local
end

---@tag borderline.api.borderline
M.borderline = function(border)
  local new_border = bl_util.normalize_border(border)
  opts.border = new_border ---@diagnostic disable-line: unused-local
  bl_standard.update_borders()
  if bl_fzflua.update_borders then
    bl_fzflua.update_borders()
  end
  if bl_plenary.update_borders then
    bl_plenary.update_borders()
  end
  if bl_nui.update_borders then
    bl_nui.update_borders()
  end
end

local register_fns = {
  nvim = bl_standard.register,
  fzflua = bl_fzflua.register,
  nui = bl_nui.register,
  plenary = bl_plenary.register,
}

M.register_keys = function()
  return vim.tbl_keys(register_fns)
end

M.register = function(name)
  if name and name ~= '' then
    local register_fn = register_fns[name]
    if register_fn then
      register_fn()
    else
      vim.notify('borderline.nvim: cannot register invalid type ' .. name, vim.log.levels.ERROR, {})
    end
  else
    for _, key in pairs(M.register_keys()) do
      register_fns[key]()
    end
  end
end

local deregister_fns = {
  nvim = bl_standard.deregister,
  fzflua = bl_fzflua.deregister,
  nui = bl_nui.deregister,
  plenary = bl_plenary.deregister,
}

M.deregister_keys = function()
  return vim.tbl_keys(deregister_fns)
end

M.deregister = function(name)
  if name and name ~= '' then
    local deregister_fn = deregister_fns[name]
    if deregister_fn then
      deregister_fn()
    else
      vim.notify('borderline.nvim: cannot deregister invalid type ' .. name, vim.log.levels.ERROR, {})
    end
  else
    for _, key in pairs(M.deregister_keys()) do
      deregister_fns[key]()
    end
  end
end

return M
