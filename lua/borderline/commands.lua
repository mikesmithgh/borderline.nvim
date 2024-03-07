---@mod borderline.commands Borderline Commands

local bl_api = require('borderline.api')
local bl_dev = require('borderline.dev')
local bl_util = require('borderline.util')
local M = {}

---@type BorderlineOptions
local opts = {}

---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts

  vim.api.nvim_create_user_command('Borderline', function(o)
    bl_util.border_next_timer_stop()
    local border_name = o.args
    local border = border_name
    if border_name == nil or border_name == '' then
      -- no args, set to current configuration
      border = bl_util.initial_opts.border
      border_name = bl_util.initial_border_name
    end

    bl_api.borderline(border, border_name)
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

  vim.api.nvim_create_user_command('BorderlineStartNextTimer', function(o)
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

  vim.api.nvim_create_user_command('BorderlineStopNextTimer', function()
    bl_util.border_next_timer_stop()
  end, {})

  vim.api.nvim_create_user_command('BorderlineRegister', function(o)
    bl_api.register(o.args)
  end, {
    nargs = '?',
    complete = bl_api.register_keys,
  })

  vim.api.nvim_create_user_command('BorderlineDeregister', function(o)
    bl_api.deregister(o.args)
  end, {
    nargs = '?',
    complete = bl_api.deregister_keys,
  })

  vim.api.nvim_create_user_command('BorderlineInfo', function()
    bl_api.info()
  end, {})

  if opts.dev_mode then
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
end

return M
