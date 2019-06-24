" vim-plug settings

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', 
Plug 'sheerun/vim-polyglot'
call plug#end()

" Other settings
:set number
:set hlsearch
