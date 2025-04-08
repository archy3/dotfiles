if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vim-surround') && g:plugins_i_want_to_load['vim-surround'])
  finish
endif

let g:surround_no_mappings = 1

" Use just 's' instead of 'ys', and use s/S instead of S/gS in visual mode
nmap ds <Plug>Dsurround
nmap cs <Plug>Csurround
nmap cS <Plug>CSurround
nmap s  <Plug>Ysurround
nmap S  <Plug>YSurround
nmap ss <Plug>Yssurround
nmap Ss <Plug>YSsurround
nmap SS <Plug>YSsurround
xmap s  <Plug>VSurround
xmap S  <Plug>VgSurround
