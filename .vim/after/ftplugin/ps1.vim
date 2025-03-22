call FoldBraces()
call SetTabBehavior(4,8)

setlocal colorcolumn=115
setlocal formatoptions+=j

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
  let b:undo_ftplugin .= '|setlocal formatoptions<'
endif
