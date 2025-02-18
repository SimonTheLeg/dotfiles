local M = {}

M.Setup = function()
  require("telescope").setup {}

  vim.keymap.set("n", "<leader>fe", function()
    require("telescope").extensions.file_browser.file_browser()
  end)
end

return M
