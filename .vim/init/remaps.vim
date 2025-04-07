" Use right click to copy/paste to/from the system clipboard (like Windows cmd):
nnoremap <RightMouse> "+<MiddleMouse>
inoremap <RightMouse> <C-g>u<C-o>"+<MiddleMouse>
vnoremap <RightMouse> "+y

" Also make middle click use <C-g>u to create an undo checkpoint:
inoremap <MiddleMouse> <C-g>u<MiddleMouse>

" Use mouse back button to open a new line below the mouse cursor:
" (The '0d$' make sure the line is blank [it sometimes isn't depending on the ftplugin])
nnoremap <X1Mouse> <LeftMouse>o<esc>0d$

" Mouse undo/redo:
nnoremap <X2Mouse> u
nnoremap <C-X2Mouse> <C-r>

" Mouse visual delete:
vnoremap <X2Mouse> d

" Mouse left/right scroll using up/down scroll (doesn't work in terminal vim):
nnoremap <S-ScrollWheelDown> <ScrollWheelRight>
nnoremap <S-ScrollWheelUp> <ScrollWheelLeft>
inoremap <S-ScrollWheelDown> <ScrollWheelRight>
inoremap <S-ScrollWheelUp> <ScrollWheelLeft>
vnoremap <S-ScrollWheelDown> <ScrollWheelRight>
vnoremap <S-ScrollWheelUp> <ScrollWheelLeft>


