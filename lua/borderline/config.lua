---@mod borderline.config Borderline Configuration

local bl_borders = require('borderline.borders')

local M = {}

---Configuration options to modify behavior of borderline.nvim
---@class BorderlineOptions
---@field enabled boolean if true, override borders
---@field border table default border
---@field border_styles table user defined border styles
local standard_opts = {
  enabled = true,
  border = bl_borders.rounded,
  border_styles = {}
}

M.default_opts = function()
  return vim.tbl_deep_extend('force', {}, standard_opts)
end

M.opts = {}

return M
