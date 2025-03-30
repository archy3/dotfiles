" From $VIMRUNTIME/defaults.vim:
function! s:DiffOrig(bang_on_means_start_diff_even_if_not_modified)
  let l:func_name = substitute(expand('<sfile>'), '.*\(\.\.\|\s\)', '', '')
    " Substitution pattern is from https://vi.stackexchange.com/a/5503

  if &diff
    echo l:func_name . '(): Diff is already on'
    return
  elseif &buftype !=# ''
    echo l:func_name . '(): buffer is not of the standard type'
    return
  elseif expand('%') ==# ''
    echo l:func_name . '(): buffer does not have an associated file'
    return
  elseif !filereadable(expand('%:p'))
    echo l:func_name . '(): Filename does not exists on disk'
    return
  elseif !&modified && !a:bang_on_means_start_diff_even_if_not_modified
    echo l:func_name . '(): No changes! (force with !)'
    return
  endif

  let l:filetype = &filetype
  let l:file = expand('%:p')
  vert topleft new
  set bt=nofile
  let &filetype = l:filetype
  exec 'read ++edit ' . fnameescape(l:file)
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

command! -bang DiffOrig call s:DiffOrig(<bang>0)
