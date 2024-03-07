---@mod borderline.dev Borderline Dev Utilities
local bl_api = require('borderline.api')
local bl_util = require('borderline.util')
local M = {
  nui = {},
  plenary = {},
  nvim = {},
  fzflua = {},
}
---@type BorderlineOptions
local opts = {}

---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts
end

M.nui.popup_example = function()
  local Popup = require('nui.popup')
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {
        top = 'Nui Popup',
        top_align = 'center',
      },
    },
    relative = 'editor',
    position = {
      row = 5,
      col = 43,
    },
    size = {
      width = 35,
      height = 15,
    },
  })

  -- mount/open the component
  popup:mount()
  -- set content
  vim.api.nvim_buf_set_lines(
    popup.bufnr,
    0,
    1,
    false,
    {
      '',
      [[          Yellow Whirled        ]],
      [[             ________           ]],
      [[         ,o88~~88888888o,       ]],
      [[       ,~~?8P  88888     8,     ]],
      [[      d  d88 d88 d8_88     b    ]],
      [[     d  d888888888          b   ]],
      [[     8,?88888888  d8.b o.   8   ]],
      [[     8~88888888~ ~^8888\ db 8   ]],
      [[     ?  888888          ,888P   ]],
      [[      ?  `8888b,_      d888P    ]],
      [[       `   8888888b   ,888'     ]],
      [[         ~-?8888888 _.P-~       ]],
      [[              ~~~~~~            ]],
    }
  )
end

M.nui.layout_example = function()
  local Popup = require('nui.popup')
  local Layout = require('nui.layout')
  local popup_one, popup_two =
    Popup({
      enter = true,
      border = 'none',
    }), Popup({
      border = {
        style = 'double',
        text = {
          top = 'Nui Layout',
        },
      },
    })

  local layout = Layout(
    {
      relative = 'editor',
      position = {
        row = 22,
        col = 43,
      },
      size = {
        width = 35,
        height = 15,
      },
    },
    Layout.Box({
      Layout.Box(popup_one, { size = '40%' }),
      Layout.Box(popup_two, { size = '60%' }),
    }, { dir = 'row' })
  )

  local current_dir = 'row'

  popup_one:map('n', 'r', function()
    if current_dir == 'col' then
      layout:update(Layout.Box({
        Layout.Box(popup_one, { size = '40%' }),
        Layout.Box(popup_two, { size = '60%' }),
      }, { dir = 'row' }))

      current_dir = 'row'
    else
      layout:update(Layout.Box({
        Layout.Box(popup_two, { size = '60%' }),
        Layout.Box(popup_one, { size = '40%' }),
      }, { dir = 'col' }))

      current_dir = 'col'
    end
  end, {})

  layout:mount()
end

M.nui.input_example = function()
  local Input = require('nui.input')
  local input = Input({
    relative = 'editor',
    position = {
      row = 39,
      col = 43,
    },
    size = {
      width = 35,
    },
    border = {
      style = 'single',
      text = {
        top = 'Nui Input',
        top_align = 'center',
      },
    },
  }, {
    prompt = '> ',
    default_value = 'Hello',
    on_close = function() end,
    on_submit = function() end,
  })

  -- mount/open the component
  input:mount()
end

M.nui.menu_example = function()
  local Menu = require('nui.menu')
  local menu = Menu({
    relative = 'editor',
    position = {
      row = 43,
      col = 43,
    },
    size = {
      width = 35,
      height = 5,
    },
    border = {
      style = 'single',
      text = {
        top = 'Nui Menu',
        top_align = 'center',
      },
    },
  }, {
    lines = {
      Menu.item('Hydrogen (H)'),
      Menu.item('Carbon (C)'),
      Menu.item('Nitrogen (N)'),
      Menu.separator('Noble-Gases', {
        char = '-',
        text_align = 'right',
      }),
      Menu.item('Helium (He)'),
      Menu.item('Neon (Ne)'),
      Menu.item('Argon (Ar)'),
    },
    max_width = 35,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>' },
      submit = { '<CR>', '<Space>' },
    },
    on_close = function() end,
    on_submit = function() end,
  })

  -- mount the component
  menu:mount()
end

M.plenary.popup_example = function()
  local popup = require('plenary.popup')
  local buffer_id = vim.api.nvim_create_buf(false, true)
  popup.create(buffer_id, {
    relative = 'editor',
    line = 19,
    col = 82,
    noautocmd = true,
    zindex = 100,
    style = 'minimal',
    focusable = true,
    width = 50,
    minheight = 10,
    border = true,
    borderchars = { 'm', 'n', 'c', 'f', 'e', 'a', 'v', '8' },
    enter = true,
    title = 'Plenary Popup',
    highlight = 'NormalFloat',
    borderhighlight = 'FloatBorder',
    titlehighlight = 'FloatTitle',
  })
  vim.api.nvim_buf_set_lines(buffer_id, 0, 0, false, {
    [[       _______________________________________   ]],
    [[      / What did the farmer call the cow that \  ]],
    [[      \ had no milk? An udder failure.        /  ]],
    [[       ---------------------------------------   ]],
    [[              \   ^__^                           ]],
    [[               \  (oo)\_______                   ]],
    [[                  (__)\       )\/\               ]],
    [[                      ||----w |                  ]],
    [[                      ||     ||                  ]],
  })
