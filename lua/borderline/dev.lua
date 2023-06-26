local M = {
  nui = {}
}

local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local Layout = require("nui.layout")
local Input = require("nui.input")
local Menu = require("nui.menu")
local Split = require("nui.split")

---@type BorderlineOptions
local opts = {}

---@param borderline_opts BorderlineOptions
M.setup = function(borderline_opts)
  opts = borderline_opts
end


M.nui.popup_example = function()
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },

    position = "50%",
    size = {
      width = "80%",
      height = "60%",
    },
  })

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })
end

M.nui.layout_example = function()
  local popup_one, popup_two = Popup({
    enter = true,
    border = "single",
  }), Popup({
    border = "double",
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
  local input = Input({
    position = "50%",
    size = {
      width = 20,
    },
    border = {
      style = "single",
      text = {
        top = "[Howdy?]",
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
  local menu = Menu({
    position = "50%",
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "[Choose-an-Element]",
        top_align = "center",
      },
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


return M
