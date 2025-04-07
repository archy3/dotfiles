call SetTabBehavior(4,8)

setlocal colorcolumn=90
setlocal spell
setlocal nowrap
setlocal iskeyword-=_

" vimtex (the plugin) does not define `b:undo_ftplugin`.
if !exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
  let b:undo_ftplugin .= '|setlocal spell<'
  let b:undo_ftplugin .= '|setlocal wrap<'
  let b:undo_ftplugin .= '|setlocal iskeyword<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
  let b:undo_ftplugin .= '|delcommand -buffer Pshuf'

  " If `b:undo_ftplugin` was defined as '' before this if-block,
  " then there's an erroneous leading '|'.
  let b:undo_ftplugin = substitute(b:undo_ftplugin, '^|*', '', '')
endif

xnoremap <buffer> <Leader>c <plug>(vimtex-cmd-create)
inoremap <buffer> <C-f><C-f> <plug>(vimtex-delim-close)
nnoremap <buffer> gz /\\begin{document}<cr>zt

nnoremap <buffer> <Leader>r
  \ <cmd>
  \   call UltiSnips#RefreshSnippets() <bar>
  \   echo 'UltiSnips Refreshed!'
  \ <cr>

nnoremap <buffer> <LocalLeader><C-s>
  \ <cmd>
  \   if bufname('%') ==# '' <bar>
  \     exec ':saveas ' . tempname() . '.tex' <bar>
  \   endif <bar>
  \   redraw
  \ <cr>
  " We use `:saveas` instead of `:w` because of
  " https://github.com/lervag/vimtex/issues/3042

xnoremap <buffer> <Leader>i <cmd>call <SID>Surround_with_cmd_by_math_context('textit', 'mathit')<cr>
xnoremap <buffer> <Leader>b <cmd>call <SID>Surround_with_cmd_by_math_context('textbf', 'mathbf')<cr>
xnoremap <buffer> <Leader>t <cmd>call <SID>Surround_with_cmd_by_math_context('texttt', 'mathtt')<cr>
xnoremap <buffer> <Leader>s <cmd>call <SID>Surround_with_cmd_by_math_context('textsf', 'mathsf')<cr>
xnoremap <buffer> <Leader>S <cmd>call <SID>Surround_with_cmd_by_math_context('textsc', 'mathscr')<cr>
xnoremap <buffer> <Leader>e <cmd>call <SID>Surround_with_cmd_by_math_context('emph', '')<cr>
xnoremap <buffer> <Leader>u <cmd>call <SID>Surround_with_cmd_by_math_context('underline', '')<cr>
xnoremap <buffer> <Leader>f <cmd>call <SID>Surround_with_cmd_by_math_context('', 'mathfrak')<cr>
xnoremap <buffer> <Leader>B <cmd>call <SID>Surround_with_cmd_by_math_context('', 'mathbb')<cr>
xnoremap <buffer> <Leader>C <cmd>call <SID>Surround_with_cmd_by_math_context('', 'mathcal')<cr>
xnoremap <buffer> <Leader>r <cmd>call <SID>Surround_with_cmd_by_math_context('', 'mathrm')<cr>
xnoremap <buffer> <Leader>n <cmd>call <SID>Surround_with_cmd_by_math_context('', 'mathnormal')<cr>
xnoremap <buffer> <Leader>T <cmd>call <SID>Surround_with_cmd_by_math_context('', 'text')<cr>

function! s:Surround_with_cmd_by_math_context(normal_cmd, math_cmd) abort
  if vimtex#syntax#in_mathzone() && a:math_cmd !=# ''
    call s:Surround_with_cmd(a:math_cmd)
  elseif !vimtex#syntax#in_mathzone() && a:normal_cmd !=# ''
    call s:Surround_with_cmd(a:normal_cmd)
  endif
endfunction

function! s:Surround_with_cmd(cmd) abort
  call s:Prepend_and_append_selected_text('\' . a:cmd . '{', '}')
endfunction

function! s:Prepend_and_append_selected_text(prefix, suffix) abort
  " Register saving is from https://vi.stackexchange.com/a/28356
  let l:savereg_unnamed = getreginfo('"')
  let l:savereg_yank = getreginfo('0')
  exec 'norm! "0c' . a:prefix . "\<C-r>0" . a:suffix
  call setreg('"', l:savereg_unnamed)
  call setreg('0', l:savereg_yank)
endfunction

" Create undo checkpoints when writing prose:
inoremap <buffer> . .<c-g>u
inoremap <buffer> , ,<c-g>u
inoremap <buffer> ; ;<c-g>u
inoremap <buffer> : :<c-g>u
inoremap <buffer> ! !<c-g>u
inoremap <buffer> ? ?<c-g>u

" From https://unix.stackexchange.com/a/406415
let s:pshuf_awk_script = '
  \ BEGIN {
  \   srand(seed);
  \   n = rand();
  \ }
  \
  \ {
  \   print n, NR, $0;
  \ }
  \
  \ NF == 0 {
  \   n = rand();
  \ }
  \
  \ END {
  \   if (NF != 0) {
  \     print n, NR + 1, "";
  \   }
  \ }
  \'

let s:pshuf_awk_script = shellescape(s:pshuf_awk_script, 1)

command! -range -buffer Pshuf
  \ :call RunCmdIfExecutablesExist(
  \   '<line1>,<line2>!awk -v seed=' . rand(srand()) . ' ' . s:pshuf_awk_script .
  \     " | sort -nk1 -k2 | cut -d' ' -f3- | sed '$d'",
  \   ['awk', 'sort', 'cut', 'sed'],
  \   1
  \ )
