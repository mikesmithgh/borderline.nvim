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

  local cur_border_idx = nil
  vim.api.nvim_create_user_command('BorderlineNext', function()
    local doit = function()
      local names = bl_util.border_style_names()
      if not names or next(names) == nil then
        return
      end
      if not cur_border_idx or cur_border_idx > #names then
        cur_border_idx = 1
      else
        cur_border_idx = cur_border_idx + 1
      end
      local target_border_name = names[cur_border_idx]
      vim.print(target_border_name)
      local border_styles = bl_util.border_styles()
      bl_api.borderline(border_styles[target_border_name])
    end
    vim.fn.timer_start(4000, doit, {
      ['repeat'] = -1,
    })
  end, {})


  vim.api.nvim_create_user_command('BorderlineDev', function(o)
    local type = o.args
    if type == nil or type == '' then
      return
    end
    if type == 'nuilayout' then
      bl_dev.nui.layout_example()
    end
    if type == 'nuipopup' then
      bl_dev.nui.popup_example()
    end
    if type == 'nuiinput' then
      bl_dev.nui.input_example()
    end
    if type == 'nuimenu' then
      bl_dev.nui.menu_example()
    end
    if type == 'nuisplit' then
      bl_dev.nui.split_example()
    end
  end, {
    nargs = '?',
    complete = function()
      return {
        'nuilayout',
        'nuipopup',
        'nuiinput',
        'nuimenu',
        'nuisplit',
      }
    end,
  })
end

return M
