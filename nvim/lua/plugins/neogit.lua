return {
  "NeogitOrg/neogit",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neogit").setup {
      disable_hint = true,

      sections = {
        untracked = {
          folded = true,
          hidden = false,
        },
      },
    }

    -- set keymap
    vim.keymap.set("n", "<leader>G", vim.cmd.Neogit)
  end,
}
