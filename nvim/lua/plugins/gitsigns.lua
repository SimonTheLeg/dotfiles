local M = {}

M.Setup = function()
  require('gitsigns').setup {

    -- key mappings
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- hunk staging
      map('n', '<leader>ga', gs.stage_hunk, { desc = "git stage hunk" })
      map('n', '<leader>gr', gs.reset_hunk, { desc = "git reset hunk" })
      map('v', '<leader>ga', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "git stage hunk" })
      map('v', '<leader>gr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = "git reset hunk" })
      -- stage the whole file/buffer
      map('n', '<leader>gS', gs.stage_buffer, { desc = "git stage file" })
      map('n', '<leader>gR', gs.reset_buffer, { desc = "git reset file" })
      -- preview hunk
      map('n', '<leader>gp', gs.preview_hunk, { desc = "git preview hunk" })
      map('n', '<leader>gi', gs.preview_hunk_inline, { desc = "git preview hunk inline" })
      -- hunk navigation
      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = "git next hunk" })
      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = "git previous hunk" })
    end
  }

end



return M
