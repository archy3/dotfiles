" See https://stackoverflow.com/q/1878974 & https://vi.stackexchange.com/q/4141
" tabstop:     How many apparent spaces a literal tab takes up
" shiftwidth:  How many apparent spaces `>>` indents
" softtabstop: How many apparent spaces pressing `tab` in insert mode inserts
" expandtab:   If true, tab inserts literal spaces instead of a literal tab
function SetTabBehavior(indent_length, literal_tab_length)
  let &l:shiftwidth=a:indent_length
  let &l:tabstop=a:literal_tab_length

  if a:indent_length == a:literal_tab_length
    " This is the default behavior when both args equal 8:
    setlocal softtabstop=0 " pressing tab just inserts a tab
    setlocal noexpandtab
  else
    setlocal softtabstop=-1 " set softtabstop to shiftwidth
    setlocal expandtab " replace inserted tabs with softtabstop number of spaces
    " Thus pressing tab in inset mode will insert "space_count" spaces but any
    " literal tabs will still appear as "literal_tab_length" spaces long.
  endif

  if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|setlocal tabstop<'
    let b:undo_ftplugin .= '|setlocal shiftwidth<'
    let b:undo_ftplugin .= '|setlocal softtabstop<'
    let b:undo_ftplugin .= '|setlocal expandtab<'
  endif
endfunction
