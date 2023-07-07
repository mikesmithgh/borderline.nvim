local M = {
  nui = {},
  plenary = {},
  nvim = {},
}
---@type BorderlineOptions
local opts = {}

---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts
end

M.nui.popup_example = function()
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Nui Popup",
        top_align = "center",
      },
    },
    position = "90%",
    size = {
      width = "25%",
      height = "25%",
    },
  })

  -- mount/open the component
  popup:mount()

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "",
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

  })
end

M.nui.layout_example = function()
  local Popup = require("nui.popup")
  local Layout = require("nui.layout")
  local popup_one, popup_two = Popup({
    enter = true,
    border = "none",
  }), Popup({
    border = {
      style = "double",
      text = {
        top = "Nui Layout",
      },
    },
  })

  local layout = Layout(
    {
      position = "50%",
      size = {
        width = 80,
        height = "60%",
      },
    },
    Layout.Box({
      Layout.Box(popup_one, { size = "40%" }),
      Layout.Box(popup_two, { size = "60%" }),
    }, { dir = "row" })
  )

  local current_dir = "row"

  popup_one:map("n", "r", function()
    if current_dir == "col" then
      layout:update(Layout.Box({
        Layout.Box(popup_one, { size = "40%" }),
        Layout.Box(popup_two, { size = "60%" }),
      }, { dir = "row" }))

      current_dir = "row"
    else
      layout:update(Layout.Box({
        Layout.Box(popup_two, { size = "60%" }),
        Layout.Box(popup_one, { size = "40%" }),
      }, { dir = "col" }))

      current_dir = "col"
    end
  end, {})

  layout:mount()
end

M.nui.input_example = function()
  local Input = require("nui.input")
  local event = require("nui.utils.autocmd").event
  local input = Input({
    position = "50%",
    size = {
      width = 20,
    },
    border = {
      style = "single",
      text = {
        top = "Nui Input",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    prompt = "> ",
    default_value = "Hello",
    on_close = function()
      print("Input Closed!")
    end,
    on_submit = function(value)
      print("Input Submitted: " .. value)
    end,
  })

  -- mount/open the component
  input:mount()

  -- unmount component when cursor leaves buffer
  input:on(event.BufLeave, function()
    input:unmount()
  end)
end

M.nui.menu_example = function()
  local Menu = require("nui.menu")
  local menu = Menu({
    position = "50%",
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = {
      Menu.item("Hydrogen (H)"),
      Menu.item("Carbon (C)"),
      Menu.item("Nitrogen (N)"),
      Menu.separator("Noble-Gases", {
        char = "-",
        text_align = "right",
      }),
      Menu.item("Helium (He)"),
      Menu.item("Neon (Ne)"),
      Menu.item("Argon (Ar)"),
    },
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_close = function()
      print("Menu Closed!")
    end,
    on_submit = function(item)
      print("Menu Submitted: ", item.text)
    end,
  })

  -- mount the component
  menu:mount()
end

M.nui.split_example = function()
  local Split = require("nui.split")
  local event = require("nui.utils.autocmd").event
  local split = Split({
    relative = "editor",
    position = "bottom",
    size = "20%",
  })

  -- mount/open the component
  split:mount()

  -- unmount component when cursor leaves buffer
  split:on(event.BufLeave, function()
    split:unmount()
  end)
end

M.plenary.popup_example = function()
  local popup = require "plenary.popup"
  local buffer_id = vim.api.nvim_create_buf(false, true)
  popup.create(buffer_id, {
    relative = 'editor',
    col = 80,
    noautocmd = true,
    zindex = 1000,
    style = 'minimal',
    focusable = true,
    width = 50,
    minheight = 10,
    border = true,
    borderchars = { 'm', 'n', 'c', 'f', 'e', 'a', 'v', '8', },
    enter = true,
    title = 'Plenary Popup',
    highlight = "NormalFloat",
    borderhighlight = "FloatBorder",
    titlehighlight = "FloatTitle",
  })
  vim.api.nvim_buf_set_lines(
    buffer_id,
    0,
    0,
    false, {
      [[       _______________________________________   ]],
      [[      / What did the farmer call the cow that \  ]],
      [[      \ had no milk? An udder failure.        /  ]],
      [[       ---------------------------------------   ]],
      [[              \   ^__^                           ]],
      [[               \  (oo)\_______                   ]],
      [[                  (__)\       )\/\               ]],
      [[                      ||----w |                  ]],
      [[                      ||     ||                  ]],
    }
  )
end

M.nvim.openwin_example = function()
  local buffer_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buffer_id, true, {
    relative = "editor",
    border = "single",
    width = 50,
    height = 10,
    row = 5,
    col = 80,
    style = "minimal",
    noautocmd = true,
    title = "Nvim float window",
    title_pos = 'center',
  })
  vim.api.nvim_buf_set_lines(
    buffer_id,
    0,
    0,
    false, {
      [[       ___________________________________   ]],
      [[      / What would you call a cow wearing \  ]],
      [[      \ armor? Sir Loin.                  /  ]],
      [[       -----------------------------------   ]],
      [[              \   ^__^                       ]],
      [[               \  (xx)\_______               ]],
      [[                  (__)\       )\/\           ]],
      [[                   U  ||----w |              ]],
      [[                      ||     ||              ]],
    }
  )
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

M.commands = {
  nuilayout = M.nui.layout_example,
  nuipopup = M.nui.popup_example,
  nuiinput = M.nui.input_example,
  nuimenu = M.nui.menu_example,
  nuisplit = M.nui.split_example,
  plenarypopup = M.plenary.popup_example,
  nvimopenwin = M.nvim.openwin_example,
  nviminput = M.nvim.input_example,
  nvimselect = M.nvim.select_example,
  getdapoppin = function()
    M.nui.popup_example()
    M.plenary.popup_example()
    M.nvim.openwin_example()
  end
}


return M
