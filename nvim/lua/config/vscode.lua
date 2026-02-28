-- Git Operations
vim.keymap.set('n', '<leader>grc', '<Cmd>call VSCodeCall("gitlens.copyRemoteFileUrlToClipboard")<CR>')
vim.keymap.set('n', '<leader>grC', '<Cmd>call VSCodeCall("gitlens.openCommitOnRemote")<CR>')
vim.keymap.set('n', '<leader>grf', '<Cmd>call VSCodeCall("gitlens.openFileOnRemote")<CR>')
vim.keymap.set('n', '<leader>grr', '<Cmd>call VSCodeCall("git.revertSelectedRanges")<CR>')
vim.keymap.set('n', '<leader>gh', '<Cmd>call VSCodeCall("git.viewLineHistory")<CR>')
vim.keymap.set('v', '<leader>gh', '<Cmd>call VSCodeCall("git.viewLineHistory")<CR>')

-- Language Server Operations
vim.keymap.set('n', '<leader>wl', '<Cmd>call VSCodeCall("rewrap.rewrapComment")<CR>')
vim.keymap.set('n', '<leader>ld', '<Cmd>call VSCodeCall("go.debug.cursor")<CR>')
vim.keymap.set('n', '<leader>lt', '<Cmd>call VSCodeCall("testing.runAtCursor")<CR>')
vim.keymap.set('n', '<leader>lT', '<Cmd>call VSCodeCall("testing.runCurrentFile")<CR>')
vim.keymap.set('n', '<leader>lb', '<Cmd>call VSCodeCall("editor.debug.action.toggleBreakpoint")<CR>')
vim.keymap.set('n', '<leader>lfi', '<Cmd>call VSCodeCall("references-view.findImplementations")<CR>')
vim.keymap.set('n', '<leader>lot', '<Cmd>call VSCodeCall("go.toggle.test.file")<CR>')
vim.keymap.set('n', '<leader>lc', '<Cmd>call VSCodeCall("go.test.coverage")<CR>')
vim.keymap.set('n', '<leader>lr', '<Cmd>call VSCodeCall("editor.action.rename")<CR>')
vim.keymap.set('n', '<leader>lP', '<Cmd>call VSCodeCall("editor.action.marker.prev")<CR>')
vim.keymap.set('n', '<leader>lp', '<Cmd>call VSCodeCall("editor.action.marker.next")<CR>')
vim.keymap.set('n', '<leader>li', '<Cmd>call VSCodeCall("go.import.add")<CR>')

-- VSCode Management
vim.keymap.set('n', '<leader>tt', '<Cmd>call VSCodeCall("workbench.action.toggleLightDarkThemes")<CR>')
vim.keymap.set('n', '<leader>rr', '<Cmd>call VSCodeCall("workbench.action.reloadWindow")<CR>')
vim.keymap.set('n', '<C-w>z', '<Cmd>call VSCodeCall("workbench.action.minimizeOtherEditors")<CR>')

-- Json Management
vim.keymap.set('n', '<leader>jp', '<Cmd>call VSCodeCall("extension.prettyJSON")<CR>')
vim.keymap.set('n', '<leader>jm', '<Cmd>call VSCodeCall("extension.minifyJSON")<CR>')
vim.keymap.set('v', '<leader>jp', '<Cmd>call VSCodeCall("extension.prettyJSON")<CR>')
vim.keymap.set('v', '<leader>jm', '<Cmd>call VSCodeCall("extension.minifyJSON")<CR>')

-- AI stuff
vim.keymap.set('n', '<leader>ai', '<Cmd>call VSCodeCall("workbench.action.toggleAuxiliaryBar")<CR>')
