" Enable spellcheck, but do not check capitalization:
setlocal spell
setlocal spellcapcheck=

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal spellcapcheck<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif

" Create undo checkpoints when writing prose:
inoremap <buffer> . .<c-g>u
inoremap <buffer> , ,<c-g>u
inoremap <buffer> ; ;<c-g>u
inoremap <buffer> : :<c-g>u
inoremap <buffer> ! !<c-g>u
inoremap <buffer> ? ?<c-g>u
inoremap <buffer> <cr> <c-g>u<cr>
inoremap <buffer> <space> <c-g>u<space>
