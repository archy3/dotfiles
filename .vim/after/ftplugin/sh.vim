" folding
" currently this this messes things up
"set foldmethod=marker
"set foldmarker={,}
"set foldlevelstart=99
function FoldBracesAndParenthesesSh()
  let l:current_winview=winsaveview()
  "silent %g /^ *}$/ normal! zf%
  "silent %g /^ *)$/ normal! zf%
  "silent %g /^)$/ exec 'normal!' "zf?^(?0\<CR>"
  normal! zE
  silent %g /^)$/ exec 'normal!' 'zf?^\([^ \t].*($\|^($\)?0' . "\<CR>"
  silent %g /^}$/ normal! zf%
  normal! zR
  call winrestview(l:current_winview)
endfunction

call FoldBracesAndParenthesesSh()
call SetTabBehavior(2,8)

"setlocal smartindent
" Try these instead (from https://vim.fandom.com/wiki/Restoring_indent_after_typing_hash)

"setlocal cindent
"setlocal cinkeys-=0#
"setlocal indentkeys-=0#

setlocal formatoptions+=rj

if exists('b:undo_ftplugin')
  "let b:undo_ftplugin .= '|setlocal smartindent<'
  "let b:undo_ftplugin .= '|setlocal cindent<'
  "let b:undo_ftplugin .= '|setlocal cinkeys<'
  "let b:undo_ftplugin .= '|setlocal indentkeys<'
  let b:undo_ftplugin .= '|setlocal formatoptions<'
endif

" Remaps:
"nnoremap <buffer> <Leader>R :!shellcheck --color=never -- %:p:S<cr>
nnoremap <buffer> <Leader>R :w !shellcheck --color=never -- -<cr>


" Snippets:
inoremap <buffer> <C-f>f () #<CR>{<CR>}<C-o>O

" The temporary "T" is so that smartindent uses the correct indention level.
inoremap <buffer> <C-f>c T<C-o>ofi<up><end><BS>if [ "$" = "" ]; then<C-o>T$

inoremap <buffer> <C-f>C [ "$" = "" ]<C-o>T$

inoremap <buffer> <C-f>j "$"<left>
inoremap <buffer> <C-f>h "${}"<left><left>
inoremap <buffer> <C-f>g "$()"<left><left>

inoremap <buffer> <C-f>y ${}<left>
inoremap <buffer> <C-f>t $()<left>
