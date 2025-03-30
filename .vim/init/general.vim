" These setting are defaults on some systems but not on
" others so they are included here for safety.
set backspace=indent,eol,start
set noerrorbells
set visualbell t_vb=
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

set number
set relativenumber
set mouse=a
set mousemodel=extend
set colorcolumn=80,100,120
set wildmenu

" Make gf work for assignments like "profile=/etc/profile"
set isfname-==

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

" Insert 1 space after a period instead of 2 with 'J':
set nojoinspaces

" See this for more options: https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
set listchars=space:·,tab:——>,eol:¶,nbsp:⍽

" Outside of gvim, always show status line
" (not needed in gvim because this is shown in the window title):
"if !has("gui_running")
"  set laststatus=2
"endif

" To try out (see also 'rulerformat'):
" Status line that includes if DOS newlines are used:
" set statusline=%<%f\ %h%r%=%{&ff==#'dos'?'[dos]\ ':''}%-14.(%l,%c%V%)\ %P

"set rulerformat=%24(%=%l/%L\ %-5.(%c%V%)\ [%{&fileformat}]%)
set rulerformat=%17(%=%l/%L\ %-5.(%c%V%)%)

set titlelen=0
set titlestring=%t
set titlestring+=%(\ %{&readonly&&&modifiable?\"=\":\"\"}
set titlestring+=%{&modified?\"+\":\"\"}
set titlestring+=%{&modifiable?\"\":\"-\"}%)
set titlestring+=%(\ \(%{&filetype==#\"help\"?\"help\":expand(\"%:~:h\")}\)%)
set titlestring+=%{%&filetype==#\"help\"?\"\":\"\ -\ [%{&fileformat}\ %{&filetype}]\"%}
set titlestring+=%a\ -\ %{v:servername==#\"\"?\"VIM\":v:servername}

" tabstop:     How many apparent spaces a literal tab takes up
" shiftwidth:  How many apparent spaces `>>` indents
" softtabstop: How many apparent spaces pressing `tab` in insert mode inserts
" expandtab:   If true, tab inserts literal spaces instead of a literal tab
set tabstop=8
set shiftwidth=4
set softtabstop=-1 " set softtabstop to shiftwidth
set expandtab

" Let Zathura (with ps support) handle printing:
set printexpr=system('<\ '\ .\ v:fname_in\ .\ '\ zathura\ -\ &')\ .\
  \ delete(v:fname_in)\ +\ v:shell_error

" Set printer margins:
set printoptions+=left:5pc,right:5pc,top:5pc,bottom:5pc

" Print without syntax highlighting, and with line numbers:
set printoptions+=syntax:n
set printoptions+=number:y

" Make vim use the correct mouse when in a tmux session:
if $TERM =~# '^\(tmux\|screen\)\(-.*\)\?$'
  set ttymouse=sgr
endif

" Set path in order to use gf and :find effectively:
set path+=~
set path+=~/scripts
set path+=~/scripts/autostart

if &t_Co > 2 || has("gui_running")
  try
    packadd! gruvbox
  catch /^Vim\%((\a\+)\)\=:E919:/
    finish
  endtry
  syntax on

  augroup gruvbox_autocmd
    autocmd!
    autocmd vimenter * ++nested colorscheme gruvbox
  augroup END

  " Make gruvbox colors, italics, and spell underlining work in
  " xterm (or terminals that report as xterm) and tmux:
  if $TERM =~# '^\(xterm\|tmux\)-.*color.*$' && !has("gui_running")
    let g:gruvbox_italic=1
    autocmd gruvbox_autocmd vimenter * hi SpellBad cterm=underline
    autocmd gruvbox_autocmd vimenter * hi SpellRare cterm=underline
    autocmd gruvbox_autocmd vimenter * hi SpellCap cterm=underline
    autocmd gruvbox_autocmd vimenter * hi SpellLocal cterm=underline
      " See also this: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
    set termguicolors
  endif

  " For gvim, when hlsearch is on, set distinctive cursor color
  " (#AD7CBF is a bit more subtle) and disable (normal mode) blinking.
  augroup hlsearch_cursor_toggle
    autocmd!
    autocmd OptionSet hlsearch exec &hlsearch ?
      \ 'hi Cursor guifg=#00FFFF guibg=#000000 | set guicursor+=n:blinkon0' :
      \ 'hi Cursor guifg=NONE    guibg=NONE    | set guicursor-=n:blinkon0'
  augroup END
  "autocmd vimenter * hi Normal guifg=#FFD7AF
  set background=dark
endif
