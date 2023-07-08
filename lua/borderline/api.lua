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

return M
