local M = {}

M.Setup = function()
  -- Set colorscheme
  -- TODO could possibly use lua api here
  vim.cmd("colorscheme base16-onedark")
  vim.cmd("set termguicolors")
end

return M
