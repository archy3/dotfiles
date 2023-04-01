" Use right click to copy/paste to/from the system clipboard (like Windows cmd):
nnoremap <RightMouse> "+<MiddleMouse>
inoremap <RightMouse> <C-o>"+<MiddleMouse>
vnoremap <RightMouse> "+y

" Use mouse back button to open a new line below the mouse cursor:
nnoremap <X1Mouse> <LeftMouse>o<esc>
" Use mouse back button to open a new line below the mouse cursor:
" (The '0d$' make sure the line is blank [it sometimes isn't depending on the ftplugin])
nnoremap <X1Mouse> <LeftMouse>o<esc>0d$

" Mouse undo:
nnoremap <X2Mouse> u

" Mouse visual delete:
vnoremap <X2Mouse> d

" remaps
inoremap jk <esc>
inoremap kj <esc>

" Like remapping j/k to gj/gk but making relative line numbers work as expected:
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

nnoremap Y y$

" Delete to matching indent:
nnoremap <silent> dsi ^"py0^d/^<C-r>p[^ \t]/+0<cr>
nnoremap <silent> dsu ^"py00d?^<C-r>p[^ \t]?+0<cr>

" Delete till end of function braces:
nnoremap <silent> dsb 0d][

" List buffers:
nnoremap gb :ls<cr>:b<space><space><space><space><space><space><space><space>

" Allow for easy putting of yanked and copied text:
" Note: <C-r><C-o> is like <C-r> but prevents autoindent from altering the text.
inoremap <C-f> <nop>
inoremap <C-f><space> <C-r><C-o>0
inoremap <C-f><C-v> <C-r><C-o>+
inoremap <C-f>v <C-r><C-o>+

cnoremap <C-f> <nop>
cnoremap <C-f><space> <C-r>0
cnoremap <C-f><PageDown> <C-r>0
cnoremap <C-f><C-v> <C-r>+
cnoremap <C-f>v <C-r>+
cnoremap <C-f><C-f> <C-f>

" Make <C-n> feel natural on my keyboard:
inoremap <home> <C-n>

" Use modern shortcuts for system clipboard and saving:
vnoremap <C-c> "+y
inoremap <C-v> <C-r><C-o>+
nnoremap <C-s> :update<cr>
inoremap <C-s> <C-o>:update<cr>
" (':update' is like ':w' but doesn't write when the file hasn't been modified)

" Window remaps
nnoremap <silent> <C-h> :wincmd h<cr>
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-k> :wincmd k<cr>
nnoremap <silent> <C-l> :wincmd l<cr>

" Resize windows more easily:
nnoremap <silent> <left> :vert resize -1<cr>
nnoremap <silent> <right> :vert resize +1<cr>
nnoremap <silent> <down> :resize -1<cr>
nnoremap <silent> <up> :resize +1<cr>

let mapleader = " "

" GUI save as:
nnoremap <Leader><C-s> :browse<space>confirm<space>saveas<cr>

" Print:
nnoremap <Leader><C-p> :%w !lp -o print-quality=3 -o sides=one-sided -o outputorder=reverse -o ColorModel=Gray<cr>

" GUI open folder of current file:
nnoremap <silent> <Leader><C-e> :silent !pcmanfm --new-win -- %:p:h:S<cr>:redraw!<cr>

" Delete current file (GUI prompt):
nnoremap <silent> <Leader><Leader>D :if confirm("Delete ". expand('%:p') . "?", "No\nYes", 1) == 2 <bar> call delete(expand('%:p')) <bar> endif<cr>

" Make file executable:
nnoremap <Leader><C-x> :!chmod u+x -- %:p:S<cr>

" Toggles:
nnoremap <silent> <Leader>s :setlocal spell! spell?<cr>
nnoremap <silent> <Leader><Leader>l :setlocal list! list?<cr>
nnoremap <silent> <Leader><Leader>h :setlocal hlsearch! hlsearch?<cr>
nnoremap <silent> <Leader><Leader>w :set wrap! wrap?<cr>
nnoremap <silent> <Leader><Leader>; :setlocal linebreak! linebreak?<cr>
nnoremap <silent> <Leader><Leader>y :call ToggleSystemClipboard()<cr>

" Toggle using internal registers or system clipboard:
function! ToggleSystemClipboard()
  if &clipboard =~# 'unnamedplus'
    set clipboard-=unnamedplus clipboard?
  else
    set clipboard^=unnamedplus clipboard?
  endif
endfunction

" Counterparts to C/D/Y:
nnoremap <Leader>C c^
nnoremap <Leader>D d^
nnoremap <Leader>Y y^

" Undo/redo to last save:
nnoremap <Leader>u :earlier 1f<cr>
nnoremap <Leader>U :later 1f<cr>

" Find word:
nnoremap <Leader>/ /\<\><left><left>

" Find and replace:
nnoremap <Leader>h :%s//g<left><left>

" Replace every instance of current word:
nnoremap <Leader>H "pyiw:%s/\<<C-r>p\>//gI<left><left><left>

" Autocorrect current word:
nnoremap <Leader>z 1z=

" Like 'yy' but does not copy the final newline (or the leading whitespace):
nnoremap <silent> <Leader>yy :<C-u>exec 'norm! ^' . v:count1 . 'y$'<cr>

" copy entire file into clipboard
nnoremap <silent> <Leader>y<Leader> :call CopyBufferToClipboard()<cr>
"function! CopyBufferToClipboard()
"  let l:current_winview=winsaveview()
"  normal! vgg0oG$"+y
"  call winrestview(l:current_winview)
"endfunction
" (Just doing something like 'nnoremap <Leader>y :%y+<cr>' is much simpler,
"  but that would also copy the EOF newline which usually isn't wanted.)
function! CopyBufferToClipboard()
  %y+
  " Remove EOF newline which usually isn't wanted:
  let l:regContents = getreg('+')
  if len(l:regContents) > 1 && l:regContents[-1:-1] == "\n"
    call setreg('+', l:regContents[:-2])
  endif
endfunction

" paste from clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Append yanked test to end of line or after cursor, separated by a space:
nnoremap <Leader>A A<space><C-r><C-o>0<esc>
nnoremap <Leader>a a<space><C-r><C-o>0<esc>

" change with yanked text
" From https://www.reddit.com/r/vim/comments/a9nyqc/how_to_paste_without_losing_the_text_in_the/ecmt0li/?utm_source=reddit&utm_medium=web2x&context=3
function! PasteOver(type, ...)
  let saveSel = &selection
  let &selection = "inclusive"
  let saveReg = @@
  let reg = v:register
  let regContents = getreg(reg)

  " Remove trailing newline from yanks like "yy"
  if len(regContents) > 1 && regContents[-1:-1] == "\n" && regContents[-2:-2] != "\n"
    call setreg(reg, regContents[:-2])
  endif

  if a:0 " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>"
  elseif a:type == 'line'
    silent exe "normal! '[V']"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]"
  else
    silent exe "normal! `[v`]"
  endif

  "execute "normal! \"_d\"" . reg . "P"
  execute "normal! \"_c\<C-r>\<C-o>" . reg

  let &selection = saveSel
  let @@ = saveReg

  call setreg(reg, regContents)
