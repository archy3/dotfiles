" folding
" currently this this messes things up
"set foldmethod=marker
"set foldmarker={,}
"set foldlevelstart=99
function! FoldBracesAndParenthesesSh()
  if !(&diff) " skip when using vimdiff
    let l:current_winview=winsaveview()
    "silent %g /^ *}$/ normal! zf%
    "silent %g /^ *)$/ normal! zf%
    "silent %g /^)$/ exec 'normal!' "zf?^(?0\<CR>"
    normal! zE
    silent %g /^)$/ exec 'normal!' 'zf?^\([^ \t].*($\|^($\)?0' . "\<CR>"
    silent %g /^}$/ normal! zf%
    normal! zR
    call winrestview(l:current_winview)
  endif
endfunction

call FoldBracesAndParenthesesSh()
call SetTabBehavior(2,8)

"setlocal smartindent
" Try these instead (from https://vim.fandom.com/wiki/Restoring_indent_after_typing_hash)

"setlocal cindent
"setlocal cinkeys-=0#
"setlocal indentkeys-=0#


"if exists('b:undo_ftplugin')
  "let b:undo_ftplugin .= '|setlocal smartindent<'
  "let b:undo_ftplugin .= '|setlocal cindent<'
  "let b:undo_ftplugin .= '|setlocal cinkeys<'
  "let b:undo_ftplugin .= '|setlocal indentkeys<'
"endif

" Remaps:
"nnoremap <buffer> <Leader>R :!shellcheck --color=never -- %:p:S<cr>
nnoremap <buffer> <Leader>R :w !shellcheck --color=never -- -<cr>
nnoremap <buffer> <Leader>r :call UltiSnips#RefreshSnippets()<cr>
