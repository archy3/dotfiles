if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif

" Create undo checkpoints when making edits:
inoremap <buffer> <cr> <c-g>u<cr>
inoremap <buffer> <space> <c-g>u<space>
inoremap <buffer> <backspace> <c-g>u<backspace>
