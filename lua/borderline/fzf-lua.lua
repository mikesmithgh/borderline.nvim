---@mod borderline.fzf-lua Borderline fzf-lua implementation
local util = require('borderline.util')
local cache = require('borderline.cache')

local M = {}


local success, fzflua_win = pcall(require, 'fzf-lua.win')
if not success then
  return M
end

---@type BorderlineOptions
M.opts = {}

local orig = {
  new = fzflua_win.new
}

local _self = nil

local set_winopts = function(self, force)
  util.normalize_config()
  if not M.is_registered() then
    return
  end
  if self and self.winopts then
    self.winopts = vim.tbl_deep_extend("force", self.winopts, util.override_border(self.winopts, force))
    self.winopts._border = self.winopts.border
    self.winopts.nohl_borderchars = util.strip_border_hl(self.winopts.border)
    self._o.winopts = self.winopts
    if self.winopts_fn then
      self.winopts_fn = function() util.override_border(self.winopts_fn(), force) end
      self._o.winopts_fn = self.winopts_fn
    end
    if self.winopts_raw then
      self.winopts_raw = function() util.override_border(self.winopts_raw(), force) end
      self._o.winopts_raw = self.winopts_raw
    end
  end
end

local borderline_new = function(self, o)
  util.normalize_config()
  self = orig.new(self, o)
  set_winopts(self)
  self._self = self
  _self = self
  vim.schedule(M.update_borders)
  return self
end

M.update_borders = function()
  if not M.is_registered() then
    return
  end
  if _self then
    _self:redraw()
    local winid = _self.border_winid
    if winid and cache.fzflua_had_border[winid] == nil then
      cache.fzflua_had_border[winid] = util.has_border(_self.winopts.border)
    end
    set_winopts(_self, cache.fzflua_had_border[winid])
    _self:redraw()
  end
end

local registered = nil

M.is_registered = function()
  return registered
end

M.register = function()
  fzflua_win.new = borderline_new
  registered = true
end

M.deregister = function()
  fzflua_win.new = orig.new
  registered = false
end

M.setup = function(borderline_opts)
  M.opts = borderline_opts
  M.register()
end

return M
