" vim-plug settings

" Helper function to allow for conditional imports of plugins
" I need conditional imports because I am using nvim both as
" standalone and inside VSCode
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.vim/plugged')

" Plugins to ALWAYS use
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'wincent/terminus'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-abolish' 
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-obsession'

" Plugins to only use inside PLAIN nvim
Plug 'airblade/vim-gitgutter', Cond(!exists('g:vscode'))
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'ncm2/ncm2', Cond(!exists('g:vscode'))
Plug 'roxma/nvim-yarp', Cond(!exists('g:vscode'))
Plug 'ncm2/ncm2-bufword', Cond(!exists('g:vscode'))
Plug 'ncm2/ncm2-path', Cond(!exists('g:vscode'))
Plug 'ncm2/ncm2-go', Cond(!exists('g:vscode'))
Plug 'ncm2/ncm2-racer', Cond(!exists('g:vscode'))
Plug 'ekalinin/Dockerfile.vim', Cond(!exists('g:vscode'), {'for' : 'Dockerfile'})
Plug 'hashivim/vim-hashicorp-tools', Cond(!exists('g:vscode'))
Plug 'fatih/vim-go', Cond(!exists('g:vscode'), { 'do': ':GoUpdateBinaries' })
Plug 'rust-lang/rust.vim', Cond(!exists('g:vscode'))
Plug 'junegunn/fzf', Cond(!exists('g:vscode'), { 'do': './install --bin' })
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))
Plug 'iamcco/markdown-preview.nvim', Cond(!exists('g:vscode'))
Plug 'Chiel92/vim-autoformat', Cond(!exists('g:vscode'))
Plug 'itchyny/lightline.vim', Cond(!exists('g:vscode'))
Plug 'christianrondeau/vim-base64', Cond(!exists('g:vscode'))
Plug 'chuling/vim-equinusocio-material', Cond(!exists('g:vscode'))
Plug 'PeterRincker/vim-searchlight', Cond(!exists('g:vscode'))
Plug '907th/vim-auto-save', Cond(!exists('g:vscode'))
Plug 'zirrostig/vim-schlepp', Cond(!exists('g:vscode'))
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'))
Plug 'jlanzarotta/bufexplorer', Cond(!exists('g:vscode'))
Plug 'pbogut/fzf-mru.vim', Cond(!exists('g:vscode'))
Plug 'christoomey/vim-tmux-navigator', Cond(!exists('g:vscode'))
Plug 'chriskempson/base16-vim', Cond(!exists('g:vscode'))
Plug 'mhinz/vim-startify', Cond(!exists('g:vscode'))
Plug 'nvim-lua/popup.nvim', Cond(!exists('g:vscode'))
Plug 'nvim-lua/plenary.nvim', Cond(!exists('g:vscode'))
Plug 'nvim-telescope/telescope.nvim', Cond(!exists('g:vscode'))
Plug 'chrisbra/NrrwRgn', Cond(!exists('g:vscode'))

" Plugins to use inside VSCode nvim
"
" Currently not useable, because vim-plug does not allow for two plugins to
" have the same name https://github.com/junegunn/vim-plug/issues/331#issuecomment-160170317
" Plug 'asvetliakov/vim-easymotion' " Cond(exists('g:vscode')) Fork needed for VSCode integration

call plug#end()

" Plain Neovim Only options
if !exists('g:vscode')

  " enable ncm2 for all buffers
  autocmd BufEnter * call ncm2#enable_for_buffer()
  " Set colorscheme
  colorscheme base16-onedark
  set termguicolors

endif

" Other settings
:set number
:set hlsearch
:set incsearch

" Yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" Nertoggle remap
map <C-e> :NERDTreeToggle<CR>

" //TODO temporarily disabled
" FZF remap
" map <C-[> :Files<CR>

" easier sourcing of current file; noh is required because some setting always
" puts the current character in search buffer after sourcing
" nmap <C-S> :w<CR>:so %<CR>:noh<CR>

" " IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" " When the <Enter> key is pressed while the popup menu is visible, it only
" " hides the menu. Use this mapping to close the menu and also start a new
" " line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" " Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set updatetime=100

set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
:set listchars=tab:->,trail:·,extends:>,precedes:<,space:·
:set list

" GitGutter settings
highlight LineNr ctermfg=grey
highlight GitGutterAdd    guifg=#009900 guibg=<X> ctermfg=2
highlight GitGutterChange guifg=#bbbb00 guibg=<X> ctermfg=3
highlight GitGutterDelete guifg=#ff2222 guibg=<X> ctermfg=1
:syntax on

