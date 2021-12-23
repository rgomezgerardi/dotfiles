#!/bin/zsh
export PATH="${PATH:+${PATH}:}$(find ~/.local/bin -type d -printf '%p:' | sed 's/:$//')"
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/go/bin"

# export MANPAGER='nvim +Man!'
export MANWIDTH=999

#Ibus settings if you need them
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus

#export SHELL=zsh
# export TERMINAL=st
export EDITOR="nvim"
export IDLE="emacsclient"
#export IDLE="emacsclient -c -a emacs"
export BROWSER="brave"
export READER="zathura"
export IMAGE_VIEWER="sxiv"

# Wine
export WINEPREFIX="$HOME/Wine/Default"

# rTorrent
export RT_HOME="$XDG_CONFIG_HOME/rtorrent"

# Ranger
#export RANGER_LOAD_DEFAULT_RC=FALSE

export BOOKS=/mnt/files/Ricardo/Books
export COMMANDS=/mnt/files/Ricardo/Documents/Commands
export COURSES=/mnt/files/Ricardo/Videos/Courses
export DOCUMENTS=/mnt/files/Ricardo/Documents
export DOWNLOADS=/mnt/files/Ricardo/Downloads
export GITHUB=/mnt/files/Ricardo/Documents/Github
export MOVIES=/mnt/files/Ricardo/Videos/Movies
export MUSIC=/mnt/files/Ricardo/Music
export NOTES=/mnt/files/Ricardo/Documents/Notes
export PICTURES=/mnt/files/Ricardo/Pictures
export PROGRAMS=/mnt/files/Ricardo/Programs
export PROJECTS=/mnt/files/Ricardo/Projects
export ROTYEN=/mnt/files/Ricardo/Projects/godot/2d/Rotyen
export SERIES=/mnt/files/Ricardo/Videos/Series
export VIDEOS=/mnt/files/Ricardo/Videos
