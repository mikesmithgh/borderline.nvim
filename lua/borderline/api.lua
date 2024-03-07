---@mod borderline.api Borderline API

local M = {}
local bl_fzflua = require('borderline.fzf-lua')
local bl_nui = require('borderline.nui')
local bl_plenary = require('borderline.plenary')
local bl_standard = require('borderline.standard')
local bl_util = require('borderline.util')

---@type BorderlineOptions
local opts = {} ---@diagnostic disable-line: unused-local

-- inner help menu window id
local inner_info_winid = nil
-- outer help menu window id
local info_outer_winid = nil

---@tag borderline.api.setup
---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts ---@diagnostic disable-line: unused-local

  vim.api.nvim_create_autocmd('WinResized', {
    group = vim.api.nvim_create_augroup('BorderlineInfoResized', { clear = true }),
    callback = function()
      if inner_info_winid then
        vim.schedule(M.info)
      end
    end,
  })
end

---@tag borderline.api.borderline
M.borderline = function(border, border_name)
  bl_util.current_border_name = type(border_name) == 'string' and border_name or nil
  local new_border = bl_util.normalize_border(border)
  opts.border = new_border ---@diagnostic disable-line: unused-local
  bl_standard.update_borders()
  if bl_fzflua.update_borders then
    bl_fzflua.update_borders()
  end
  if bl_plenary.update_borders then
    bl_plenary.update_borders()
  end
  if bl_nui.update_borders then
    bl_nui.update_borders()
  end
  if inner_info_winid then
    M.info()
  end
end

local register_fns = {
  nvim = bl_standard.register,
  fzflua = bl_fzflua.register,
  nui = bl_nui.register,
  plenary = bl_plenary.register,
}

M.register_keys = function()
  return vim.tbl_keys(register_fns)
end

M.register = function(name)
  if name and name ~= '' then
    local register_fn = register_fns[name]
    if register_fn then
      register_fn()
    else
      vim.notify('borderline.nvim: cannot register invalid type ' .. name, vim.log.levels.ERROR, {})
    end
  else
    for _, key in pairs(M.register_keys()) do
      register_fns[key]()
    end
  end
  if inner_info_winid then
    M.info()
  end
end

local deregister_fns = {
  nvim = bl_standard.deregister,
  fzflua = bl_fzflua.deregister,
  nui = bl_nui.deregister,
  plenary = bl_plenary.deregister,
}

M.deregister_keys = function()
  return vim.tbl_keys(deregister_fns)
end

M.deregister = function(name)
  if name and name ~= '' then
    local deregister_fn = deregister_fns[name]
    if deregister_fn then
      deregister_fn()
    else
      vim.notify(
        'borderline.nvim: cannot deregister invalid type ' .. name,
        vim.log.levels.ERROR,
        {}
      )
    end
  else
    for _, key in pairs(M.deregister_keys()) do
      deregister_fns[key]()
    end
  end
  if inner_info_winid then
    M.info()
  end
end

