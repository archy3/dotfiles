" Indent two literal spaces and show literal tabs as 8 spaces:
call SetTabBehavior(2,8)

"setlocal smartindent
"if exists('b:undo_ftplugin')
"  let b:undo_ftplugin .= '|setlocal smartindent<'
"endif

" Set folding around {{{,}}} for .vim files:
"set foldlevelstart=99
setlocal foldmethod=marker
if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal foldmethod<'
endif
normal! zR

setlocal path+=~/.vim/init/
setlocal path+=~/.vim/after/ftplugin

" Remaps:
nnoremap <buffer> gf $gf
nnoremap <buffer> <Leader>gf gf

"nnoremap <Leader>r :%y"<cr>:@"<cr>
nnoremap <buffer> <Leader>r :source $MYVIMRC<cr>
cnoremap <buffer> <C-f><C-r> @"<cr>
cnoremap <buffer> <C-f>r @"<cr>

" Reverts:
" Stop 'o' from adding '" ' to the line bellow a comment:
setlocal formatoptions-=o
