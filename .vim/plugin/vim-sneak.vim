if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vim-sneak') && g:plugins_i_want_to_load['vim-sneak'])
  finish
endif

let g:sneak#label = 1
let g:sneak#s_next = 0
let g:sneak#use_ic_scs = 1
nmap <cr> <Plug>Sneak_s
nmap <bs> <Plug>Sneak_S

" Enter needs to work as enter for these buffers:
autocmd CmdwinEnter * nnoremap <buffer> <cr> <cr>
autocmd FileType qf nnoremap <buffer> <cr> <cr>
