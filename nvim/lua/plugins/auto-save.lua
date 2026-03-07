local excluded_filetypes = {
  "gitcommit",
}

local excluded_filenames = {}

return {
  'okuuva/auto-save.nvim',
  cond = not vim.g.vscode,
  opts = {
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      if
          utils.not_in(fn.getbufvar(buf, "&filetype"), excluded_filetypes)
          and utils.not_in(fn.expand("%:t"), excluded_filenames)
      then
        return true -- met condition(s), can save
      end
      return false  -- can't save
    end,
    debounce_delay = 200,
  },
}
