#!/bin/zsh
# System


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

# export MESA_GL_VERSION_OVERRIDE=4.5
# LIBGL_ALWAYS_SOFTWARE=1

# Folder


export REPO="$HOME/repo"
export PHONE="$HOME/phone"
export FILES="/mnt/files/Ricardo"
export BOOKS="$FILES/Books"
export DOWNLOADS="$FILES/Downloads"
export VIDEOS="$FILES/Videos"
export MOVIES="$VIDEOS/Movies"
export SERIES="$VIDEOS/Series"
export DOCUMENTS="$FILES/Documents"
export NOTE="$DOCUMENTS/note"
export MUSIC="$FILES/Music"
export PICTURES="$FILES/Pictures"
export PROGRAMS="$FILES/Programs"
export PROJECTS="$FILES/Projects"
export ROTYEN="$PROJECTS/godot/2d/Rotyen"

# Program


#export SHELL=zsh
# export TERM="xterm-256color"
export TERMINAL="st"
export EDITOR="vim"
# export VISUAL="vim"
export IDLE="emacsclient"
#export IDLE="emacsclient -c -a emacs"
export BROWSER="brave"
export READER="zathura"
export IMAGE_VIEWER="sxiv"
export DESKTOP_SESSION="bspwm"

# Cleanup


export WINEPREFIX="$HOME/wine/default"
export RT_HOME="$XDG_CONFIG_HOME/rtorrent"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
