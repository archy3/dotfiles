" Indent two literal spaces and show literal tabs as 8 spaces:
call SetTabBehavior(2,8)

" Set folding around {{{,}}} for .vim files:
"set foldlevelstart=99
setlocal foldmethod=marker
normal! zR

if has('unix') || has('win32')
  let s:vimrc_dir = has('unix') ? '~/.vim' : '~/vimfiles'
  exec 'setlocal path+=' . s:vimrc_dir . '/init/'
  exec 'setlocal path+=' . s:vimrc_dir . '/after/ftplugin'
  exec 'setlocal path+=' . s:vimrc_dir . '/plugin'
  exec 'setlocal path+=' . s:vimrc_dir
endif

" Remaps:
" Redefining this function can lead to E127 if
" we `gf` from a vim file to another vim file.
if !exists('*' . expand('<SID>') . 'gf')
  function! s:gf() abort
    try
      normal! gf
    catch /^Vim\%((\a\+)\)\=:E44[67]:/
      try
        normal! $gf
      catch /^Vim\%((\a\+)\)\=:E44[67]:/
        echo v:exception
      endtry
    endtry
  endfunction
endif
nnoremap <buffer> gf <cmd>call <SID>gf()<cr>

if has('unix') || has('win32')
  nnoremap <buffer> <Leader>r
    \ <cmd>
    \   exec 'source ' . (has('unix') ? '~/.vim' : '~/vimfiles') . '/vimrc' <bar>
    \   echo 'vimrc sourced!'
    \ <cr>
endif

" Execute contents of paste register:
cnoremap <buffer> <C-f><C-r> @"<cr>
cnoremap <buffer> <C-f>r @"<cr>

" Reverts:
" Stop 'o' from adding '" ' to the line bellow a comment:
setlocal formatoptions-=o


if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setlocal foldmethod<'
  let b:undo_ftplugin .= '|setlocal formatoptions<'
  let b:undo_ftplugin .= '|setlocal path<'
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
