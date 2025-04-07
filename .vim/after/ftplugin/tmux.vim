call SetTabBehavior(2,8)

if expand('%:p') ==# expand('~/.config/tmux/tmux.conf')
  nnoremap <buffer> gf $gf
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
