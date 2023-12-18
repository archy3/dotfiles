let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_delim_toggle_mod_list = [
  \ ['\left', '\right'],
  \ ['\bigl', '\bigr'],
  \ ['\Bigl', '\Bigr'],
  \ ['\biggl', '\biggr'],
  \ ['\Biggl', '\Biggr'],
  \]

" Put files generated at compile time in ./out/
let g:vimtex_compiler_latexmk = {
    \ 'out_dir' : 'out',
    \}