" Like remapping j/k to gj/gk but making relative line numbers work as expected:
nnoremap <expr> j (v:count ==# 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count ==# 0 ? 'gk' : 'k')

nnoremap Y y$

" Scroll left and right quickly:
nnoremap - 10zh
nnoremap + 10zl

" Delete to matching indent:
nnoremap <silent> dsi ^"py0^d/^<C-r>p[^ \t]/+0<cr>
nnoremap <silent> dsu ^"py00d?^<C-r>p[^ \t]?+0<cr>

" Delete till end of function braces:
nnoremap <silent> dsb 0d][

" Autocorrect last spelling mistake.
" From https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
inoremap <C-z> <c-g>u<Esc>[s1z=`]a<c-g>u

" List buffers:
nnoremap gb :ls<cr>:<space><space><space><space><space><space><space><space>b

" Allow for easy putting of yanked and copied text:
" Note: <C-r><C-o> is like <C-r> but prevents autoindent from altering the text.
"       <C-g>u creates an undo checkpoint before pasting.
inoremap <C-f> <nop>
inoremap <C-f><space> <C-g>u<C-r><C-o>0
inoremap <C-f><C-v> <C-g>u<C-r><C-o>+
inoremap <C-f>v <C-g>u<C-r><C-o>+

cnoremap <C-f> <nop>
cnoremap <C-f><space> <C-r>0
cnoremap <C-f><PageDown> <C-r>0
cnoremap <C-f><C-v> <C-r>+
cnoremap <C-f>v <C-r>+
cnoremap <C-f><C-f> <C-f>

" Make <C-n> feel natural on my keyboard:
"inoremap <home> <C-n>

" Use modern shortcuts for system clipboard and saving:
vnoremap <C-c> "+y
inoremap <C-v> <C-g>u<C-r><C-o>+
nnoremap <C-s> :update<cr>
inoremap <C-s> <C-o>:update<cr>
" (':update' is like ':w' but doesn't write when the file hasn't been modified)

" Have multi-character delete operations
" in insert mode create undo checkpoints:
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Window remaps
nnoremap <silent> <C-h> :wincmd h<cr>
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-k> :wincmd k<cr>
nnoremap <silent> <C-l> :wincmd l<cr>

" Change splits to horizontal/vertical (from https://stackoverflow.com/a/1269631):
nnoremap <silent> <F5> :wincmd t <bar> wincmd K<cr><C-w><C-p>
nnoremap <silent> <F2> :wincmd t <bar> wincmd H<cr><C-w><C-p>

" Resize windows more easily:
nnoremap <silent> <left> :vert resize -1<cr>
nnoremap <silent> <right> :vert resize +1<cr>
nnoremap <silent> <down> :resize -1<cr>
nnoremap <silent> <up> :resize +1<cr>

" Create inner line object (from https://vimrcfu.com/snippet/269):
onoremap <silent> <expr> il v:count==#0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count) . "jkg_<cr>"
xnoremap <silent> <expr> il v:count==#0 ? ":<c-u>normal! ^vg_<cr>" : ":<c-u>normal! ^v" . (v:count) . "jkg_h<cr>"
nnoremap dal 0D

let mapleader = " "
let maplocalleader = ","
" Open terminal in the directory of the current buffer:
" (from https://vi.stackexchange.com/a/14533)
nnoremap <F1> <cmd>let $VIM_WORKING_DIR=expand('%:p:h')<cr><cmd>vert term<cr>
  \ cd -- "$VIM_WORKING_DIR" && clear<cr>
nnoremap <F7> <cmd>let $VIM_WORKING_DIR=expand('%:p:h')<cr><cmd>term<cr>
  \ cd -- "$VIM_WORKING_DIR" && clear<cr>

" GUI save as:
nnoremap <Leader><C-s> :browse<space>confirm<space>saveas<cr>

" Print:
"nnoremap <Leader><C-p> :%w !lp -o print-quality=3 -o sides=one-sided -o outputorder=reverse -o ColorModel=Gray<cr>
nnoremap <Leader><C-p> :hardcopy<cr>

" GUI open folder of current file:
nnoremap <Leader><C-e> <cmd>
  \ call RunCmdIfExecutablesExist('!pcmanfm --new-win -- %:p:h:S', ['pcmanfm'], 1)<cr>

" Delete current file (GUI prompt):
nnoremap <silent> <Leader><Leader>D :if confirm("Delete ". expand('%:p') . "?", "No\nYes", 1) ==# 2 <bar> call delete(expand('%:p')) <bar> endif<cr>

" Make file executable:
nnoremap <Leader><C-x> <cmd>
  \ call RunCmdIfExecutablesExist('!chmod u+x -- %:p:S', ['chmod'], 1)<cr>

" Toggles:
nnoremap <silent> <Leader>s :setlocal spell! spell?<cr>
nnoremap <silent> <Leader><Leader>l :setlocal list! list?<cr>
nnoremap <silent> <Leader><Leader>h :setlocal hlsearch! hlsearch?<cr>
nnoremap <silent> <Leader><Leader>w :set wrap! wrap?<cr>
nnoremap <silent> <Leader><Leader>; :setlocal linebreak! linebreak?<cr>
nnoremap <silent> <Leader><Leader>y :call <SID>ToggleSystemClipboard()<cr>

" Toggle using internal registers or system clipboard:
function! s:ToggleSystemClipboard()
  if &clipboard =~# 'unnamedplus'
    set clipboard-=unnamedplus clipboard?
  else
    set clipboard^=unnamedplus clipboard?
  endif
endfunction

" Undo/redo to last save:
nnoremap <Leader>u :earlier 1f<cr>
nnoremap <Leader>U :later 1f<cr>

" Find word:
nnoremap <Leader>/ /\<\><left><left>

" Find and replace:
nnoremap <Leader>h :%s//g<left><left>

" Replace every instance of current word:
nnoremap <Leader>H :%s/\<<C-r><C-w>\>//gI<left><left><left>

" Autocorrect current word:
nnoremap <Leader>z 1z=

" Like 'yy' but does not copy the final newline (or the leading whitespace):
nnoremap <silent> <Leader>yy :<C-u>exec 'norm! ^' . v:count1 . 'y$'<cr>

" copy entire file into clipboard
nnoremap <silent> <Leader>y<Leader> :call <SID>CopyBufferToClipboard()<cr>
function! s:CopyBufferToClipboard()
  %y+
  " Remove EOF newline which usually isn't wanted:
  let l:regContents = getreg('+')
  if len(l:regContents) > 1 && l:regContents[-1:-1] ==# "\n"
    call setreg('+', l:regContents[:-2])
  endif
endfunction

" paste from clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Advanced pasting commands:
"{{{
  " From https://www.reddit.com/r/vim/comments/a9nyqc/how_to_paste_without_losing_the_text_in_the/ecmt0li/?utm_source=reddit&utm_medium=web2x&context=3
  " but just the pasting and command part.
  function! s:CustomPasteAction(replaceRegEx, prePasteCmd)
    let saveReg = @@
    let reg = v:register
    let regContents = getreg(reg)

    " Remove substrings represented by a:replaceRegEx
    call setreg(reg, substitute(regContents, a:replaceRegEx, '', 'g'))

    execute "normal! " . a:prePasteCmd . "\<C-r>\<C-o>" . reg

    let @@ = saveReg
    call setreg(reg, regContents)
  endfunction

  " Append yanked test to end of line or after cursor, separated by a space:
  function! s:PasteAtEndOfLine(...)
    " Check if line already ends in whitespace or not
    let l:prePasteCmd = (getline('.') =~# '\s\+$' ? 'A' : "A\<space>")
    " Remove leading and trailing white space (including newlines)
    call s:CustomPasteAction('\_s*$\|^\_s*', l:prePasteCmd)
  endfunction
  function! s:PasteAtEndOfCursor(...)
    " Check if character under cursor is already whitespace or not
    let l:prePasteCmd = (getline('.')[col('.') - 1] =~# '\s' ? 'a' : "a\<space>")
    " Remove leading and trailing white space (including newlines)
    call s:CustomPasteAction('\_s*$\|^\_s*', l:prePasteCmd)
  endfunction
  nnoremap <Leader>A :set opfunc=<SID>PasteAtEndOfLine<cr>g@<space>
  nnoremap <Leader>a :set opfunc=<SID>PasteAtEndOfCursor<cr>g@<space>

  function! s:PasteOverInnerLine(...)
    " Remove leading spaces and any trailing newline from register:
    call s:CustomPasteAction('\s*\n\?$\|^\s*', "^\"_cg_")
  endfunction
  nnoremap <silent> <Leader>cil :set opfunc=<SID>PasteOverInnerLine<cr>g@<space>

  " change with yanked text
  " From https://www.reddit.com/r/vim/comments/a9nyqc/how_to_paste_without_losing_the_text_in_the/ecmt0li/?utm_source=reddit&utm_medium=web2x&context=3
  function! s:PasteOver(type, ...)
    let saveSel = &selection
    let &selection = "inclusive"

    if a:0 " Invoked from Visual mode, use '< and '> marks.
      silent exe "normal! `<" . a:type . "`>"
    elseif a:type ==# 'line'
      silent exe "normal! '[V']"
    elseif a:type ==# 'block'
      silent exe "normal! `[\<C-V>`]"
    else
      silent exe "normal! `[v`]"
    endif

    " Remove final trailing newline from yanks like "yy"
    call s:CustomPasteAction('\n$', "\"_c")

    let &selection = saveSel
  endfunction
  nnoremap <silent> <Leader>c :set opfunc=<SID>PasteOver<cr>g@
  nnoremap <silent> <Leader>cc 0:set opfunc=<SID>PasteOver<cr>g@$
  nnoremap <silent> <Leader>C :set opfunc=<SID>PasteOver<cr>g@$
"}}}

" Buffer remaps:
"{{{
  nnoremap <Leader>b :bn <cr>
  nnoremap <Leader>B :bp <cr>
  nnoremap <Leader>q :call <SID>DeleteBuffer(0)<cr>
  nnoremap <Leader>Q :call <SID>DeleteBuffer(1)<cr>
  function! s:DeleteBuffer(force)
    let l:buf_to_delete = bufnr('%')
    let l:del_cmd = 'bdelete' . (a:force ? '! ' : ' ') . l:buf_to_delete
    let l:func_name = substitute(expand('<sfile>'), '.*\(\.\.\|\s\)', '', '')
      " Substitution pattern is from https://vi.stackexchange.com/a/5503

    " If there is an alternative buffer (AKA buffer 0), go to it.
    " Otherwise, go to the previous buffer.
    " (The intention after going to this alternate or previous buffer
    " is to then delete l:buf_to_delete from it.)
    let l:goto_alt_or_prev_buffer_cmd = buflisted(0) ? 'buffer #' : 'bprevious'

    " Quit out of a command history window
    " (force will also close the command line):
    if getcmdwintype() !=# ''
      exec (a:force ? "quit" : "norm! \<C-c>")

    " If the buffer isn't listed (e.g. help/netrw),
    " just go back to the previous/alternate buffer (if there is one)
    " (doing this will automatically discard the unlisted buffer):
    elseif !buflisted(l:buf_to_delete) && len(getbufinfo({'buflisted':1})) >= 1
      exec l:goto_alt_or_prev_buffer_cmd

    " Only delete the current listed buffer if it is not the only listed buffer:
    elseif len(getbufinfo({'buflisted':1})) >= 2
      try
        exec l:goto_alt_or_prev_buffer_cmd . ' | ' . l:del_cmd
      catch /^Vim\%((\a\+)\)\=:E89:/
        " Go back to buffer that failed to delete:
        exec 'buffer ' . l:buf_to_delete
        echo l:func_name . '(): Buffer ' . l:buf_to_delete . ' has unsaved changes.'
      catch
        " Go back to buffer that failed to delete, & display the error message:
        exec 'buffer ' . l:buf_to_delete
        echoerr v:exception
      endtry
    else
      echo l:func_name . '(): This is the only buffer.'
    endif
  endfunction
"}}}

" Jump to next window:
nnoremap <silent> <Leader>w :wincmd w<cr>
nnoremap <silent> <Leader>W :wincmd W<cr>

" Close windows and tabs:
nnoremap <silent> <Leader>x :close<cr>
nnoremap <silent> <Leader>X :tabclose<cr>

" Move window to new tab:
nnoremap <silent> <Leader>o :wincmd T<cr>ze

" Create new window in the most likely desired way:
nnoremap <silent> <Leader>v :execute (winwidth(0) >= (2 * &colorcolumn) ? 'vsp' : 'sp')<cr>

" Quickly set the filetype:
nnoremap <leader>ft :setfiletype<space>


" Comments:
"{{{
  " from: https://vim.fandom.com/wiki/Commenting_with_opfunc

  " Comment or uncomment lines from mark a to mark b.
  function! s:CommentMark(docomment, a, b)
    if !exists('b:comment')
      "let b:comment = CommentStr() . ' '
      " (Would nice to use the above but skip blank lines)
      let b:comment = s:CommentStr()
    endif
    if a:docomment
      exe "normal! '" . a:a . "_\<C-V>'" . a:b . 'I' . b:comment
    else
      exe "'".a:a.",'".a:b . 's/^\(\s*\)' . escape(b:comment,'/') . '/\1/e'
    endif
  endfunction

  " Comment lines in marks set by g@ operator.
  function! s:DoCommentOp(type)
    call s:CommentMark(1, '[', ']')
  endfunction

  " Uncomment lines in marks set by g@ operator.
  function! s:UnCommentOp(type)
    call s:CommentMark(0, '[', ']')
  endfunction

  " Return string used to comment line for current filetype.
  function! s:CommentStr()
    if index(['c', 'cpp', 'java', 'javascript'], &ft) != -1
      return '//'
    elseif index(['vim'], &ft) != -1
      return '"'
    elseif index(['conf', 'make', 'perl', 'ps1', 'python', 'r', 'readline', 'sh', 'snippets', 'tmux'], &ft) != -1
      return '#'
    elseif index(['dosini', 'lisp'], &ft) != -1
      return ';'
    elseif index(['xdefaults'], &ft) != -1
      return '!'
    elseif index(['matlab', 'tex'], &ft) != -1
      return '%'
    elseif index(['dosbatch'], &ft) != -1
      return 'rem '
    endif
    return ''
  endfunction

  nnoremap gc <Esc>:set opfunc=<SID>DoCommentOp<CR>g@
  nnoremap gC <Esc>:set opfunc=<SID>UnCommentOp<CR>g@
  xnoremap gc <Esc>:call <SID>CommentMark(1,'<','>')<CR>
  xnoremap gC <Esc>:call <SID>CommentMark(0,'<','>')<CR>
"}}}


" Prevent CTRL-F and scroll wheel from scrolling into a tilde-abyss:
"{{{
  " Scroll down but don't view anything lower than 'max_overscroll' lines
  " below the last line (unless that is already the current viewing position
  " in which case just don't scroll anymore).
  function! s:ScrollDown(scroll_amount, max_overscroll)
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

  nnoremap <silent> <ScrollWheelDown> :<C-u>call <SID>ScrollDown(3, winheight(0)/2)<cr>
  inoremap <silent> <ScrollWheelDown> <C-o>:<C-u>call <SID>ScrollDown(3, winheight(0)/2)<cr>
  nnoremap <silent> <C-f> :<C-u>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  nnoremap <silent> <PageDown> :<C-u>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  inoremap <silent> <PageDown> <C-o>:<C-u>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  " ('winheight(0) - 2' is the number of lines CTRL-F scrolls)
"}}}
