if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vimtex') && g:plugins_i_want_to_load['vimtex'])
  finish
endif

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_indent_ignored_envs = ['verbatim', 'lstlisting']
let g:vimtex_delim_toggle_mod_list = [
  \ ['\left', '\right'],
  \ ['\bigl', '\bigr'],
  \ ['\Bigl', '\Bigr'],
  \ ['\biggl', '\biggr'],
  \ ['\Biggl', '\Biggr'],
  \]

" Put files generated at compile time in a temporary directory
let g:vimtex_compiler_latexmk = {
    \ 'out_dir' : tempname(),
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

augroup vimtex_copy_pdf
  autocmd!
  autocmd User VimtexEventCompileSuccess call s:CopyPdfToRootOfProjectDir()
augroup END

" Similar to `s:compiler.__init_temp_files()` and
" `s:compiler.__copy_temp_files()` from
" pack/plugins/opt/vimtex/autoload/vimtex/compiler/latexmk.vim
function! s:CopyPdfToRootOfProjectDir() abort
  if empty(b:vimtex.compiler.out_dir)
    return
  endif

  let l:pdf_basename = b:vimtex.compiler.file_info.jobname . '.pdf'

  let l:pdf_source = b:vimtex.compiler.out_dir . '/' . l:pdf_basename
  let l:pdf_dest = b:vimtex.compiler.file_info.root . '/' . l:pdf_basename

  if !vimtex#paths#is_abs(l:pdf_source)
    let l:pdf_source = b:vimtex.compiler.file_info.root . '/' . l:pdf_source
  endif

  if filereadable(l:pdf_source) && getftime(l:pdf_source) > getftime(l:pdf_dest)
    call writefile(readfile(l:pdf_source, 'b'), l:pdf_dest, 'b')
  endif
endfunction
