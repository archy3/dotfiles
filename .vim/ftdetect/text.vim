" If no filetype detected, set it to text
" (this does not catch buffers that lack a filename however):
autocmd BufNewFile,BufRead * if &filetype ==# '' |
  \ call s:if_filetype_is_blank_after_delay_then_set_it_to_text() | endif

" This sets the filetype to text for buffers that don't have a filename
" associated with them (like what happens with new/enew/vnew/tabe).
autocmd BufEnter * if &filetype ==# '' && expand('%') ==# '' |
  \ call s:if_filetype_is_blank_after_delay_then_set_it_to_text() | endif

" This should be called with some delay after entering the buffer,
" because early on in a buffer's life, it may have no filetype set,
" but after further processing of autocmds and ftplugins,
" the filetype may then no longer be unset.
" (For example, calling this w/o the delay makes netrw misbehave when
" the text ftplugin has the `b:undo_ftplugin` variable contain the string
" '|mapclear <buffer> | mapclear! <buffer>' (which will clear the netrw
" mappings too!)
" This also allows other autocmds that set the filetype in the traditonal
" `autocmd BufRead ~/.xinitrc setfiletype sh` way to set their filetype first
" (and not have their filetype overwritten since we check `&filetype ==# ''`).
function! s:set_filetype_to_text_if_not_set(timer)
  if &modifiable && &filetype ==# ''
    setfiletype text

    " In terminal vim, the title still used the previous
    " blank file type until the user presses a key.
    " This is an attempt to get vim to update the title.
    " (This may be a terminal issues with nothing to do with vim)
    let &title = &title
    redraw
  endif
endfunction

function! s:if_filetype_is_blank_after_delay_then_set_it_to_text()
  call timer_start(50, expand('<SID>') . 'set_filetype_to_text_if_not_set')
endfunction
