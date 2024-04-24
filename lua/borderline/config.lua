---@mod borderline.config Borderline Configuration

local bl_borders = require('borderline.borders')

local M = {}

---Configuration options to modify behavior of borderline.nvim
---@class BorderlineOptions
---@field enabled boolean|nil if true, override borders
---@field border table|nil default border
---@field border_styles table|nil user defined border styles
---@field dev_mode boolean|nil if true, enables dev features
local standard_opts = {
  enabled = true,
  border = bl_borders.rounded,
  border_styles = {},
  dev_mode = false,
}

---@return BorderlineOptions
M.default_opts = function()
  return vim.tbl_deep_extend('force', {}, standard_opts)
end

---@type BorderlineOptions
M.opts = {}

return M
