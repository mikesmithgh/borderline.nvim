local bl_util = require('borderline.util')
local bl_plenary = require('borderline.plenary')
local bl_fzflua = require('borderline.fzf-lua')
local bl_nui = require('borderline.nui')
local bl_standard = require('borderline.standard')
local bl_config = require('borderline.config')
local bl_api = require('borderline.api')
local bl_commands = require('borderline.commands')
local bl_dev = require('borderline.dev')

-- considerations
-- nvim win commands
-- diagnostic windows
-- see vim.diagnostic.config
-- plenary
-- nui
-- fzf-lua
-- dressing.nvim


local M = {}


---Initialize borderline.nvim
---@param override_opts? BorderlineOptions Optional borderline.nvim configuration overrides
M.setup = function(override_opts)
  M.default_opts = bl_config.default_opts()
  if override_opts == nil then
    override_opts = {}
  end
  bl_config.opts = vim.tbl_deep_extend('force', M.default_opts, override_opts)
  M.opts = bl_config.opts

  bl_util.setup(M.opts)
  bl_standard.setup(M.opts)
  bl_plenary.setup(M.opts)
  bl_nui.setup(M.opts)
  bl_fzflua.setup(M.opts)
  bl_api.setup(M.opts)
  bl_commands.setup(M.opts)
  bl_dev.setup(M.opts)

  bl_standard.update_borders()
  bl_fzflua.update_borders()
end

return M
