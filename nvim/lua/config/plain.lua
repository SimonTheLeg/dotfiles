-- General settings to be used inside plain neovim

-- highlight current line number
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ABB2BF', bold = true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#545862', bold = true })
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#545862', bold = true })


-- When closing a tab, jump to the most recently used tab instead of the adjacent one
do
  local group = vim.api.nvim_create_augroup('MRUTabClose', { clear = true })
  local tab_history = {}

  vim.api.nvim_create_autocmd("TabEnter", {
    group = group,
    callback = function()
      local current = vim.fn.tabpagenr()
      -- Remove current tab from history to avoid duplicates
      for i = #tab_history, 1, -1 do
        if tab_history[i] == current then
          table.remove(tab_history, i)
        end
      end
      -- Push current tab to top of history
      table.insert(tab_history, current)
    end,
  })

  vim.api.nvim_create_autocmd("TabClosed", {
    group = group,
    callback = function()
      local closed = tonumber(vim.fn.expand('<afile>'))
      if not closed then return end
      -- Remove closed tab from history
      for i = #tab_history, 1, -1 do
        if tab_history[i] == closed then
          table.remove(tab_history, i)
        end
      end
      -- Adjust tab numbers for remaining entries (tabs after closed one shift down)
      for i, t in ipairs(tab_history) do
        if t > closed then
          tab_history[i] = t - 1
        end
      end
      -- Jump to the most recently used tab
      if #tab_history > 0 then
        local target = tab_history[#tab_history]
        local total = vim.fn.tabpagenr('$')
        if target >= 1 and target <= total then
          vim.cmd('tabnext ' .. target)
        end
      end
    end,
  })
end
