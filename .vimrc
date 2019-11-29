" vim-plug settings

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', 
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'wincent/terminus'
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

" Nertoggle remap
map <C-n> :NERDTreeToggle<CR>
