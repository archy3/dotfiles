" If no filetype detected, set it to text:
autocmd BufEnter * if &filetype ==# '' | setfiletype text | endif
