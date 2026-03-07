return {
  'navarasu/onedark.nvim',
  cond = not vim.g.vscode,
  config = function()
    require('onedark').load()
  end,
}
