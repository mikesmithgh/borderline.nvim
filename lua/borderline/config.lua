---@mod borderline.config Borderline Configuration

local bl_borders = require('borderline.borders')

local M = {}

---Configuration options to modify behavior of borderline.nvim
---@class BorderlineOptions
---@field enabled boolean if true, override borders
---@field border table default border
---@field border_styles table user defined border styles
---@field dev_mode boolean if true, enables dev features
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