endfunction
nnoremap <silent> <Leader>c :set opfunc=PasteOver<cr>g@
nnoremap <silent> <Leader>cc 0:set opfunc=PasteOver<cr>g@$

" Buffer remaps:
nnoremap <Leader>b :bn <cr>
nnoremap <Leader>B :bp <cr>
nnoremap <Leader>q :call DeleteBuffer(0)<cr>
nnoremap <Leader>Q :call DeleteBuffer(1)<cr>
function! DeleteBuffer(force)
  let l:del_cmd = (a:force ? "bdelete!" : "bdelete")

  " If there is an alternative buffer (AKA buffer 0), go to it and delete this
  " buffer from it. Otherwise, go to the previous buffer and do the same.
  if buflisted(0)
    let l:command = ":buffer # | " . l:del_cmd . " #"
  else
    let l:command = ":bprevious | " . l:del_cmd . " #"
  endif

  " If the buffer isn't listed (e.g. help), just simply delete it:
  if ! buflisted(expand("%"))
      exec l:del_cmd
  " Only delete the current listed buffer if it is not the only listed buffer:
  elseif len(getbufinfo({'buflisted':1})) >= 2
    try
      exec l:command
    catch
      " Go back to buffer that failed to delete:
      exec "buffer #"
      " Run this so the error message will display (there's probably a better
      " way to do this than having to run the bdelete command again):
      exec l:del_cmd
    endtry
  else
    echo "DeleteBuffer(): This is the only buffer."
  endif
endfunction

" Jump to next window:
nnoremap <silent> <Leader>w :wincmd w<cr>
nnoremap <silent> <Leader>W :wincmd W<cr>

" Close windows and tabs:
nnoremap <silent> <Leader>x :close<cr>
nnoremap <silent> <Leader>X :tabclose<cr>

" Move window to new tab:
nnoremap <silent> <Leader>o :wincmd T<cr>

" Create new window in the most likely desired way:
nnoremap <silent> <Leader>v :execute (winwidth(0) >= (2 * &colorcolumn) ? 'vsp' : 'sp')<cr>

