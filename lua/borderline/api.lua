---@mod borderline.api Borderline API

local M = {}
local bl_util = require('borderline.util')
local bl_standard = require('borderline.standard')
local bl_fzflua = require('borderline.fzf-lua')
local bl_plenary = require('borderline.plenary')
local bl_nui = require('borderline.nui')

---@type BorderlineOptions
local opts = {}

---@tag borderline.api.setup
---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts
end

---@tag borderline.api.borderline
M.borderline = function(border)
  local new_border = bl_util.normalize_border(border)
  if new_border then
    opts.border = new_border
    bl_standard.update_borders()
    bl_fzflua.update_borders()
    bl_plenary.update_borders()
    bl_nui.update_borders()
  end
end

return M
