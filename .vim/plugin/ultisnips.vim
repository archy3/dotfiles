if ! (has_key(g:plugins_i_want_to_load, 'ultisnips') && g:plugins_i_want_to_load['ultisnips'])
  finish
endif

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" From https://github.com/SirVer/ultisnips/issues/1038#issuecomment-452196478
" (See also https://github.com/SirVer/ultisnips/issues/1371#issuecomment-868769414
" and https://vim.fandom.com/wiki/Check_for_comments_independent_of_filetype)
function! GetHighLightType()
    return get(reverse(map(synstack(line('.'), col('.') - (col('.')>=2 ? 1 : 0)), {i,v -> synIDattr(v, 'name')})), 0, '')
endfunction
