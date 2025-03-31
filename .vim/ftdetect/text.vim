" If no filetype detected, set it to text
" (this does not catch buffers that lack a filename however):
autocmd BufNewFile,BufRead * if &filetype ==# '' |
  \ call s:make_text_default_filetype_via_feedkeys() | endif

" This sets the filetype to text for buffers that don't have a filename
" associated with them (like what happens with new/enew/vnew/tabe).
autocmd BufEnter * if &filetype ==# '' && expand('%') ==# '' |
  \ call s:make_text_default_filetype_via_feedkeys() | endif

" This should be called with feedkeys because early on in a buffer's life,
" it may have no filetype set, but by the time the buffer is ready for
" keypresses, the &filetype and &modifiable variables should be set.
" (for example, calling this w/o feedkeys(...) makes netrw misbehave when
" the text ftplugin has the `b:undo_ftplugin` variable contain the string
" '|mapclear <buffer> | mapclear! <buffer>' (which will clear the netrw
" mappings too!)
" This also allows other autocmds that set the filetype in the traditonal
" `autocmd BufRead ~/.xinitrc setfiletype sh` way to set their filetype first
" (and not have their filetype overwritten since we check `&filetype ==# ''`).
function! s:make_text_default_filetype()
  if &modifiable && &filetype ==# ''
    setfiletype text
  endif
endfunction

function! s:make_text_default_filetype_via_feedkeys()
  " The redraw prevents 'Press ENTER or type command to continue' from
  " appearing (unless the window is very small, say under 30 columns,
  " but even `vim --clean` will do that when a filename argument is provided).
  " The double escape is because when there is just a single escape,
  " a terminal running bash within vim will interpret the next keypress
  " (by the user, not feedkeys) as being part of an escape sequence
  " (the second escape completes the escape sequence already).
  " "\<C-w>:" is like ":" but works in vim terminal buffers as well.
  call feedkeys(
    \   "\<esc>\<esc>" .
    \   "\<C-w>:\<C-u>call " . expand('<SID>') ."make_text_default_filetype()\<cr>" .
    \   "\<C-w>:\<C-u>redraw\<cr>" .
    \   "\<C-w>:\<C-u>\<bs>", 'n'
    \ )
endfunction
