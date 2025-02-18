local M = {}

M.Setup = function()
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
end

return M
