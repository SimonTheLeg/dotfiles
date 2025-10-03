local M = {}

M.Setup = function()
  -- use '#' like '*'
  vim.keymap.set('n', '#', '<Plug>SearchHighlightingStar')
end

return M
