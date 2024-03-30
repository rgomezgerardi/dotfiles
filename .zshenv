#!/bin/zsh
# System


#export PATH="${PATH:+${PATH}:}$(find ~/.local/bin -type d -printf '%p:' | sed 's/:$//')"
#export PATH="$PATH:$HOME/.config/emacs/bin"
#export PATH="$PATH:$HOME/.cargo/bin"
#export PATH="$PATH:$HOME/.local/share/go/bin"
# append
#path+=('/home/david/pear/bin')
path+=("$HOME/.cargo/bin")

# or prepend
#path=('/home/david/pear/bin' $path)
# export to sub-processes (make it inherited by child processes)
#export PATH

# export MANPAGER='nvim +Man!'
export MANWIDTH=999

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Other
export LANG=en_US.UTF-8

#export WINEPREFIX="$HOME/wine/default"
#export RT_HOME="$XDG_CONFIG_HOME/rtorrent"
#export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Flameshot
#export SDL_VIDEODRIVER=wayland
#export _JAVA_AWT_WM_NONREPARENTING=1
#export QT_QPA_PLATFORM=wayland
#export XDG_CURRENT_DESKTOP=sway
#export XDG_SESSION_DESKTOP=sway

#Ibus settings if you need them
#type ibus-setup in terminal to change settings and start the daemon
#delete the hashtags of the next lines and restart
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=dbus
#export QT_IM_MODULE=ibus

# export MESA_GL_VERSION_OVERRIDE=4.5
# LIBGL_ALWAYS_SOFTWARE=1

# Latex


export MANPATH="$MANPATH:/usr/local/texlive/2023/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2023/texmf-dist/doc/info"
export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"

# Folder


export REPO="$HOME/repo"
export PHONE="$HOME/phone"
export FILE="/mnt/file"
export BOOKS="$FILES/Books"
export DOWNLOADS="$FILES/Downloads"
export VIDEOS="$FILES/Videos"
export MOVIES="$VIDEOS/Movies"
export SERIES="$VIDEOS/Series"
export DOCUMENTS="$FILES/Documents"
export NOTE="$DOCUMENTS/note"
export MUSIC="$FILES/Music"
export PICTURE="$FILE/picture"
export PROGRAMS="$FILES/Programs"
export PROJECTS="$FILES/Projects"
export ROTYEN="$PROJECTS/godot/2d/Rotyen"
