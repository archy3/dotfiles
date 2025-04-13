if filereadable($HOME . '/.vim/spell/es.utf-8.spl')
  setlocal spelllang=en,es
endif
setlocal wrap
setlocal linebreak

" We want spellcheck on new (i.e. empty) files
" (e.g. vim just opened without opening a file, opened a file that doesn't exist,
" opened an empty file, or an `enew`):
if line('$') ==# 1 && col('$') ==# 1
  setlocal spell
endif

" Create undo checkpoints when writing prose:
inoremap <buffer> . .<c-g>u
inoremap <buffer> , ,<c-g>u
inoremap <buffer> ; ;<c-g>u
inoremap <buffer> : :<c-g>u
inoremap <buffer> ! !<c-g>u
inoremap <buffer> ? ?<c-g>u
inoremap <buffer> <cr> <c-g>u<cr>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal spelllang<'
  let b:undo_ftplugin .= '|setlocal wrap<'
  let b:undo_ftplugin .= '|setlocal linebreak<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
