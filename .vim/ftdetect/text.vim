" If no filetype detected, set it to text
" (from https://vi.stackexchange.com/a/13293):
autocmd BufNewFile,BufRead * if &filetype ==# '' | set filetype=text | endif

" Make this also work when opening vim without a file,
" when opening a new file (that doesn't exist),
" when opening an empty file (that exists),
" and when doing stuff like `enew`.
" (from https://vi.stackexchange.com/a/2559):
autocmd VimEnter * if ((&filetype ==# '') && ((@% == "") || (filereadable(@%) == 0) || (line('$') == 1 && col('$') == 1))) | set filetype=text | endif
  " For some reason `b:undo_ftplugin` isn't invoked in this case when
  " chaining to a new filetype.
  " A fix is provided in ~/.vim/after/ftplugin/text.vim


