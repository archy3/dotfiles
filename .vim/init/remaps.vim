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
nnoremap gb <cmd>ls<cr>:<space><space><space><space><space><space><space><space>b

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
nnoremap <C-s> <cmd>update<cr>
inoremap <C-s> <cmd>update<cr>
" (':update' is like ':w' but doesn't write when the file hasn't been modified)

" Have multi-character delete operations
" in insert mode create undo checkpoints:
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" Window remaps
nnoremap <C-h> <cmd>wincmd h<cr>
nnoremap <C-j> <cmd>wincmd j<cr>
nnoremap <C-k> <cmd>wincmd k<cr>
nnoremap <C-l> <cmd>wincmd l<cr>

" Change splits to horizontal/vertical (from https://stackoverflow.com/a/1269631):
nnoremap <F5> <cmd>wincmd t <bar> wincmd K<cr><C-w><C-p>
nnoremap <F2> <cmd>wincmd t <bar> wincmd H<cr><C-w><C-p>

" Resize windows more easily:
nnoremap <left> <cmd>vert resize -1<cr>
nnoremap <right> <cmd>vert resize +1<cr>
nnoremap <down> <cmd>resize -1<cr>
nnoremap <up> <cmd>resize +1<cr>

" Create inner line object (from https://vimrcfu.com/snippet/269):
onoremap <silent> <expr> il '<cmd> normal! ^v' . (v:count >= 2 ? v:count-1 . 'j' : '') . 'g_<cr>'
xnoremap <silent> <expr> il ':<C-u>normal! ^v' . (v:count >= 2 ? v:count-1 . 'j' : '') . 'g_<cr>'
nnoremap dal 0D

" Open terminal in the directory of the current buffer:
" (from https://vi.stackexchange.com/a/14533)
nnoremap <F1> <cmd>let $VIM_WORKING_DIR=expand('%:p:h')<cr><cmd>vert term<cr>
  \ cd -- "$VIM_WORKING_DIR" && clear<cr>
nnoremap <F7> <cmd>let $VIM_WORKING_DIR=expand('%:p:h')<cr><cmd>term<cr>
  \ cd -- "$VIM_WORKING_DIR" && clear<cr>

let g:mapleader = ' '
let g:maplocalleader = ','

" GUI save as:
nnoremap <Leader><C-s> <cmd>browse<space>confirm<space>saveas<cr>

" Print:
"nnoremap <Leader><C-p> :%w !lp -o print-quality=3 -o sides=one-sided -o outputorder=reverse -o ColorModel=Gray<cr>
nnoremap <Leader><C-p> <cmd>hardcopy<cr>

" GUI open folder of current file:
nnoremap <Leader><C-e> <cmd>
  \ call RunCmdIfExecutablesExist('!pcmanfm --new-win -- %:p:h:S', ['pcmanfm'], 1)<cr>

" Delete current file (GUI prompt):
nnoremap <silent> <Leader><Leader>D
  \ <cmd>
  \   if confirm('Delete ' . expand('%:p') . '?', "No\nYes", 1) ==# 2 <bar>
  \     call delete(expand('%:p')) <bar>
  \   endif
  \ <cr>

" Make file executable:
nnoremap <Leader><C-x> <cmd>call <SID>MakeExecutable(expand('%:p'))<cr>

function! s:MakeExecutable(file) abort
  let l:perms = getfperm(a:file)

  if !filereadable(a:file)
    echo 'File either does not exist, is a directory, or is not readable'
    return
  elseif l:perms =~# '^[r-][w-]-[r-][w-][x-][r-][w-][x-]$'
    call setfperm(a:file, l:perms[:1] . 'x' . l:perms[3:])
  elseif l:perms =~# '^[r-][w-]x[r-][w-][x-][r-][w-][x-]$'
    echo 'File is already executable'
    return
  else
    echo 'Unable to retrieve permission information (permissions not set)'
    return
  endif

  if getfperm(a:file) =~# '^[r-][w-]x[r-][w-][x-][r-][w-][x-]$'
    echo 'Executable permission set'
  else
    echo 'Failed to set executable permission'
  endif
endfunction

" Toggles:
nnoremap <Leader>s <cmd>setlocal spell! spell?<cr>
nnoremap <Leader><Leader>l <cmd>setlocal list! list?<cr>
nnoremap <Leader><Leader>h <cmd>setlocal hlsearch! hlsearch?<cr>
nnoremap <Leader><Leader>w <cmd>set wrap! wrap?<cr>
nnoremap <Leader><Leader>; <cmd>setlocal linebreak! linebreak?<cr>
nnoremap <Leader><Leader>y <cmd>call <SID>ToggleSystemClipboard()<cr>

