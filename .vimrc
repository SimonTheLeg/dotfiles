" change cursor to line after exiting vim
" required due to https://github.com/neovim/neovim/issues/4396
:autocmd VimLeave * set guicursor=a:ver30-blinkoff

" VSCode specific settings
if exists('g:vscode')
  " Git Operations
  nnoremap <leader>grc <Cmd>call VSCodeCall('gitlens.copyRemoteFileUrlToClipboard')<CR>
  nnoremap <leader>grC <Cmd>call VSCodeCall('gitlens.openCommitOnRemote')<CR>
  nnoremap <leader>grf <Cmd>call VSCodeCall('gitlens.openFileOnRemote')<CR>
  nnoremap <leader>grr <Cmd>call VSCodeCall('git.revertSelectedRanges')<CR>
  nnoremap <leader>gh <Cmd>call VSCodeCall('git.viewLineHistory')<CR>
  vnoremap <leader>gh <Cmd>call VSCodeCall('git.viewLineHistory')<CR>

  " Language Server Operations
  nnoremap <leader>wl <Cmd>call VSCodeCall('rewrap.rewrapComment')<CR>
  nnoremap <leader>ld <Cmd>call VSCodeCall('go.debug.cursor')<CR>
  nnoremap <leader>lt <Cmd>call VSCodeCall('testing.runAtCursor')<CR>
  nnoremap <leader>lT <Cmd>call VSCodeCall('testing.runCurrentFile')<CR>
  nnoremap <leader>lb <Cmd>call VSCodeCall('editor.debug.action.toggleBreakpoint')<CR>
  nnoremap <leader>lfi <Cmd>call VSCodeCall('references-view.findImplementations')<CR>
  nnoremap <leader>lot <Cmd>call VSCodeCall('go.toggle.test.file')<CR>
  nnoremap <leader>lc <Cmd>call VSCodeCall('go.test.coverage')<CR>
  nnoremap <leader>lr <Cmd>call VSCodeCall('editor.action.rename')<CR>
  nnoremap <leader>lP <Cmd>call VSCodeCall('editor.action.marker.prev')<CR>
  nnoremap <leader>lp <Cmd>call VSCodeCall('editor.action.marker.next')<CR>
  nnoremap <leader>li <Cmd>call VSCodeCall('go.import.add')<CR>
  " VsCode Management
  nnoremap <leader>tt <Cmd>call VSCodeCall('workbench.action.toggleLightDarkThemes')<CR>
  nnoremap <leader>rr <Cmd>call VSCodeCall('workbench.action.reloadWindow')<CR>
  nnoremap <C-w>z <Cmd>call VSCodeCall('workbench.action.minimizeOtherEditors')<CR>

  " Json Management
  nnoremap <leader>jp <Cmd>call VSCodeCall('extension.prettyJSON')<CR>
  nnoremap <leader>jm <Cmd>call VSCodeCall('extension.minifyJSON')<CR>
  vnoremap <leader>jp <Cmd>call VSCodeCall('extension.prettyJSON')<CR>
  vnoremap <leader>jm <Cmd>call VSCodeCall('extension.minifyJSON')<CR>
endif

" Go specific Macros
let @j = '0wyiwA`json:"pb~A,omitempty"`' "json struct tag

" Markdown specific Macros
let @l = '`<i[`>ea]()h'
