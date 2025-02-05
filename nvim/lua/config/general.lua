-- Settings in this file are always applied
local opt = vim.opt
local fn = vim.fn

vim.g.mapleader = " "

opt.number = true    -- Show line numbers
opt.hlsearch = true  -- Highlight search results
opt.incsearch = true -- Go to search results immediately

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
