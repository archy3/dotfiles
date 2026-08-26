if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vim-sneak') && g:plugins_i_want_to_load['vim-sneak'])
  finish
endif

let g:sneak#label = 1
let g:sneak#s_next = 0
let g:sneak#use_ic_scs = 1
nnoremap <expr> <cr> (&buftype =~# '^$\\|^help$') ? '<Plug>Sneak_s' : '<cr>'
nnoremap <bs> <Plug>Sneak_S
xnoremap <cr> <Plug>Sneak_s
xnoremap <bs> <Plug>Sneak_S
