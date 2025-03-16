call SetTabBehavior(2,8)

if expand("%:p") ==# expand("~/.config/tmux/tmux.conf")
  nnoremap <buffer> gf $gf
endif
