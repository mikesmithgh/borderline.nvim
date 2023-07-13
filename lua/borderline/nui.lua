---@mod borderline.nui Borderline nui implementation
local util = require('borderline.util')
local cache = require('borderline.cache')
local M = {}

local success, nui_popup = pcall(require, 'nui.popup')
if not success then
  return M
end
local nui_border = require('nui.popup.border')

---@type BorderlineOptions
---@diagnostic disable-next-line: unused-local
local opts = {}

local orig = {
  set_style = nui_border.set_style,
  popup_mount = nui_popup.mount
}

local popups = {}

local override_nui_border = function(border, force)
  -- assume normalized
  return util.override_border({ border = border }, force)
end

local borderline_setstyle = function(self, style, force)
  util.normalize_config()
  local border = util.normalize_border(style)
  style = override_nui_border(border, force)
  orig.set_style(self, border)
end

M.update_borders = function()
  if not M.is_registered() then
    return
  end
  util.normalize_config()
  for winid, popup in pairs(popups) do
    if popup.border._ and popup.border._.style and popup.border.winid then
      if cache.nui_had_border[winid] == nil then
        cache.nui_had_border[winid] = util.has_border(popup.border._.style)
      end
      local border_override = util.override_border({ border = popup.border._.style }, cache.nui_had_border[winid])
          .border
      success, _ = pcall(nui_border.set_style, popup.border, border_override, cache.nui_had_border[winid])
      if not success then
        vim.notify('borderline.nvim: failed to set nui style for winid ' .. winid, vim.log.levels.ERROR, {})
      end
      success, _ = pcall(nui_popup.update_layout, popup)
      if not success then
        vim.notify('borderline.nvim: failed to update nui layout for winid ' .. winid, vim.log.levels.ERROR, {})
      end
    end
  end
end

local borderline_mount = function(self, mount_fn)
  util.normalize_config()
  if not M.is_registered() then
    nui_popup.update_layout(self)
    mount_fn(self)
    return
  end

  if not mount_fn then
    vim.notify('borderline.nvim: could not find nui.*.mount()', vim.log.levels.ERROR, {})
    return
  end
  local has_border = false

  local border_internal = self.border._
  if border_internal.style then
    has_border = util.has_border(border_internal.style)
    local border_override = util.override_border(
      { border = border_internal.style }, has_border
    ).border
    nui_border.set_style(self.border, border_override, has_border)
    nui_popup.update_layout(self)
  end

  mount_fn(self)

  if self.winid then
    popups[self.winid] = self
    if cache.nui_had_border[self.winid] == nil then
      cache.nui_had_border[self.winid] = util.has_border(self.border._.style)
    end
  end
end

local registered = nil

M.is_registered = function()
  return registered
end

M.register = function()
  nui_border.set_style = borderline_setstyle
  nui_popup.mount = function(self)
    borderline_mount(self, orig.popup_mount)
  end
  registered = true
end

M.deregister = function()
  nui_border.set_style = orig.set_style
  nui_popup.mount = orig.popup_mount
  registered = false
end

M.setup = function(borderline_opts)
  ---@diagnostic disable-next-line: unused-local
  opts = borderline_opts
  M.register()
end

return M
