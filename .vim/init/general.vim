" These setting are defaults on some systems but not on
" others so they are included here for safety.
set backspace=indent,eol,start
set noerrorbells visualbell t_vb=
set encoding=utf-8
set ruler
set showcmd

" For secuirity
set nomodeline

" disable vim intro screen
set shortmess+=I

" Show what search result (out of total number of search results) you're on:
set shortmess-=S

set incsearch
set ignorecase
set smartcase
" use "/search_term\C" for case sensitive search

" No time limit for key mappings, but time limit in ms for escape sequences:
set notimeout
set ttimeout
set ttimeoutlen=50

set splitbelow
set splitright
set hidden

set number relativenumber
set mouse=a
set colorcolumn=80
set wildmenu

" Outside of gvim, always show status line
" (not needed in gvim because this is shown in the window title):
if (has("gui_running") == 0)
  set laststatus=2
endif

" Make vertical motions like CTRL-F, CTRL-B, gg, etc preserve horizontal
" cursor position:
set nostartofline

" Make sidescrolling scroll one character at a time instead of the default
" half a screen at a time.
set sidescroll=1

" Prevent long lines at the bottom of the screen from making an @-abyss:
set display+=lastline

" See this for more options: https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
set listchars=space:·,tab:——>,eol:¶,nbsp:⍽

" Insert 1 space after a period instead of 2 with 'J':
set nojoinspaces

" Disable cursor blink when not editing:
"let &guicursor = substitute(&guicursor, 'n-v-c:', '&blinkon0-', '')


if &t_Co > 2 || has("gui_running")
  syntax on
  autocmd vimenter * nested colorscheme gruvbox
  "autocmd vimenter * hi Normal guifg=#FFD7AF
  set background=dark
endif

" Set path in order to use gf and :find effectively:
set path+=~
set path+=~/scripts
set path+=~/scripts/autostart
