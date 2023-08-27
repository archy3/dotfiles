" folding
function FoldBraces()
  let l:current_winview=winsaveview()
  normal! zE
  silent %g /^}$/ normal! zf%
  normal! zR
  call winrestview(l:current_winview)
endfunction

call FoldBraces()
call SetTabBehavior(4,8)

setlocal colorcolumn=115

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
endif
