" Enable spellcheck, but do not check capitalization:
setlocal spell
setlocal spellcapcheck=

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal spellcapcheck<'
endif
