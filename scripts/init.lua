-- add temp path from scripts/mini.sh in case this is running locally
local tempdir = vim.trim(vim.fn.system([[sh -c "dirname $(mktemp -u)"]]))
local packpath = os.getenv("PACKPATH") or tempdir .. "/borderline.nvim.tmp/nvim/site"
vim.cmd("set packpath=" .. packpath)

vim.o.termguicolors = true

require "gruvsquirrel".setup()
require "borderline".setup()
