return {
  'folke/persistence.nvim',
  cond = not vim.g.vscode,
  event = "BufReadPre", -- This starts session saving when opening a file
  config = function()
    require("persistence").setup {}
  end,
  -- auto cmds need to be registered in the init function to ensure they are registered before the event is fired
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyDone",
      callback = function()
        -- Only restore if Neovim was opened without arguments (e.g., just `nvim`)
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          require("persistence").load()
        end
      end,
      nested = true,
    })
  end,
}
