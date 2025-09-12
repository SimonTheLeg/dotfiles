local M = {}

M.Setup = function()
  require('telescope').setup {
    pickers = {
      find_files = {
        hidden = true,
        file_ignore_patterns = { ".git/" },
      }
    }
  }

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
end

return M
