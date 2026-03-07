return {
  {
    'saghen/blink.cmp',
    cond = not vim.g.vscode,
    -- TODO figure whether we really want this
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'super-tab' },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },
  {
    'folke/lazydev.nvim',
    cond = not vim.g.vscode,
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    cond = not vim.g.vscode,
    dependencies = { 'folke/lazydev.nvim' }, -- ensure that lazydev loads first
    config = function()
      local lua_opts = vim.lsp.config['lua_ls']

      lua_opts.settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
        }
      }

      lua_opts.capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.lsp.enable('lua_ls')

      vim.keymap.set('n', '<leader>lf', function()
        vim.lsp.buf.format({ async = true })
      end, { desc = 'LSP Format' })

      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "go to next diagnostic (lsp)" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "go to previous diagnostic (lsp)" })
      vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = "show diagnostic in floating window (lsp)" })
    end
  },
}
