if ! (exists('g:plugins_i_want_to_load') && has_key(g:plugins_i_want_to_load, 'vim-hardtime') && g:plugins_i_want_to_load['vim-hardtime'])
  finish
endif

let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_motion_with_count_resets = 1
let g:hardtime_showmsg = 0
let g:hardtime_allow_different_key = 1

"let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+", "<SPACE>", "<BS>", "<CR>"]
let g:list_of_normal_keys = ["h", "j", "k", "l", "<SPACE>", "<BS>", "<CR>"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>", "<SPACE>", "<BS>", "<CR>"]
let g:list_of_insert_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_disabled_keys = []
