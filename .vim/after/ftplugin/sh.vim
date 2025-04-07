" folding
" currently this this messes things up
"set foldmethod=marker
"set foldmarker={,}
"set foldlevelstart=99
function! s:FoldBracesAndParentheses() abort
  if !(&diff) " skip when using vimdiff
    let l:current_winview=winsaveview()
    "silent %g /^ *}$/ keepjumps normal! zf%
    "silent %g /^ *)$/ keepjumps normal! zf%
    "silent %g /^)$/ exec 'keepjumps normal!' "zf?^(?0\<CR>"
    keepjumps normal! zE
    silent %g /^)$/ exec 'keepjumps normal!' 'zf?^\([^ \t].*($\|^($\)?0' . "\<CR>"
    silent %g /^}$/ keepjumps normal! zf%
    keepjumps normal! zR
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