" Disable line numbers in terminal mode
augroup TerminalStuff
   au!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" " Vim Go settings
let g:go_fmt_command = "goimports"

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Copy absolute path
:command! CAP let @+ = expand('%:p')

" Create parent directoy on save if it does not already exist
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Disable the normal status bar (e.g. -- INSERT --) because it's shown in
" lightline
set noshowmode

" Map hide search highlight to C-h to make it easier
map <C-h> :noh <CR>

" Colourscheme settings
set termguicolors

" Additional bindings for the vim-base64 plugin
vnoremap <silent> <leader>e :<c-u>call base64#v_btoa()<cr>
vnoremap <silent> <leader>d :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>atob :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>btoa :<c-u>call base64#v_btoa()<cr>vnoremap <silent> <leader>atob :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>btoa :<c-u>call base64#v_btoa()<cr>vnoremap <silent> <leader>atob :<c-u>call base64#v_atob()<cr>
vnoremap <silent> <leader>btoa :<c-u>call base64#v_btoa()<cr>

" Always enable autosave plugin
let g:auto_save = 1
" Disable autosave for git-commit messages
augroup git_commit_msg
  au!
  au FileType gitcommit let b:auto_save = 0
augroup END

autocmd SwapExists * let v:swapchoice = 'e' "since we are using autosave, it is safe to open the file every time

" " vim-schlepp bindings
" vmap <unique> D <Plug>SchleppDup
" vmap <unique> <up>    <Plug>SchleppUp
" vmap <unique> <down>  <Plug>SchleppDown
" vmap <unique> <left>  <Plug>SchleppLeft
" vmap <unique> <right> <Plug>SchleppRight

" make search case insensitive
:set ignorecase

" Remember more files
let MRU_Max_Entries = 1000
" map <C-m> :FZFMru <CR>

" settings for tmux seamless navigation
" let g:tmux_navigator_no_mappings = 1
" nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
" nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
" nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
" nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
" nnoremap <silent> <C-w>\ :TmuxNavigatePrevious<cr>

" Disable quote header for startify
let g:startify_custom_header = []
let g:startify_padding_left = 50 " Hard coded padding for lists

let g:nrrw_rgn_nohl = 1
" Always disable automatic writing back, as I mainly use NR for viewing
" certificates
let b:nrrw_aucmd_create = ":NRN"
let g:nrrw_rgn_resize_window = "relative"
let g:nrrw_rgn_rel_min = 30

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

" VSCode specific settings
if exists('g:vscode')
  nnoremap <leader>ld <Cmd>call VSCodeCall('go.debug.cursor')<CR>
  nnoremap <leader>lt <Cmd>call VSCodeCall('testing.runAtCursor')<CR>
  nnoremap <leader>lT <Cmd>call VSCodeCall('testing.runCurrentFile')<CR>
  nnoremap <leader>lb <Cmd>call VSCodeCall('editor.debug.action.toggleBreakpoint')<CR>
  nnoremap <leader>lgc <Cmd>call VSCodeCall('gitlens.copyRemoteFileUrlToClipboard')<CR>
  nnoremap <leader>lgC <Cmd>call VSCodeCall('gitlens.openCommitOnRemote')<CR>
  nnoremap <leader>lgf <Cmd>call VSCodeCall('gitlens.openFileOnRemote')<CR>
  nnoremap <leader>lfi <Cmd>call VSCodeCall('references-view.findImplementations')<CR>
  nnoremap <leader>lw <Cmd>call VSCodeCall('rewrap.rewrapComment')<CR>
  nnoremap <leader>lot <Cmd>call VSCodeCall('go.toggle.test.file')<CR>
  nnoremap <leader>lr <Cmd>call VSCodeCall('editor.action.rename')<CR>
  nnoremap <leader>lP <Cmd>call VSCodeCall('editor.action.marker.prev')<CR>
  nnoremap <leader>lp <Cmd>call VSCodeCall('editor.action.marker.next')<CR>
  nnoremap zi <Cmd>call VSCodeCall('editor.fold')<CR>
endif

" Keep visual selection after indenting
:vnoremap < <gv
:vnoremap > >gv

" Go specific Macros
let @j = '0wyiwA`json:"pb~A"`' "json struct tag

" Disable hlsearch on double escape tap in normal mode
nnoremap <silent> <Esc><Esc> :noh<CR>
