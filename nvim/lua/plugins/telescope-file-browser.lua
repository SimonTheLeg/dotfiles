return {
  "nvim-telescope/telescope-file-browser.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup {}

    vim.keymap.set("n", "<leader>fe", function()
      require("telescope").extensions.file_browser.file_browser()
    end)
  end,
}
