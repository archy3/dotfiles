" folding
" currently this this messes things up
"set foldmethod=marker
"set foldmarker={,}
"set foldlevelstart=99
function! s:FoldBracesAndParentheses()
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

call s:FoldBracesAndParentheses()
call SetTabBehavior(2,8)

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
  let b:undo_ftplugin .= '|delcommand -buffer FoldBracesAndParentheses'
endif

" Remaps:
"nnoremap <buffer> <Leader>R :!shellcheck --color=never -- %:p:S<cr>
nnoremap <buffer> <Leader>R :w !shellcheck --color=never -- -<cr>
nnoremap <buffer> <Leader>r :call UltiSnips#RefreshSnippets()<cr>

command! -buffer FoldBracesAndParentheses call <SID>FoldBracesAndParentheses()
