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

" Make help open in v-split if only one window, else in bottom-right.
"{{{
augroup vimrc_help
  autocmd!
  autocmd BufWinEnter *.txt if &buftype ==# 'help' | call HelpProperLocation() | endif
  "{{{
  " BufEnter was originally used but this sometimes ran more than once.
  " BufWinEnter created weird behavior sometimes when switching windows
  " (the non-help window would sometimes scroll up or down by a single line
  " when entering it from the help window).
  " BufAdd seems to work so far.
  " Edit: BufAdd has some issues.
  " Edit: Currently trying BufWinEnter again. Now that HelpProperLocation has
  " changed a bit, I'm wondering if this will still have issues.
  " Edit: Stopping BufWinEnter due to bug noted in the 'BUGS' section.
  " Edit: Both BufEnter and BufAdd have this bug too so I'm switching back to
  " BufWinEnter

  " What doesn't work at all:
  " BufNew
  " BufNewFile
  " BufReadPost
  " filetype

  " BUGS:
  " With BufAdd:
  " Sometimes this has now affect for some reason.
  " It seems like a timming issue.
  " Actually it seems this happens when going to a help page for the first time.
  " Reason found: The body of the if-statement isn't executed when a help page
  " is viewed for the first time.

  " If a help window is already open, and help is called again, the help window
  " location can change.

  " With BufWinEnter:
  " If a help window is already open, and help is called again, the help window
  " location can change.

  " With BufEnter:
  " If a help window is already open, and help is called again, the help window
  " location can change.

  " OLD BUGS:
  " Open help in a new tab.
  " Then open another help in that tab.
  " Then that help opens in the previouse tab.
  " Using '<= 2' instead of '==# 2' seems to have fixed this.

  " Simple version that always opens in the far right:
  "autocmd BufAdd *.txt if &buftype ==# 'help' | wincmd L | endif
  "}}}
augroup END

function! HelpProperLocation()
  " This count includes the new help window:
  if winnr('$') <= 2
    " Move to far right:
    wincmd L
  else
    " Move to bottom of rightmost column (if not already there):
    let l:curwin = winnr()
    wincmd b
    if winnr() != l:curwin
      exe l:curwin . 'wincmd w'
      let l:curbuf = bufnr('%')
      hide
      wincmd b
      belowright split
      exe 'buf' l:curbuf
    endif
  endif
  "{{{
  " 'if winnr() != l:curwin' prevents this from running multiple times
  " (whihc would happen due to the buffer reentering after it was hidden).

  " BUGS:
  " If there is a single window, and a help window is then opened, and then
  " the windows are exchanged, and then another help command is give, then
  " the help window will be moved back to the right.
  " The intended behavior is that this function has no affect if a help
  " window is already opened in the tab.
  " If the function could check if a help window was already open before
  " the help command was given, then the 'if winnr() != l:curwin' could be
  " removed and the highest level if-statement would be 'if not already opened
  " when help command was given, then move far right if less than 2 windows,
  " else move bottom right'.
  "}}}
endfunc
"}}}

" Work around bug in xterm where setting `xterm.buffered: true` in
" ~/.Xresources causes the terminal background color to become the
" background color of the vim colorscheme when vim exits:
if ($TERM ==# 'xterm-256color') && !has("gui_running")
  autocmd! VimLeave * syntax off | highlight clear | redraw
endif
