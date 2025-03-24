" Indent two literal spaces and show literal tabs as 8 spaces:
call SetTabBehavior(2,8)

" Set folding around {{{,}}} for .vim files:
"set foldlevelstart=99
setlocal foldmethod=marker
normal! zR

if has('win32')
  setlocal path+=~/vimfiles/init/
  setlocal path+=~/vimfiles/after/ftplugin
  setlocal path+=~/vimfiles/plugin
else
  setlocal path+=~/.vim/init/
  setlocal path+=~/.vim/after/ftplugin
  setlocal path+=~/.vim/plugin
endif

" Remaps:
nnoremap <buffer> gf $gf
nnoremap <buffer> <Leader>gf gf

nnoremap <buffer> <Leader>r :source $MYVIMRC<cr>

" Execute contents of paste register:
cnoremap <buffer> <C-f><C-r> @"<cr>
cnoremap <buffer> <C-f>r @"<cr>

" Reverts:
" Stop 'o' from adding '" ' to the line bellow a comment:
setlocal formatoptions-=o


if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal foldmethod<'
  let b:undo_ftplugin .= '|setlocal formatoptions<'
  let b:undo_ftplugin .= '|setlocal path<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
