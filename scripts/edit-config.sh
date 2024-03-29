#!/bin/sh

list()
{
  dmenu -i -l 17 -fn 'Monospace-13' << 'EOF'
.bash_aliases
.bashrc
.inputrc
.lesskey
.profile
.XCompose
.xinitrc
.Xresources
.xserverrc
.config/dunst/dunstrc
.config/openbox/rc.xml
.config/polybar/config
.config/sxhkd/sxhkdrc
.config/nsxiv/exec/key-handler
.config/tmux/tmux.conf
.config/zathura/zathurarc
.vim/vimrc
EOF
}

choice="${HOME%/}/$(list)" || exit "$?"

if [ -e "$choice" ]; then
  gvim -- "$choice"
fi
