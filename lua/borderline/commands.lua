---@mod borderline.commands Borderline Commands

local bl_util = require('borderline.util')
local bl_api = require('borderline.api')
local bl_dev = require('borderline.dev')
local M = {}

---@type BorderlineOptions
local opts = {}

---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts

  vim.api.nvim_create_user_command('Borderline', function(o)
    bl_util.border_next_timer_stop()
    local border = o.args
    if border == nil or border == '' then
      -- no args, set to current configuration
      border = bl_util.initial_opts.border
    end

    bl_api.borderline(border)
  end, {
    nargs = '?',
    complete = bl_util.border_style_names,
  })

  vim.api.nvim_create_user_command('BorderlineNext', function()
    bl_util.border_next_timer_stop()
    bl_api.borderline(bl_util.border_next())
  end, {})

  vim.api.nvim_create_user_command('BorderlinePrevious', function()
    bl_util.border_next_timer_stop()
    bl_api.borderline(bl_util.border_previous())
  end, {})

  vim.api.nvim_create_user_command('BorderlineDemoStart', function(o)
    bl_util.border_next_timer_stop()
    local time = o.args
    if time == nil or time == '' then
      -- no args, set to current configuration
      time = 1000
    end
    bl_util.border_next_timer_start(time, bl_api.borderline)
  end, {
    nargs = '?',
  })

  vim.api.nvim_create_user_command('BorderlineDemoStop', function()
    bl_util.border_next_timer_stop()
  end, {})

  vim.api.nvim_create_user_command('BorderlineDev', function(o)
    local type = o.args
    if type == nil or type == '' then
      return
    end
    local dev_fn = bl_dev.commands[type]
    dev_fn()
  end, {
    nargs = '?',
    complete = function()
      return vim.tbl_keys(bl_dev.commands)
    end,
  })
end

return M
