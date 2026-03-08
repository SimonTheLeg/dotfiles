return {
  'nvim-telescope/telescope.nvim',
  cond = not vim.g.vscode,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
    'nvim-telescope/telescope-fzy-native.nvim',
    'sharkdp/fd',
  },
  config = function()
    local actions = require "telescope.actions"

    require('telescope').setup {
      pickers = {
        find_files = {
          hidden = true,
          file_ignore_patterns = { ".git/" },
          -- reverse Enter and ctrl+t bindings
          mappings = {
            i = {
              ["<CR>"] = actions.select_tab_drop, -- _drop so we switch to the tab instead of reopening if it already exists
              ["<C-t>"] = actions.select_default,
              ["<Esc><Esc>"] = actions.close, -- we need this so we can have clear search highlighting on <esc><esc> in normal vim but not in telescope prompts
            },
            n = {
              ["<CR>"] = actions.select_tab_drop, -- _drop so we switch to the tab instead of reopening if it already exists
              ["<C-t>"] = actions.select_default,
              ["<Esc><Esc>"] = actions.close, -- we need this so we can have clear search highlighting on <esc><esc> in normal vim but not in telescope prompts
            },
          },
        },
        live_grep = {
          hidden = true,
          file_ignore_patterns = { ".git/" },
          -- reverse Enter and ctrl+t bindings
          mappings = {
            i = {
              ["<CR>"] = actions.select_tab_drop, -- _drop so we switch to the tab instead of reopening if it already exists
              ["<C-t>"] = actions.select_default,
              ["<Esc><Esc>"] = actions.close, -- we need this so we can have clear search highlighting on <esc><esc> in normal vim but not in telescope prompts
            },
            n = {
              ["<CR>"] = actions.select_tab_drop, -- _drop so we switch to the tab instead of reopening if it already exists
              ["<C-t>"] = actions.select_default,
              ["<Esc><Esc>"] = actions.close, -- we need this so we can have clear search highlighting on <esc><esc> in normal vim but not in telescope prompts
            },
          },
        }
      }
    }

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<C-P>', builtin.commands, { desc = 'Telescope search vim commands' })
    vim.keymap.set('n', '<leader>?', builtin.keymaps, { desc = 'Telescope list keymaps' })
  end,
}
