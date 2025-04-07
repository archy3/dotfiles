" List of normal-mode commands that go into insert-mode and thus are useless
" for help: acdiorux

setlocal colorcolumn=80

nnoremap <buffer> u <cmd>call <SID>SetLessBehavior(1)<cr><C-]>
nnoremap <buffer> r <cmd>call <SID>SetLessBehavior(1)<cr><C-t>

let s:less = 1

function! s:GetLessBehavior() abort
  return s:less
endfunction

function! s:SetLessBehavior(bool) abort
  let s:less = a:bool
endfunction

function! s:ToggleLessBehavior() abort
  let s:less = !s:less
  echo 'less mode turned ' . (s:less ? 'on' : 'off')
endfunction

nnoremap <buffer> i <cmd>call <SID>ToggleLessBehavior()<cr>
nnoremap <buffer> <expr> j <SID>GetLessBehavior() ? "\<C-e>"    : 'j'
nnoremap <buffer> <expr> k <SID>GetLessBehavior() ? "\<C-y>"    : 'k'
nnoremap <buffer> <expr> h <SID>GetLessBehavior() ? 'zh'        : 'h'
nnoremap <buffer> <expr> l <SID>GetLessBehavior() ? 'zl'        : 'l'
nnoremap <buffer> <expr> f <SID>GetLessBehavior() ? "\<C-f>Lzb" : 'f'
nnoremap <buffer> <expr> b <SID>GetLessBehavior() ? "\<C-b>"    : 'b'
nnoremap <buffer> <expr> { <SID>GetLessBehavior() ? 'H{'        : '{'
nnoremap <buffer> <expr> } <SID>GetLessBehavior() ? 'L}'        : '}'

" Left-handed scroll bindings:
nnoremap <buffer> <expr> e <SID>GetLessBehavior() ? 'H{'        : 'e'
nnoremap <buffer> <nowait> d L}
nnoremap <buffer> <expr> w <SID>GetLessBehavior() ? '<C-y>'     : 'w'
nnoremap <buffer> s <C-e>

" Make help open in v-split if only one window, else in bottom-right.
"{{{
augroup make_help_open_in_a_nice_location
  autocmd!
  autocmd BufWinEnter *.txt if &buftype ==# 'help' | call s:HelpProperLocation() | endif
augroup END

" Move to bottom of rightmost column (if not already there):
function! s:Move_to_bottom_of_rightmost_column() abort
  let l:curwin = winnr()
  wincmd b

  " `if winnr() != l:curwin` prevents this from running multiple times
  " (which would happen due to the buffer reentering after it was hidden).
  if winnr() != l:curwin
    exec l:curwin . 'wincmd w'
    let l:curbuf = bufnr('%')
    hide
    wincmd b
    belowright split
    exec 'buf' l:curbuf
  endif
endfunction

function! s:HelpProperLocation() abort
  " This count includes the new help window:
  if winnr('$') <= 2
    " Move to far right:
    wincmd L

    " If the window is too narrow:
    if winwidth(0) < 80
      call s:Move_to_bottom_of_rightmost_column()

      " If the window is still too narrow:
      if winwidth(0) < 80
        wincmd L
        wincmd J
      endif
    endif
  else
    call s:Move_to_bottom_of_rightmost_column()
  endif

  vertical wincmd =
  if mode() ==# 'n'
    call feedkeys("\<esc>ze", 'n')
  endif
endfunc
"}}}

augroup reposition_help_window_view_on_terminal_resize
  autocmd!
  autocmd VimResized *.txt if &buftype ==# 'help' | call feedkeys("\<esc>ze", 'n') | endif
augroup END

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal colorcolumn<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
