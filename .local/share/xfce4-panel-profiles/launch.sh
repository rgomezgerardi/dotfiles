#!/bin/bash

# Terminate already running bar instances
killall -q xfce4-panel --disable-wm-check

# Wait until the processes have been shut down
while pgrep -u $UID -x xfce4-panel >/dev/null; do sleep 1; done

# Launch taskbar, using default config location
xfce4-panel &

echo "xfce4-panel launched..."
