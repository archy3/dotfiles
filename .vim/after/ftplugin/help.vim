" List of normal-mode commands that go into insert-mode and thus are useless
" for help: acdiorux
nnoremap <buffer> u <C-]>
nnoremap <buffer> r <C-t>

" Make help open in v-split if only one window, else in bottom-right.
"{{{
augroup make_help_open_in_a_nice_location
  autocmd!
  autocmd BufWinEnter *.txt if &buftype ==# 'help' | call s:HelpProperLocation() | endif
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

function! s:HelpProperLocation()
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

  wincmd =
  call feedkeys('ze', 'n')
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

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|mapclear <buffer> | mapclear! <buffer>'
endif