" Toggle using internal registers or system clipboard:
function! s:ToggleSystemClipboard() abort
  if &clipboard =~# 'unnamedplus'
    set clipboard-=unnamedplus clipboard?
  else
    set clipboard^=unnamedplus clipboard?
  endif
endfunction

" Undo/redo to last save:
nnoremap <Leader>u <cmd>earlier 1f<cr>
nnoremap <Leader>U <cmd>later 1f<cr>

" Find word:
nnoremap <Leader>/ /\<\><left><left>

" Find and replace:
nnoremap <Leader>h :%s//g<left><left>

" Replace every instance of current word:
nnoremap <Leader>H :%s/\<<C-r><C-w>\>//gI<left><left><left>

" Autocorrect current word:
nnoremap <Leader>z 1z=

" Like 'yy' but does not copy the final newline (or the leading whitespace):
nnoremap <silent> <Leader>yy <cmd>exec 'norm! ^' . v:count1 . 'y$'<cr>

" copy entire file into clipboard
nnoremap <silent> <Leader>y<Leader> <cmd>call <SID>CopyBufferToClipboard()<cr>

function! s:CopyBufferToClipboard() abort
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
  function! s:CustomPasteAction(replaceRegEx, prePasteCmd) abort
    let l:saveReg = @@
    let l:reg = v:register
    let l:regContents = getreg(l:reg)

    " Remove substrings represented by a:replaceRegEx
    call setreg(l:reg, substitute(l:regContents, a:replaceRegEx, '', 'g'))

    execute 'normal! ' . a:prePasteCmd . "\<C-r>\<C-o>" . l:reg

    let @@ = l:saveReg
    call setreg(l:reg, l:regContents)
  endfunction

  " Append yanked test to end of line or after cursor, separated by a space:
  function! s:PasteAtEndOfLine(...) abort
    " Check if line already ends in whitespace or not
    let l:prePasteCmd = (getline('.') =~# '\s\+$' ? 'A' : "A\<space>")
    " Remove leading and trailing white space (including newlines)
    call s:CustomPasteAction('\_s*$\|^\_s*', l:prePasteCmd)
  endfunction
  function! s:PasteAtEndOfCursor(...) abort
    " Check if character under cursor is already whitespace or not
    let l:prePasteCmd = (getline('.')[col('.') - 1] =~# '\s' ? 'a' : "a\<space>")
    " Remove leading and trailing white space (including newlines)
    call s:CustomPasteAction('\_s*$\|^\_s*', l:prePasteCmd)
  endfunction
  nnoremap <Leader>A <cmd>set opfunc=<SID>PasteAtEndOfLine<cr>g@<space>
  nnoremap <Leader>a <cmd>set opfunc=<SID>PasteAtEndOfCursor<cr>g@<space>

  function! s:PasteOverInnerLine(...) abort
    " Remove leading spaces and any trailing newline from register:
    call s:CustomPasteAction('\s*\n\?$\|^\s*', "^\"_cg_")
  endfunction
  nnoremap <silent> <Leader>cil <cmd>set opfunc=<SID>PasteOverInnerLine<cr>g@<space>

  " change with yanked text
  " From https://www.reddit.com/r/vim/comments/a9nyqc/how_to_paste_without_losing_the_text_in_the/ecmt0li/?utm_source=reddit&utm_medium=web2x&context=3
  function! s:PasteOver(type, ...) abort
    let l:saveSel = &selection
    let &selection = 'inclusive'

    if a:0 " Invoked from Visual mode, use '< and '> marks.
      silent exe 'normal! `<' . a:type . '`>'
    elseif a:type ==# 'line'
      silent exe "normal! '[V']"
    elseif a:type ==# 'block'
      silent exe "normal! `[\<C-V>`]"
    else
      silent exe 'normal! `[v`]'
    endif

    " Remove final trailing newline from yanks like "yy"
    call s:CustomPasteAction('\n$', "\"_c")

    let &selection = l:saveSel
  endfunction
  nnoremap <silent> <Leader>c <cmd>set opfunc=<SID>PasteOver<cr>g@
  nnoremap <silent> <Leader>cc 0<cmd>set opfunc=<SID>PasteOver<cr>g@$
  nnoremap <silent> <Leader>C <cmd>set opfunc=<SID>PasteOver<cr>g@$
"}}}

" Buffer remaps:
"{{{
  nnoremap <Leader>b <cmd>bn <cr>
  nnoremap <Leader>B <cmd>bp <cr>
  nnoremap <Leader>q <cmd>call <SID>DeleteBuffer(0)<cr>
  nnoremap <Leader>Q <cmd>call <SID>DeleteBuffer(1)<cr>
  function! s:DeleteBuffer(force) abort
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
      exec (a:force ? 'quit' : "norm! \<C-c>")

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
nnoremap <Leader>w <cmd>wincmd w<cr>
nnoremap <Leader>W <cmd>wincmd W<cr>

" Close windows and tabs:
nnoremap <Leader>x <cmd>close<cr>
nnoremap <Leader>X <cmd>tabclose<cr>

" Move window to new tab:
nnoremap <Leader>o <cmd>wincmd T<cr>ze

" Create new window in the most likely desired way:
nnoremap <Leader>v <cmd>execute (winwidth(0) >= (2 * &colorcolumn) ? 'vsp' : 'sp')<cr>

" Quickly set the filetype:
nnoremap <leader>ft :setfiletype<space>


" Comments:
"{{{
  " from: https://vim.fandom.com/wiki/Commenting_with_opfunc

  " Comment or uncomment lines from mark a to mark b.
  function! s:CommentMark(docomment, a, b) abort
    "let l:comment = CommentStr() . ' '
    " (Would nice to use the above but skip blank lines)
    let l:comment = s:CommentStr()

    if a:docomment
      exe "normal! '" . a:a . "_\<C-V>'" . a:b . 'I' . l:comment
    else
      exe "'" . a:a . ",'" . a:b . 's/^\(\s*\)' . escape(l:comment,'/') . '/\1/e'
    endif
  endfunction

  " Comment lines in marks set by g@ operator.
  function! s:DoCommentOp(type) abort
    call s:CommentMark(1, '[', ']')
  endfunction

  " Uncomment lines in marks set by g@ operator.
  function! s:UnCommentOp(type) abort
    call s:CommentMark(0, '[', ']')
  endfunction

  " Return string used to comment line for current filetype.
  function! s:CommentStr() abort
    if index(['c', 'cpp', 'java', 'javascript'], &filetype) !=# -1
      return '//'
    elseif index(['vim'], &filetype) !=# -1
      return '"'
    elseif index(['awk', 'conf', 'make', 'perl', 'ps1', 'python', 'r', 'readline', 'sh', 'snippets', 'tmux'], &filetype) !=# -1
      return '#'
    elseif index(['dosini', 'lisp'], &filetype) !=# -1
      return ';'
    elseif index(['xdefaults'], &filetype) !=# -1
      return '!'
    elseif index(['matlab', 'tex'], &filetype) !=# -1
      return '%'
    elseif index(['dosbatch'], &filetype) !=# -1
      return 'rem '
    endif
    return ''
  endfunction

  nnoremap gc <Esc><cmd>set opfunc=<SID>DoCommentOp<CR>g@
  nnoremap gC <Esc><cmd>set opfunc=<SID>UnCommentOp<CR>g@
  xnoremap gc <Esc><cmd>call <SID>CommentMark(1,'<','>')<CR>
  xnoremap gC <Esc><cmd>call <SID>CommentMark(0,'<','>')<CR>
"}}}


" Prevent CTRL-F and scroll wheel from scrolling into a tilde-abyss:
"{{{
  " Scroll down but don't view anything lower than 'max_overscroll' lines
  " below the last line (unless that is already the current viewing position
  " in which case just don't scroll anymore).
  function! s:ScrollDown(scroll_amount, max_overscroll) abort
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

  nnoremap <ScrollWheelDown> <cmd>call <SID>ScrollDown(3, winheight(0)/2)<cr>
  inoremap <ScrollWheelDown> <cmd>call <SID>ScrollDown(3, winheight(0)/2)<cr>
  nnoremap <C-f> <cmd>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  nnoremap <PageDown> <cmd>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  inoremap <PageDown> <cmd>call <SID>ScrollDown(v:count1*(winheight(0) - 2), 5)<cr>
  " ('winheight(0) - 2' is the number of lines CTRL-F scrolls)
"}}}
