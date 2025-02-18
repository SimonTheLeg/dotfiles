-- Settings to use regardless of plain Neovim or VSCode
-- TODO delete this possibly
-- local home = os.getenv("HOME")

-- Settings to always use regardless of plain nvim or VSCode
require("config.general")

require 'plugins.plugins'
require("lazy").setup(Plugins_to_install)

-- Settings to only use outside of VSCode
if not vim.g.vscode then
   require("config.plain")
   require("plugins.lightline")
end

-- Settings to only use inside of VSCode
-- TODO
-- if vim.g.vscode then
--    require("config.vscode")
-- end

-- Legacy vimrc sourcing
vim.cmd("source ~/.vimrc")

