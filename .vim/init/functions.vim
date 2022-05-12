" See https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces/1878983 and
" https://vi.stackexchange.com/questions/4141/how-to-indent-as-spaces-instead-of-tab
" tabstop: How may apparent spaces a literal tab takes up
" shiftwidth: How may apparent spaces '>>' indents
" softtabstop: How may apparent spaces pressing 'tab' in insert mode inserts
" expandtab: If true, pressing tab in insert mode inserts literal spaces instead of a literal tab
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
