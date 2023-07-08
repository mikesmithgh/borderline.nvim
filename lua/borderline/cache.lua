---@mod borderline.cache Borderline Internal Cache
local M = {
  nui_had_border = {},
  nvim_had_border = {},
  plenary_had_border = {},
  fzflua_had_border = {},
  plenary_prev_title = {},
}

vim.api.nvim_create_autocmd({ 'WinClosed' }, {
  group = vim.api.nvim_create_augroup('BorderlineCleanCache', { clear = true }),
  callback = function()
    local current_wins = vim.api.nvim_list_wins()
    for _, cache_key in pairs(vim.tbl_keys(M)) do
      local cache = M[cache_key]
      for _, winid in pairs(vim.tbl_keys(cache)) do
        if not vim.tbl_contains(current_wins, winid) then
          cache[winid] = nil
        end
      end
    end
  end,
})

return M
