" Resize windows (panes) to equal when GUI window or terminal is resized:
augroup resize_windows_on_terminal_resize
  autocmd!
  autocmd VimResized * wincmd =
augroup END

" Make buffers remember their view settings:
"{{{
    " Save current view settings on a per-window, per-buffer basis.
    function! s:AutoSaveWinView() abort
        if !exists('w:SavedBufView')
            let w:SavedBufView = {}
        endif
        let w:SavedBufView[bufnr('%')] = winsaveview()
    endfunction

    " Restore current view settings.
    function! s:AutoRestoreWinView() abort
        let l:buf = bufnr('%')
        if exists('w:SavedBufView') && has_key(w:SavedBufView, l:buf)
            let l:v = winsaveview()
            let l:atStartOfFile = (l:v.lnum ==# 1 && l:v.col ==# 0)
            if l:atStartOfFile && !&diff
                call winrestview(w:SavedBufView[l:buf])
            endif
            unlet w:SavedBufView[l:buf]
        endif
    endfunction

    " When switching buffers, preserve window view.
    if v:version >= 700
      augroup preserve_buffer_views
        autocmd!
        autocmd BufLeave * call s:AutoSaveWinView()
        autocmd BufEnter * call s:AutoRestoreWinView()
      augroup END
    endif
"}}}

" Highlight trailing whitespace: (Such as this:)	 
"{{{
  function! s:HighlightExtraWhitespace() abort
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
  endfunction

  function! s:Activate_HighlightExtraWhitespace() abort
    call s:HighlightExtraWhitespace()
    augroup highlight_trailing_whitespace
      autocmd!

      " Apply to entered buffers and new windows:
      autocmd BufWinEnter,WinNew * match ExtraWhitespace /\s\+$/

      " Disable on insert mode:
      autocmd InsertEnter * match ExtraWhitespace //
      autocmd InsertLeave * match ExtraWhitespace /\s\+$/

      " Disable on buffers that aren't being viewed:
      autocmd BufWinLeave * call clearmatches()

      " Apply after applying colorscheme so colorscheme does not overwrite:
      autocmd colorscheme * call s:HighlightExtraWhitespace()
    augroup END
  endfunction

  call s:Activate_HighlightExtraWhitespace()
"}}}

" Highlight multiple consecutive whitespace (such as  stuff  like  this  )
" except for whitespace at the beginning of a line:
"{{{
  function! s:HighlightMultipleWhitespace() abort
    highlight MultipleWhitespace ctermbg=red guibg=red
    match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/
  endfunction

  function! s:Activate_HighlightMultipleWhitespace() abort
    call s:HighlightMultipleWhitespace()
    augroup highlight_trailing_whitespace
      autocmd!

      " Apply to entered buffers and new windows:
      autocmd BufWinEnter,WinNew * match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

      " Disable on Insert Mode:
      autocmd InsertEnter * match MultipleWhitespace //
      autocmd InsertLeave * match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

      " Disable on buffers that aren't being viewed:
      autocmd BufWinLeave * call clearmatches()

      " Apply after applying colorscheme so colorscheme does not overwrite:
      autocmd colorscheme * call s:HighlightMultipleWhitespace()
    augroup END
  endfunction

  "call s:Activate_HighlightMultipleWhitespace()
"}}}

" After &updatetime milliseconds of idle time in insert mode,
" create an undo checkpoint:
" From https://ww.reddit.com/r/vim/comments/13gk0nl/is_there_a_way_to_make_undo_sensible/jk0bsba/
augroup create_undo_checkpoint_when_idling_in_insert_mode
  autocmd!
  autocmd CursorHoldI * call feedkeys("\<c-g>u", 'n')
augroup END

augroup terminal_settings
  autocmd!
  autocmd TerminalOpen * setlocal colorcolumn=
  autocmd TerminalOpen * setlocal nonumber
  autocmd TerminalOpen * setlocal norelativenumber
augroup END


" If no filetype detected, set it to text:
augroup set_default_filetype
  autocmd BufEnter *
    \ if &filetype ==# '' |
    \   call timer_start(50, expand('<SID>') . 'set_filetype_to_text_if_not_set') |
    \ endif
augroup END

" This should be called with some delay after entering the buffer,
" because early on in a buffer's life, it may have no filetype set,
" but after further processing of autocmds and ftplugins,
" the filetype may then no longer be unset.
" (For example, calling this w/o the delay makes netrw misbehave when
" the text ftplugin has the `b:undo_ftplugin` variable contain the string
" '|mapclear <buffer> | mapclear! <buffer>' (which will clear the netrw
" mappings too!)
function! s:set_filetype_to_text_if_not_set(timer) abort
  if &modifiable && &filetype ==# '' && &buflisted && &buftype ==# '' && &bufhidden ==# ''
    setfiletype text

    " In terminal vim, the title still used the previous
    " blank filetype until the user presses a key.
    " This is an attempt to get vim to update the title.
    " (This may be a terminal issues with nothing to do with vim)
    let &title = &title
    redraw
  endif
endfunction


" Work around bug in xterm where setting `xterm.buffered: true` in
" ~/.Xresources causes the terminal background color to become the
" background color of the vim colorscheme when vim exits:
if ($TERM ==# 'xterm-256color') && !has('gui_running')
  augroup fix_xterm_buffered_bug
    autocmd!
    autocmd VimLeave * syntax off | highlight clear | redraw
  augroup END
endif


" For some reason, `b:undo_ftplugin` is not activated when entering a
" new file (e.g. `:edit /etc/fstab`) when `bufname('%')` is empty
" while `&modified` is false (such as when `vim` is opened without
" arguments and no edits are made to the initial empty and unnamed
" buffer), which leaves window-local settings like `spell` still
" active when the new filetype is entered (it seems buffer-local
" settings are not carried over into the new file regardless if
" `b:undo_ftplugin` is executed or not, despite the buffer of the new
" file having the same `bufnr('%')` as the empty buffer it was entered
" from). Thus we make an autocmd to set the filetype back to what it
" previousely was before the current filetype and then we reset it
" back to the current filetype to activate the `b:undo_ftplugin' of
" the previouse ftplugin.
" NOTE: As of vim 9.1.1323, this bug appears to be fixed (but not in nvim).
let s:ftplugin_may_need_to_be_undone_in_buf = {}

augroup fix_undo_ftplugin_not_activating_bug
  autocmd!
  autocmd FileType *
    \ if @% ==# '' |
    \   let s:ftplugin_may_need_to_be_undone_in_buf[bufnr('%')] = &filetype |
    \ endif
  autocmd BufNewFile,BufRead * call s:Activate_undo_ftplugin_if_needed()
augroup END

function! s:Activate_undo_ftplugin_if_needed() abort
  if has_key(s:ftplugin_may_need_to_be_undone_in_buf, bufnr('%'))
    let l:filetype_save = &filetype
    let &filetype = s:ftplugin_may_need_to_be_undone_in_buf[bufnr('%')]
    let &filetype = l:filetype_save
    call remove(s:ftplugin_may_need_to_be_undone_in_buf, bufnr('%'))
  endif
endfunction
