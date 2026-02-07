" From $VIMRUNTIME/defaults.vim:
function! s:DiffOrig(bang_on_means_start_diff_even_if_not_modified) abort
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
  let &l:filetype = l:filetype
  setlocal buftype=nofile
  setlocal nobuflisted
  exec 'read ++edit ' . fnameescape(l:file)
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

command! -bang DiffOrig call s:DiffOrig(<bang>0)


let s:transpose_awk_script = '
  \ BEGIN {
  \   longest_line_length = 0;
  \ }
  \
  \ {
  \   lines[NR] = $0;
  \   line_length = length($0);
  \
  \   if (line_length > longest_line_length) {
  \     longest_line_length = line_length;
  \   }
  \ }
  \
  \ END {
  \   for (i = 1; i <= NR; i++) {
  \     lines[i] = sprintf("%-" longest_line_length "s", lines[i]);
  \   }
  \
  \   for (i = 1; i <= NR; i++) {
  \     for (j = 1; j <= longest_line_length; j++) {
  \       matrix[i "," j] = substr(lines[i], j, 1);
  \     }
  \   }
  \
  \   for (j = 1; j <= longest_line_length; j++) {
  \     row_of_transpose = "";
  \     for (i = 1; i <= NR; i++) {
  \       row_of_transpose = row_of_transpose matrix[i "," j];
  \     }
  \
  \     if (trim) {
  \       sub("[ \t]+$", "", row_of_transpose);
  \     }
  \
  \     printf "%s\n", row_of_transpose;
  \   }
  \ }
  \'

" The extra argument on shellescape() escapes characters
" (such as '!', '%', '#') that `:!` interprets with special meaning.
let s:transpose_awk_script = shellescape(s:transpose_awk_script, 1)

" Bang will right-pad the result with spaces
command! -range=% -bang Transpose
  \ :call RunCmdIfExecutablesExist(
  \   '<line1>,<line2>!awk -v trim=' . <bang>1 . ' ' . s:transpose_awk_script,
  \   ['awk'],
  \   1
  \ )
