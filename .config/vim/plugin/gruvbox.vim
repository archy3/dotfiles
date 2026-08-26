augroup gruvbox_autocmd
  autocmd!
  autocmd ColorScheme gruvbox call s:Gruvbox_autocmd_settings()
augroup END


function! s:Gruvbox_autocmd_settings() abort
  call s:Gruvbox_terminal_theme()

  " Make gruvbox colors, italics, and spell underlining work in
  " xterm (or terminals that report as xterm) and tmux:
  if $TERM =~# '^\(xterm\|tmux\)-.*color.*$' && !has('gui_running')
    let g:gruvbox_italic=1
    highlight SpellBad cterm=underline
    highlight SpellRare cterm=underline
    highlight SpellCap cterm=underline
    highlight SpellLocal cterm=underline
      " See also this: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
    set termguicolors
  endif

  " Terminals typically cannot change the cursor appearance/behavior
  if has('gui_running')
    augroup gruvbox_hlsearch_cursor_toggle
      autocmd!
      autocmd ColorSchemePre * call s:Undo_gruvbox_hlsearch_cursor_toggle()
      autocmd OptionSet hlsearch call s:Toggle_cursor_with_hlsearch_state()
    augroup END

    call s:Toggle_cursor_with_hlsearch_state()
  endif
  "autocmd vimenter * hi Normal guifg=#FFD7AF
endfunction


" For gvim, when hlsearch is on, set distinctive cursor color
" (#ad7cbf is a bit more subtle) and disable (normal mode) blinking.
function! s:Toggle_cursor_with_hlsearch_state() abort
  exec &hlsearch ?
    \ 'hi Cursor guifg=#00ffff guibg=#000000 | set guicursor+=n:blinkon0' :
    \ 'hi Cursor guifg=NONE    guibg=NONE    | set guicursor-=n:blinkon0'
endfunction

function! s:Undo_gruvbox_hlsearch_cursor_toggle() abort
  autocmd! gruvbox_hlsearch_cursor_toggle

  " Reset &guicursor state:
  let l:hsearch_state = &hlsearch
  set nohlsearch
  call s:Toggle_cursor_with_hlsearch_state()
  let &hlsearch = l:hsearch_state
endfunction


function! s:Gruvbox_terminal_theme() abort
  highlight Terminal ctermbg=0 ctermfg=7 guibg='#000000' guifg='#aaaaaa'

  " We use bright colors for both 0-7 and 8-15 since vim's terminal
  " does not make bold bright (and thus text is hard to read w/o doing this):
  let g:terminal_ansi_colors = [
    \ '#555555',
    \ '#ff5555',
    \ '#55ff55',
    \ '#ffff55',
    \ '#5555ff',
    \ '#ff55ff',
    \ '#55ffff',
    \ '#ffffff',
    \ '#555555',
    \ '#ff5555',
    \ '#55ff55',
    \ '#ffff55',
    \ '#5555ff',
    \ '#ff55ff',
    \ '#55ffff',
    \ '#ffffff'
    \]
endfunction


" If gruvbox is already the colorscheme, then `colorscheme gruvbox`
" was invoked before the above autocmds were defined, which means
" `s:Gruvbox_autocmd_settings()` has not been called yet. Thus we
" call `s:Gruvbox_autocmd_settings()` if the colorscheme is currently
" 'gruvbox' so that the settings apply.
if exists('g:colors_name') && g:colors_name ==# 'gruvbox'
  call s:Gruvbox_autocmd_settings()
endif
