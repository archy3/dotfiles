setlocal spell

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
endif
