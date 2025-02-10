local M = {}

local excluded_filetypes = {
  "gitcommit",
}

local excluded_filenames = {}

M.Save_condition = function(buf)
  local fn = vim.fn
  local utils = require("auto-save.utils.data")

  if
      utils.not_in(fn.getbufvar(buf, "&filetype"), excluded_filetypes)
      and utils.not_in(fn.expand("%:t"), excluded_filenames)
  then
    return true -- met condition(s), can save
  end
  return false  -- can't save
end

return M
