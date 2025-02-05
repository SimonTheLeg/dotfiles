-- General settings to be used inside plain neovim

-- highlight current line number
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ABB2BF', bold = true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#545862', bold = true })
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#545862', bold = true })


-- make tabs, spaces visible
vim.opt.listchars = { tab = '->', space = '·' }
vim.opt.list = true
-- :set list
