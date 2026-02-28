-- Settings to always use regardless of plain nvim or VSCode
require("config.general")
require("config.macros")

require 'plugins.plugins'
require("lazy").setup(Plugins_to_install)

-- Settings to only use outside of VSCode
if not vim.g.vscode then
   require("config.plain")
   require("plugins.lightline")
end

-- Settings to only use inside of VSCode
if vim.g.vscode then
   require("config.vscode")
end
