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

" Plugins to use inside VSCode nvim
"
" Currently not useable, because vim-plug does not allow for two plugins to
" have the same name https://github.com/junegunn/vim-plug/issues/331#issuecomment-160170317
" Plug 'asvetliakov/vim-easymotion' " Cond(exists('g:vscode')) Fork needed for VSCode integration

call plug#end()

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
map <C-n> :NERDTreeToggle<CR>

" Remap easymotion
map <Leader> <Plug>(easymotion-prefix)

