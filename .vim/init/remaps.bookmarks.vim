scriptencoding utf-8

function! s:Show_bookmarks_menu() abort
  " Some other highly visible emojis: 🐷🐽🦜🐬🐠🦠🌼🌹🌺🌻🌷🍤🍰🧉🌚🌝🌞🌀💧
  let l:config = [
    \   ['q'    , 'bash aliases 🥦',   '~/.bash_aliases'],
    \   ['Q'    , 'bashrc       🥦',   '~/.bashrc'],
    \   ['w'    , 'profile      🥦',   '~/.profile'],
    \   ['e'    , 'Xresources 🐧',     '~/.Xresources'],
    \   ['r'    , 'xinitrc    🐧',     '~/.xinitrc'],
    \   ['R'    , 'xserverrc  🐧',     '~/.xserverrc'],
    \   ['a'    , 'vimrc 📝',          (has('unix') ? '~/.vim' : '~/vimfiles') . '/vimrc'],
    \   ['s'    , 'openbox 🍊',        '~/.config/openbox/rc.xml'],
    \   ['S'    , 'polybar 🍋',        '~/.config/polybar/config'],
    \   ['<C-s>', 'dunst 🔔',          '~/.config/dunst/dunstrc'],
    \   ['d'    , 'tag-tools      📀', '~/scripts/tags/tag-tools.sh'],
    \   ['D'    , 'custom-tag     📀', '~/scripts/tags/custom-tag.sh'],
    \   ['<C-d>', 'tag-tools-test 📀', '~/scripts/tags/tag-tools-test.sh'],
    \   ['f'    , 'debootstrap 🍥',    '~/scripts/debootstrap/debootstrap-auto-install.sh'],
    \   ['z'    , 'zathura 🔥',        '~/.config/zathura/zathurarc'],
    \   ['x'    , 'sxhkd 🔑',          '~/.config/sxhkd/sxhkdrc'],
    \   ['c'    , 'nsxiv 🎨',          '~/.config/nsxiv/exec/key-handler'],
    \   ['v'    , 'tmux 🌐',           '~/.config/tmux/tmux.conf']
    \ ]

  new
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal modifiable
  setlocal cursorline

  let l:line_count = 0
  for l:triplet in l:config
    if filereadable(expand(l:triplet[2]))
      exec 'nnoremap <nowait> <buffer> ' . l:triplet[0] .
        \ ' <cmd>bd<cr><cmd>edit ' . fnameescape(l:triplet[2]) . '<cr>'
      call appendbufline('%', '$', printf('%-5s %s', l:triplet[0], l:triplet[1]))
      let l:line_count += 1
    endif
  endfor
  keepjumps normal! ggdd
  exec 'resize ' . l:line_count

  setlocal nomodifiable
  nnoremap <buffer> <cr> <cmd>call <SID>Goto_bookmark_on_current_line()<cr>
  nnoremap <buffer> <esc> <cmd>bd<cr>
endfunction

function! s:Goto_bookmark_on_current_line() abort
  let l:key = split(getline('.'))[0]

  " If the key is of the form "<C-x>",
  " we need to get 'x' (which always has an index of 3)
  " and convert it to the corresponding control character.
  if l:key[0] ==# '<'
    " 'a' has ASCII value 97 and '^a' (control-a) has ASCII value 1
    " (and '^b' has ASCII value 2, '^c' has ASCII value 3, ...).
    let l:key = nr2char(char2nr(tolower(l:key[3]))-97+1)
  endif

  exec 'norm ' . l:key
endfunction

nnoremap <Leader><Tab> <cmd>call <SID>Show_bookmarks_menu()<cr>