end

M.nvim.openwin_example = function()
  local buffer_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buffer_id, true, {
    relative = 'editor',
    border = 'single',
    width = 50,
    height = 10,
    row = 4,
    col = 80,
    style = 'minimal',
    noautocmd = true,
    title = 'Nvim Float Window',
    title_pos = 'center',
  })
  vim.api.nvim_buf_set_lines(buffer_id, 0, 0, false, {
    [[       ___________________________________   ]],
    [[      / What would you call a cow wearing \  ]],
    [[      \ armor? Sir Loin.                  /  ]],
    [[       -----------------------------------   ]],
    [[              \   ^__^                       ]],
    [[               \  (xx)\_______               ]],
    [[                  (__)\       )\/\           ]],
    [[                   U  ||----w |              ]],
    [[                      ||     ||              ]],
  })
end

M.nvim.demo = function(border_name, border_style, winid)
  border_style = border_style or {}
  local winopts = {
    relative = 'editor',
    border = 'single',
    width = 34,
    height = 43,
    row = 4,
    col = 5,
    style = 'minimal',
    title = 'Borderline Demo',
    title_pos = 'center',
  }

  local buffer_id = nil
  if not winid then
    buffer_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('filetype', 'lua', { buf = buffer_id })
    winid = vim.api.nvim_open_win(buffer_id, true, winopts)
  else
    vim.api.nvim_win_set_config(winid, winopts)
    buffer_id = vim.api.nvim_win_get_buf(winid)
  end

  vim.api.nvim_buf_set_lines(buffer_id, 0, -1, false, {})
  local lines = { '', ' -- ' .. border_name }
  local borderchars = bl_util.strip_border_hl(border_style)
  if next(borderchars) then
    local size = 6
    table.insert(lines, ' -- ' .. borderchars[1] .. borderchars[2]:rep(size) .. borderchars[3])
    for _ = 1, (size / 2) do
      table.insert(lines, ' -- ' .. borderchars[8] .. string.rep(' ', size) .. borderchars[4])
    end
    table.insert(lines, ' -- ' .. borderchars[7] .. borderchars[6]:rep(size) .. borderchars[5])
  end
  local border_map = bl_util.border_tbl_to_map(border_style)
  local first = true
  for s in vim.inspect(border_map):gmatch('[^\r\n]+') do
    s = s:gsub('^(.*%[)"(.*)"(%])', '%1%2%3')
    if first then
      table.insert(lines, ' local border = ' .. s)
      first = false
    else
      table.insert(lines, ' ' .. s)
    end
  end
  vim.api.nvim_buf_set_lines(buffer_id, 0, 0, false, lines)
  return winid
end

M.nvim.input_example = function()
  vim.ui.input({ prompt = 'What are you doing?' }, function() end)
end

M.nvim.select_example = function()
  vim.ui.select({ 'tabs', 'spaces' }, {
    prompt = 'Select tabs or spaces:',
    format_item = function(item)
      return "I'd like to choose " .. item
    end,
  }, function() end)
end

M.fzflua.ls_example = function()
  require('fzf-lua').fzf_exec('ls', {
    winopts = {
      width = 50,
      height = 17,
      row = 30,
      col = 80,
      title = 'Fzf-lua Window',
      title_pos = 'center',
    },
    previewer = 'builtin',
  })
end

M.demo_winid = nil

M.commands = {
  nuilayout = M.nui.layout_example,
  nuipopup = M.nui.popup_example,
  nuiinput = M.nui.input_example,
  nuimenu = M.nui.menu_example,
  plenarypopup = M.plenary.popup_example,
  nvimopenwin = M.nvim.openwin_example,
  nviminput = M.nvim.input_example,
  nvimselect = M.nvim.select_example,
  fzflualsreadme = M.fzflua.ls_example,
  demostart = function()
    bl_util.border_next_timer_stop()
    M.demo_winid = M.nvim.demo('Borderline Demo', {}, M.demo_winid)
    bl_util.border_next_timer_start(1500, function(border_style, border_name)
      bl_api.borderline(border_style)
      M.nvim.demo(border_name, border_style, M.demo_winid)
    end)

    M.nui.popup_example()
    M.nui.layout_example()
    M.nui.input_example()
    M.nui.menu_example()
    M.plenary.popup_example()
    M.nvim.openwin_example()
    M.fzflua.ls_example()
    vim.api.nvim_feedkeys(
      'README.md' .. vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true),
      'n',
      false
    )
    vim.schedule(function()
      vim.cmd([[noautocmd wincmd t]])
    end)
  end,
  demonext = function()
    bl_util.border_next_timer_stop()
    M.demo_winid = M.nvim.demo('Borderline Demo', {}, M.demo_winid)
    local border_style, border_name = bl_util.border_next()
    bl_api.borderline(border_style)
    M.nvim.demo(border_name, border_style, M.demo_winid)
  end,
  demoprevious = function()
    bl_util.border_next_timer_stop()
    M.demo_winid = M.nvim.demo('Borderline Demo', {}, M.demo_winid)
    local border_style, border_name = bl_util.border_previous()
    bl_api.borderline(border_style)
    M.nvim.demo(border_name, border_style, M.demo_winid)
  end,
}

return M
