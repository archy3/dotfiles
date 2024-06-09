# Import system-wide xinitrc (enable if troubleshooting something)
# . /etc/X11/xinit/xinitrc

# Prevent GTK3 apps from starting really slowly
dbus-update-activation-environment DISPLAY XAUTHORITY

xrdb -merge ~/.Xresources
SXHKD_SHELL="/bin/sh" sxhkd -m -1 &
#xrandr --output DVI-0 --auto --set TearFree on
xrandr --output HDMI-0 --auto --set TearFree on --rotate left \
  --output DVI-0 --auto --primary --set TearFree on --left-of HDMI-0

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
~/scripts/autostart/turn-numlock-on.sh &

if command -v spice-vdagent > /dev/null; then
  ~/scripts/autostart/vm-resize.sh &
else
  redshift &
  xscreensaver -no-splash &
  { pgrep -U "$(id -un)" -xf "irexec -d" || { irexec -d & }; } &

  ~/scripts/autostart/sound-as-xscreensaver-impedence.sh > /dev/null &
  ~/scripts/autostart/move-reminder.sh &
  ~/scripts/autostart/mem-watcher.sh &
fi

exec openbox
