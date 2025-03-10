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
vnoremap <buffer> <Leader>c <plug>(vimtex-cmd-create)
inoremap <buffer> <C-f><C-f> <plug>(vimtex-delim-close)
nnoremap <buffer> gz /\\begin{document}<cr>zt
nnoremap <buffer> <LocalLeader><C-s> :silent! if bufname('%') == '' <bar> exec ':saveas ' . tempname() . '.tex' <bar> endif <bar> redraw<cr>
  " We use `:saveas` instead of `:w` because of https://github.com/lervag/vimtex/issues/3042

" From https://unix.stackexchange.com/a/406415
command! -range -buffer Pshuf :exec '<line1>,<line2>! awk -v seed="$RANDOM" ' . "\'" . 'BEGIN{srand(seed); n=rand()} {print n, NR, $0} NF==0 {n=rand()} END {if (NF) print n, NR+1, ""}' . "\'" . ' | sort -nk1 -k2 | cut -d" " -f3- | sed ' . "\'" . '$d' . "\'"
