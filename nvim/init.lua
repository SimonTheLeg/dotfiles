-- Settings to always use regardless of plain nvim or VSCode
require("config.general")
require("config.macros")
require("config.lazy")

-- Settings to only use outside of VSCode
if not vim.g.vscode then
   require("config.plain")
end

-- Settings to only use inside of VSCode
if vim.g.vscode then
   require("config.vscode")
end
