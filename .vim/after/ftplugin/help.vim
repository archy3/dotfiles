" List of normal-mode commands that go into insert-mode and thus are useless
" for help: acdiorux
nnoremap <buffer> u <C-]>
nnoremap <buffer> r <C-t>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
