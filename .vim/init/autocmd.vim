" Resize windows (panes) to equal when GUI window or terminal is resized:
autocmd VimResized * wincmd =

" Make buffers remember their view settings:
"{{{
    " Save current view settings on a per-window, per-buffer basis.
    function! s:AutoSaveWinView()
        if !exists("w:SavedBufView")
            let w:SavedBufView = {}
        endif
        let w:SavedBufView[bufnr("%")] = winsaveview()
    endfunction

    " Restore current view settings.
    function! s:AutoRestoreWinView()
        let buf = bufnr("%")
        if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
            let v = winsaveview()
            let atStartOfFile = v.lnum ==# 1 && v.col ==# 0
            if atStartOfFile && !&diff
                call winrestview(w:SavedBufView[buf])
            endif
            unlet w:SavedBufView[buf]
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
  function! s:HighlightExtraWhitespace()
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
  endfunction

  function! s:Activate_HighlightExtraWhitespace()
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
  function! s:HighlightMultipleWhitespace()
    highlight MultipleWhitespace ctermbg=red guibg=red
    match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/
  endfunction

  function! s:Activate_HighlightMultipleWhitespace()
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

" Work around bug in xterm where setting `xterm.buffered: true` in
" ~/.Xresources causes the terminal background color to become the
" background color of the vim colorscheme when vim exits:
if ($TERM ==# 'xterm-256color') && !has("gui_running")
  autocmd! VimLeave * syntax off | highlight clear | redraw
endif
