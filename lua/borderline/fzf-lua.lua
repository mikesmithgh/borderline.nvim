local util = require('borderline.util')

local M = {}

---@type BorderlineOptions
M.opts = {}

local orig = {}

local _self = nil

local set_winopts = function(self, force)
  if self and self.winopts then
    self.winopts = util.override_border(self.winopts, force)
    self.winopts._border = self.winopts.border
    self.winopts.nohl_borderchars = self.winopts.border
    self._o.winopts.border = self.winopts.border
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
  if not orig.new then
    vim.notify('borderline.nvim: could not find fzf-lua.win.new()', vim.log.levels.ERROR, {})
    return
  end
  self = orig.new(self, o)
  set_winopts(self)
  self._self = self
  _self = self
  return self
end

M.update_borders = function()
  if _self then
    set_winopts(_self, true)
    _self:redraw()
  end
end

M.setup = function(borderline_opts)
  M.opts = borderline_opts
  local success, fzflua_win = pcall(require, 'fzf-lua.win')
  if success then
    orig.new = fzflua_win.new
    fzflua_win.new = borderline_new
  end
end

return M
