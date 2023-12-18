call SetTabBehavior(4,8)

setlocal colorcolumn=90
setlocal spell
setlocal nowrap
setlocal iskeyword-=_

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal wrap<'
  let b:undo_ftplugin .= '|setlocal iskeyword<'
endif

nnoremap <buffer> <Leader>r :call UltiSnips#RefreshSnippets()<cr>
