-- Settings in this file are always applied
local opt = vim.opt
local fn = vim.fn
local km = vim.keymap

vim.g.mapleader = " "

-- turn hybrid line numbers on
opt.number = true
opt.relativenumber = true

opt.wrap = false      -- Do not automatically wrap lines
opt.hlsearch = true   -- Highlight search results
opt.incsearch = true  -- Go to search results immediately
opt.ignorecase = true -- make search case insensitive

-- Copy to/from system clipboard
if fn.has("unnamedplus") == 1 then
  opt.clipboard = { "unnamed", "unnamedplus" }
else
  opt.clipboard = "unnamed"
end

-- Add the Copy Absolute Path command
vim.cmd("command! CAP let @+ = expand('%:p')")

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Keep visual selection after indenting
km.set('v', '<', '<gv', { noremap = true })
km.set('v', '>', '>gv', { noremap = true })

-- Disable hlsearch on double excape tap in normal mode
km.set('n', '<Esc><Esc>', ':noh<CR>', { silent = true, noremap = true })

-- Switch gm and gM
km.set('n', 'gm', 'gM', { noremap = true })
km.set('n', 'gM', 'gm', { noremap = true })