" Quickly set the filetype:
nnoremap <leader>ft :set filetype=
" Would like to makes this an autocmd:
" autocmd BufReadPost,BufNewFile * if empty(&filetype) | execute 'nnoremap <buffer> <leader>ft :set filetype=' | endif
" but that doesn't work for things like 'new' 'vnew' 'tabe'.

" Highlighting:
"nnoremap / :setlocal hlsearch<cr>/
"nnoremap ? :setlocal hlsearch<cr>?
"nnoremap <silent> <esc> <esc>:setlocal nohlsearch<cr>
"nnoremap <silent> <esc> <esc>:nohlsearch<cr>

function! CenterMatch()
  nnoremap <buffer> n nzz
  nnoremap <buffer> N Nzz
  nnoremap <buffer> * *zz
  nnoremap <buffer> # #zz
  nnoremap <buffer> g* g*zz
  nnoremap <buffer> g# g#zz
endfunction


" Comments:
"{{{
  " from: https://vim.fandom.com/wiki/Commenting_with_opfunc

  " Comment or uncomment lines from mark a to mark b.
  function! CommentMark(docomment, a, b)
    if !exists('b:comment')
      "let b:comment = CommentStr() . ' '
      " (Would nice to use the above but skip blank lines)
      let b:comment = CommentStr()
    endif
    if a:docomment
      exe "normal! '" . a:a . "_\<C-V>'" . a:b . 'I' . b:comment
    else
      exe "'".a:a.",'".a:b . 's/^\(\s*\)' . escape(b:comment,'/') . '/\1/e'
    endif
  endfunction

  " Comment lines in marks set by g@ operator.
  function! DoCommentOp(type)
    call CommentMark(1, '[', ']')
  endfunction

  " Uncomment lines in marks set by g@ operator.
  function! UnCommentOp(type)
    call CommentMark(0, '[', ']')
  endfunction

  " Return string used to comment line for current filetype.
  function! CommentStr()
    if &ft == 'cpp' || &ft == 'java' || &ft == 'javascript'
      return '//'
    elseif &ft == 'vim'
      return '"'
    elseif &ft == 'python' || &ft == 'perl' || &ft == 'sh' || &ft == 'R' || &ft == 'tmux' || &ft == 'readline'
      return '#'
    elseif &ft == 'lisp' || &ft == 'dosini'
      return ';'
    elseif &ft == 'xdefaults'
      return '!'
    elseif &ft == 'matlab'
      return '%'
    endif
    return ''
  endfunction

  nnoremap gc <Esc>:set opfunc=DoCommentOp<CR>g@
  nnoremap gC <Esc>:set opfunc=UnCommentOp<CR>g@
  vnoremap gc <Esc>:call CommentMark(1,'<','>')<CR>
  vnoremap gC <Esc>:call CommentMark(0,'<','>')<CR>
"}}}


" Prevent CTRL-F and scroll wheel from scrolling into a tilde-abyss:

" Scroll down but don't view anything lower than 'max_overscroll' lines
" below the last line (unless that is already the current viewing position
" in which case just don't scroll anymore).
function! ScrollDown(scroll_amount, max_overscroll)
  let l:scroll_amount = a:scroll_amount

  " "(line('.') - winline() + 1)" is an expression for the line nubmer of the
  " top of the winview.
  " The test in English is 'if the distance between the last line and the
  " line at the top of the window is >= to the distance between the winheight
  " and the max_overscroll, then procede with scrolling'.
  while l:scroll_amount > 0 && line('$') - (line('.') - winline() + 1) >= winheight(0) - a:max_overscroll
      exec 'norm! ' . "\<C-e>"
      let l:scroll_amount-=1
  endwhile
endfunction
" BUG: Needs a "line('$')" and "line('.')" equivalent that accounts for wrapped
" lines, as with wrapped lines this can stop scrolling earlier than it should.
" TODO: Make this work in visual mode.
" See https://stackoverflow.com/questions/21859186/vim-mapping-normal-visual-mode-movements/21859475#21859475
" for a possible pointer in the right direction.

nnoremap <silent> <ScrollWheelDown> :<C-u>call ScrollDown(3, winheight(0)/2)<cr>
inoremap <silent> <ScrollWheelDown> <C-o>:<C-u>call ScrollDown(3, winheight(0)/2)<cr>
nnoremap <silent> <C-f> :<C-u>call ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
nnoremap <silent> <PageDown> :<C-u>call ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
inoremap <silent> <PageDown> <C-o>:<C-u>call ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
" ('winheight(0) - 2' is the number of lines CTRL-F scrolls)
