-- Reload buffers when the file changes on disk (e.g. edited by an AI agent in another zellij pane),
-- even while this pane is not focused. Uses a timer in addition to the BufEnter/FocusGained events.
return {
  'ccntrq/autoreload.nvim',
  cond = not vim.g.vscode,
  event = "BufReadPre",
  opts = {
    timer = {
      enabled = true,
      interval_ms = 1000,
    },
  },
}
