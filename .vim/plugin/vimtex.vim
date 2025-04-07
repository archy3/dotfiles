if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vimtex') && g:plugins_i_want_to_load['vimtex'])
  finish
endif

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

" Disable conceal (because conceal messes with plugins like vim-sneak)
let g:vimtex_syntax_conceal_disable=1

" Disable `]]` insert mode mapping (`<plug>(vimtex-delim-close)`)
" since it makes typing "[]" annoying.
let g:vimtex_mappings_disable = {
      \ 'i': [']]'],
      \}

" Use `ai` and `ii` for the item text object
omap ai <Plug>(vimtex-am)
xmap ai <Plug>(vimtex-am)
omap ii <Plug>(vimtex-im)
xmap ii <Plug>(vimtex-im)

" Also use `m` for the math objects (instead of the default `$`)
omap am <Plug>(vimtex-a$)
xmap am <Plug>(vimtex-a$)
omap im <Plug>(vimtex-i$)
xmap im <Plug>(vimtex-i$)

nmap dsm <plug>(vimtex-env-delete-math)
nmap csm <plug>(vimtex-env-change-math)
nmap tsm <plug>(vimtex-env-toggle-math)
