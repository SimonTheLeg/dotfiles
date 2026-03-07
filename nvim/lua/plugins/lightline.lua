return {
  'itchyny/lightline.vim',
  cond = not vim.g.vscode,
  config = function()
    -- Disable the normal status bar (e.g. -- INSERT --) because it's shown in lightline
    vim.opt.showmode = false
  end,
}
