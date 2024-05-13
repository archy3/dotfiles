if has('eval') " vim-tiny does not have `eval`
  finish
endif

set nocompatible
set viminfo=""
set viminfofile="NONE"
set ttymouse=sgr " needed for mouse to work in tmux
runtime! init/general.vim
nnoremap Y y$
