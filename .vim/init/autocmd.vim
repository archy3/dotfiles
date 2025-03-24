" Resize windows (panes) to equal when GUI window or terminal is resized:
autocmd VimResized * wincmd =

" Make buffers remember their view settings:
"{{{
    " Save current view settings on a per-window, per-buffer basis.
    function! AutoSaveWinView()
        if !exists("w:SavedBufView")
            let w:SavedBufView = {}
        endif
        let w:SavedBufView[bufnr("%")] = winsaveview()
    endfunction

    " Restore current view settings.
    function! AutoRestoreWinView()
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
        autocmd BufLeave * call AutoSaveWinView()
        autocmd BufEnter * call AutoRestoreWinView()
    endif
"}}}

" Highlight trailing whitespace: (Such as this:)	 
"{{{
    " The vimenter command prevent errors that occur
    " from things loading too late or too early.
    function! HighlightExtraWhitespace()
       highlight ExtraWhitespace ctermbg=red guibg=red
       match ExtraWhitespace /\s\+$/

       " Apply to entered buffers:
       autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

       " Apply to new windows:
       autocmd WinNew * match ExtraWhitespace /\s\+$/

       " Disable on Insert Mode:
       autocmd InsertEnter * match ExtraWhitespace //
       autocmd InsertLeave * match ExtraWhitespace /\s\+$/

       " Disable on buffers that aren't being viewed:
       autocmd BufWinLeave * call clearmatches()
    endfunction
    autocmd colorscheme * call HighlightExtraWhitespace()
    " This was originally 'autocmd vimenter * call HighlightExtraWhitespace()'
    " but that only worked when called after
    " 'autocmd vimenter * colorscheme gruvbox'.
    " Now that 'autocmd vimenter * nested colorscheme gruvbox' is being used,
    " 'autocmd colorscheme * call HighlightExtraWhitespace()' works both when
    " it is run before and when it is run after
    " 'autocmd vimenter * nested colorscheme gruvbox'.

   " set list listchars=tab:\ \ ,trail:@
   " autocmd InsertEnter * set nolist
   " autocmd InsertLeave * set list
"}}}

" Highlight multiple consecutive whitespace (such as  stuff  like  this  )
" except for whitespace at the beginning of a line:
"{{{
    function! HighlightMultipleWhitespace()
       highlight MultipleWhitespace ctermbg=red guibg=red
       match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

       " Apply to entered buffers:
       autocmd BufWinEnter * match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

       " Apply to new windows:
       autocmd WinNew * match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

       " Disable on Insert Mode:
       autocmd InsertEnter * match MultipleWhitespace //
       autocmd InsertLeave * match MultipleWhitespace /[^[:blank:]]\zs\s\s\+/

       " Disable on buffers that aren't being viewed:
       autocmd BufWinLeave * call clearmatches()
    endfunction
    "autocmd colorscheme * call HighlightMultipleWhitespace()
"}}}



" After &updatetime milliseconds of idle time in insert mode,
" create an undo checkpoint:
" From https://ww.reddit.com/r/vim/comments/13gk0nl/is_there_a_way_to_make_undo_sensible/jk0bsba/
augroup break_undo_when_im_thinking
  autocmd!
  autocmd CursorHoldI * call feedkeys("\<c-g>u", 'n')
augroup END

" Work around bug in xterm where setting `xterm.buffered: true` in
" ~/.Xresources causes the terminal background color to become the
" background color of the vim colorscheme when vim exits:
if ($TERM ==# 'xterm-256color') && !has("gui_running")
  autocmd! VimLeave * syntax off | highlight clear | redraw
endif
