" These setting are defaults on some systems but not on
" others so they are included here for safety.
set backspace=indent,eol,start
set noerrorbells visualbell t_vb=
set encoding=utf-8
set ruler
set showcmd

" For security
set nomodeline

" Disable wrapping
set nowrap

" Preserve xattr's
set backupcopy=yes

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
set colorcolumn=80,100,120
set wildmenu

" Outside of gvim, always show status line
" (not needed in gvim because this is shown in the window title):
"if (has("gui_running") == 0)
"  set laststatus=2
"endif

" Make vertical motions like CTRL-F, CTRL-B, gg, etc preserve horizontal
" cursor position:
set nostartofline

" Make sidescrolling scroll one character at a time instead of the default
" half a screen at a time.
set sidescroll=1

" Prevent long lines at the bottom of the screen from making an @-abyss:
set display+=lastline

" Make <enter> while in a comment start the next line on a comment, and
" make J remove leading <comment string> from comments below current line.
set formatoptions+=rj

" See this for more options: https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
set listchars=space:·,tab:——>,eol:¶,nbsp:⍽

"set rulerformat=%24(%=%l/%L\ %-5.(%c%V%)\ [%{&fileformat}]%)
set rulerformat=%17(%=%l/%L\ %-5.(%c%V%)%)

set titlelen=0
set titlestring=%t
set titlestring+=%(\ %{&readonly&&&modifiable?\"=\":\"\"}
set titlestring+=%{&modified?\"+\":\"\"}
set titlestring+=%{&modifiable?\"\":\"-\"}%)
set titlestring+=%(\ \(%{&filetype==\"help\"?\"help\":expand(\"%:~:h\")}\)%)
set titlestring+=%{%&filetype==\"help\"?\"\":\"\ -\ [%{&fileformat}\ %{&filetype}]\"%}
set titlestring+=%a\ -\ %{v:servername==\"\"?\"VIM\":v:servername}

" Insert 1 space after a period instead of 2 with 'J':
set nojoinspaces

" tabstop:     How many apparent spaces a literal tab takes up
" shiftwidth:  How many apparent spaces `>>` indents
" softtabstop: How many apparent spaces pressing `tab` in insert mode inserts
" expandtab:   If true, tab inserts literal spaces instead of a literal tab
set tabstop=8
set shiftwidth=4
set softtabstop=-1 " set softtabstop to shiftwidth
set expandtab

" Disable cursor blink when not editing:
"let &guicursor = substitute(&guicursor, 'n-v-c:', '&blinkon0-', '')


if &t_Co > 2 || has("gui_running")
  packadd! gruvbox
  syntax on

  " Make gruvbox colors, italics, and spell underlining work in xterm w/wo tmux:
  if $TERM =~ '^\(xterm\|tmux\)-.*color.*$' && $XTERM_VERSION != '' && (has("gui_running") == 0)
    let g:gruvbox_italic=1
    autocmd vimenter * ++nested colorscheme gruvbox
    autocmd vimenter * hi SpellBad cterm=underline
    autocmd vimenter * hi SpellRare cterm=underline
    autocmd vimenter * hi SpellCap cterm=underline
    autocmd vimenter * hi SpellLocal cterm=underline
      " See also this: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
    set termguicolors
    if $TERM =~ '^tmux-.*color.*$'
      " See :h xterm-true-color
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
  else
    autocmd vimenter * ++nested colorscheme gruvbox
  endif
  "autocmd vimenter * hi Normal guifg=#FFD7AF
  set background=dark
endif

" Set path in order to use gf and :find effectively:
set path+=~
set path+=~/scripts
set path+=~/scripts/autostart
