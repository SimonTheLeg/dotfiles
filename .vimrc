" vim-plug settings

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', 
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'wincent/terminus'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'asvetliakov/vim-easymotion' "Fork needed for VSCode integration
Plug 'tpope/vim-abolish' 
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