M.info = function()
  local nvim_registered = bl_standard.is_registered() or false
  local nui_registered = bl_nui.is_registered and bl_nui.is_registered() or false
  local plenary_registered = bl_plenary.is_registered and bl_plenary.is_registered() or false
  local fzflua_registered = bl_fzflua.is_registered and bl_fzflua.is_registered() or false

  local outer_lines = {
    '```',
    '```',
    '  ## Options',
    ('  - [%s] enabled'):format(opts.enabled and 'x' or ' '),
    ('  - [%s] dev_mode'):format(opts.dev_mode and 'x' or ' '),
    '',
    '  ## Registered',
    ('  - [%s] nvim'):format(nvim_registered and 'x' or ' '),
    ('  - [%s] nui'):format(nui_registered and 'x' or ' '),
    ('  - [%s] plenary'):format(plenary_registered and 'x' or ' '),
    ('  - [%s] fzf-lua'):format(fzflua_registered and 'x' or ' '),
    '',
    '  ## Available',
    ('  - [%s] nui'):format(bl_nui.update_borders and 'x' or ' '),
    ('  - [%s] plenary'):format(bl_plenary.update_borders and 'x' or ' '),
    ('  - [%s] fzf-lua'):format(bl_fzflua.update_borders and 'x' or ' '),
    '',
    '  ## Characters',
    '```',
  }
  local border_style = bl_util.normalize_border(opts.border)
  local borderchars = bl_util.strip_border_hl(border_style)
  if next(borderchars) then
    local width = 9
    local height = 3
    table.insert(
      outer_lines,
      '    ' .. borderchars[1] .. borderchars[2]:rep(width) .. borderchars[3]
    )
    for i = 1, height do
      table.insert(
        outer_lines,
        '    ' .. borderchars[8] .. string.rep(' ', width) .. borderchars[4]
      )
    end
    table.insert(
      outer_lines,
      '    ' .. borderchars[7] .. borderchars[6]:rep(width) .. borderchars[5]
    )
  end
  table.insert(outer_lines, '```')

  local inner_lines = {}
  local border_map = bl_util.border_tbl_to_map(border_style)
  local first = true
  local longest = 0
  for s in vim.inspect(border_map):gmatch('[^\r\n]+') do
    if #s > longest then
      longest = #s
    end
    s = s:gsub('^(.*%[)"(.*)"(%])', '%1%2%3')
    if first then
      if type(bl_util.current_border_name) == 'string' then
        table.insert(inner_lines, '## ' .. bl_util.current_border_name)
      end
      table.insert(inner_lines, '```lua')
      table.insert(inner_lines, 'local border = ' .. s)
      first = false
    else
      table.insert(inner_lines, ' ' .. s)
    end
  end
  table.insert(inner_lines, '```')

  local outer_buffer_id = info_outer_winid and vim.api.nvim_win_get_buf(info_outer_winid)
    or vim.api.nvim_create_buf(false, true)
  local inner_buffer_id = inner_info_winid and vim.api.nvim_win_get_buf(inner_info_winid)
    or vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value('modifiable', true, { buf = outer_buffer_id })
  vim.api.nvim_set_option_value('modifiable', true, { buf = inner_buffer_id })

  vim.api.nvim_buf_set_lines(outer_buffer_id, 0, -1, false, {})
  vim.api.nvim_buf_set_lines(inner_buffer_id, 0, -1, false, {})

  vim.lsp.util.stylize_markdown(outer_buffer_id, outer_lines, {})
  vim.lsp.util.stylize_markdown(inner_buffer_id, inner_lines, {})

  local winheight = #inner_lines > #outer_lines and #inner_lines or #outer_lines
  if winheight >= vim.o.lines - 3 then
    winheight = vim.o.lines - 10
  end

  local outer_winopts = vim.tbl_extend('force', {
    relative = 'editor',
    noautocmd = true,
    border = 'rounded',
    zindex = 10,
    style = 'minimal',
    focusable = false,
    title = 'borderline.nvim',
    title_pos = 'center',
  }, bl_util.center_window_options(longest + 25, winheight + 2, vim.o.columns, vim.o.lines))
  if info_outer_winid then
    vim.api.nvim_win_close(info_outer_winid, true)
  end
  info_outer_winid = vim.api.nvim_open_win(outer_buffer_id, false, outer_winopts)
  vim.cmd.redraw()

  local inner_winopts = {
    relative = 'win',
    win = info_outer_winid,
    row = 2,
    col = 20,
    border = { '', '', '', '', '', '', '', '' },
    width = outer_winopts.width - 20,
    height = outer_winopts.height - 2,
    style = 'minimal',
    focusable = true,
    zindex = outer_winopts.zindex + 1,
  }
  if inner_info_winid then
    vim.api.nvim_win_set_config(inner_info_winid, inner_winopts)
  else
    inner_info_winid = vim.api.nvim_open_win(inner_buffer_id, false, inner_winopts)
  end
  vim.cmd.redraw()

  vim.api.nvim_set_option_value('modifiable', false, { buf = outer_buffer_id })
  vim.api.nvim_set_option_value('modifiable', false, { buf = inner_buffer_id })

  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = outer_buffer_id })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = inner_buffer_id })

  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(inner_info_winid),
    group = vim.api.nvim_create_augroup('BorderlineInfoClosed', { clear = true }),
    callback = function()
      pcall(vim.api.nvim_win_close, info_outer_winid, true)
      inner_info_winid = nil
      info_outer_winid = nil
    end,
  })
end

return M
