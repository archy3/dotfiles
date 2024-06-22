call FoldBraces()
call SetTabBehavior(4,8)

setlocal colorcolumn=115

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
endif
