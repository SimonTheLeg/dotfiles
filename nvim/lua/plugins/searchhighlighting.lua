return {
  'inkarkat/vim-SearchHighlighting',
  dependencies = {
    'inkarkat/vim-ingo-library'
  },
  config = function()
    -- use '#' like '*'
    vim.keymap.set('n', '#', '<Plug>SearchHighlightingStar')
  end,
}
