" Always enable autosave plugin
let g:auto_save = 1
" Disable autosave for git-commit messages
augroup git_commit_msg
  au!
  au FileType gitcommit let b:auto_save = 0
augroup END

autocmd SwapExists * let v:swapchoice = 'e' "since we are using autosave, it is safe to open the file every time

" make search case insensitive
:set ignorecase

" Remember more files
let MRU_Max_Entries = 1000
" map <C-m> :FZFMru <CR>

" turn hybrid line numbers on
:set number relativenumber

" VSCode specific settings
if exists('g:vscode')
  nnoremap <leader>grc <Cmd>call VSCodeCall('gitlens.copyRemoteFileUrlToClipboard')<CR>
  nnoremap <leader>grC <Cmd>call VSCodeCall('gitlens.openCommitOnRemote')<CR>
  nnoremap <leader>grf <Cmd>call VSCodeCall('gitlens.openFileOnRemote')<CR>
  nnoremap <leader>grr <Cmd>call VSCodeCall('git.revertSelectedRanges')<CR>
  nnoremap <leader>wl <Cmd>call VSCodeCall('rewrap.rewrapComment')<CR>
  nnoremap <leader>ld <Cmd>call VSCodeCall('go.debug.cursor')<CR>
  nnoremap <leader>lt <Cmd>call VSCodeCall('testing.runAtCursor')<CR>
  nnoremap <leader>lT <Cmd>call VSCodeCall('testing.runCurrentFile')<CR>
  nnoremap <leader>lb <Cmd>call VSCodeCall('editor.debug.action.toggleBreakpoint')<CR>
  nnoremap <leader>lfi <Cmd>call VSCodeCall('references-view.findImplementations')<CR>
  nnoremap <leader>lot <Cmd>call VSCodeCall('go.toggle.test.file')<CR>
  nnoremap <leader>lr <Cmd>call VSCodeCall('editor.action.rename')<CR>
  nnoremap <leader>lP <Cmd>call VSCodeCall('editor.action.marker.prev')<CR>
  nnoremap <leader>lp <Cmd>call VSCodeCall('editor.action.marker.next')<CR>
  nnoremap <leader>li <Cmd>call VSCodeCall('go.import.add')<CR>
  nnoremap zi <Cmd>call VSCodeCall('editor.fold')<CR>
  nnoremap <leader>tt <Cmd>call VSCodeCall('workbench.action.toggleLightDarkThemes')<CR>
  nnoremap <leader>rr <Cmd>call VSCodeCall('workbench.action.reloadWindow')<CR>
  nnoremap <C-w>z <Cmd>call VSCodeCall('workbench.action.minimizeOtherEditors')<CR>
endif

" Keep visual selection after indenting
:vnoremap < <gv
:vnoremap > >gv

" Go specific Macros
let @j = '0wyiwA`json:"pb~A,omitempty"`' "json struct tag

" Markdown specific Macros
let @l = '`<i[`>ea]()h'

" Disable hlsearch on double escape tap in normal mode
nnoremap <silent> <Esc><Esc> :noh<CR>

" Do not automatically wrap lines by default
:set nowrap

" Switch gm and gM
nnoremap gm gM
nnoremap gM gm
