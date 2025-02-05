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
end

return M
