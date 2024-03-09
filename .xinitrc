# Import system-wide xinitrc (enable if troubleshooting something)
# . /etc/X11/xinit/xinitrc

# Prevent GTK3 apps from starting really slowly
dbus-update-activation-environment DISPLAY XAUTHORITY

xrdb -merge ~/.Xresources
SXHKD_SHELL="/bin/sh" sxhkd &
xrandr --output DVI-0 --mode 1680x1050 --set TearFree on

if [ polybar = p ]; then
  xwallpaper --zoom ~/pictures/wallpapers/hd-desktop-wallpaper-9.jpg &&
  sleep 0.2 && # Wait for openbox to create the workspaces
  polybar -r mybar &
else
  GTK_IM_MODULE=xim pcmanfm --desktop &
  lxpanel &
fi

dunst &
~/scripts/autostart/unclean-shutdown-check.sh &
~/scripts/autostart/set-keyboard-layout-on-usb-connect.sh &

if command -v spice-vdagent > /dev/null; then
  ~/scripts/vm-resize.sh &
else
  redshift &
  xscreensaver -no-splash &
  { pgrep -U "$(id -un)" -xf "irexec -d" || { irexec -d & }; } &

  ~/scripts/autostart/sound-as-xscreensaver-impedence.sh > /dev/null &
  ~/scripts/autostart/move-reminder.sh &
  ~/scripts/autostart/mem-watcher.sh &
fi

exec openbox
