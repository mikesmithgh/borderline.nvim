local util = require('borderline.util')

local M = {}

---@type BorderlineOptions
local opts = {}

local orig = {}

local popups = {}

local override_nui_border = function(nui_border, force)
  local border = util.normalize_border(nui_border)
  if util.has_border(border) then
    border = util.override_border(util.normalize_border(opts.border), force)
  end
  return border
end

local borderline_setstyle = function(self, style, force)
  util.normalize_config()
  if not orig.set_style then
    vim.notify('borderline.nvim: could not find nui.popup.border.set_style()', vim.log.levels.ERROR, {})
    return
  end
  if style then
    style = override_nui_border(style, force)
  end
  orig.set_style(self, style)
end

M.update_borders = function()
  util.normalize_config()
  for winid, popup in pairs(popups) do
    if popup.border:get() or (popup.border._ and popup.border._.style) then
      local border_override = util.override_border({ border = popup.border._.style }, false).border
      local success, _ = pcall(popup.border.set_style, popup.border, border_override)
      if not success then
        popups[winid] = nil
      end
      success, _ = pcall(popup.update_layout, popup)
      if not success then
        popups[winid] = nil
      end
    end
  end
end

local borderline_mount = function(self, mount_fn)
  util.normalize_config()
  if not mount_fn then
    vim.notify('borderline.nvim: could not find nui.*.mount()', vim.log.levels.ERROR, {})
    return
  end
  if self.border:get() or (self.border._ and self.border._.style) then
    local border_override = util.override_border({ border = self.border._.style }, false).border
    self.border:set_style(border_override)
    -- self._.win_config.border = self.border:get()
    self:update_layout()
  end
  mount_fn(self)
  if self.winid then
    popups[self.winid] = self
  end
end

M.setup = function(borderline_opts)
  opts = borderline_opts
  local success_popup, nui_popup = pcall(require, 'nui.popup')
  local success_border, nui_border = pcall(require, 'nui.popup.border')
  if success_popup and success_border then
    orig.set_style = nui_border.set_style
    nui_border.set_style = borderline_setstyle
    orig.popup_mount = nui_popup.mount
    nui_popup.mount = function(self)
      borderline_mount(self, orig.popup_mount)
    end
  end
end

return M
