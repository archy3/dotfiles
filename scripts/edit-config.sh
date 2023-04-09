#!/bin/sh

list()
{
  dmenu -i -l 16 -fn 'Monospace-13' << 'EOF'
.bash_aliases
.bashrc
.inputrc
.lesskey
.profile
.xinitrc
.Xresources
.xserverrc
.config/dunst/dunstrc
.config/openbox/rc.xml
.config/polybar/config
.config/sxhkd/sxhkdrc
.config/sxiv/exec/key-handler
.config/tmux/tmux.conf
.config/zathura/zathurarc
.vim/vimrc
EOF
}

choice="${HOME%/}/$(list)" || exit "$?"

if [ -e "$choice" ]; then
  gvim -- "$choice"
fi
