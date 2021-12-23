#!/bin/zsh
# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# X11
export XINITRC="$XDG_CONFIG_HOME/xorg/xinitrc"
export MODMAP="$XDG_CONFIG_HOME/xorg/xmodmap"
export RESOURCES="$XDG_CONFIG_HOME/xorg/xresources"
export SESSION="$XDG_CONFIG_HOME/xorg/xsession"

# Zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Start Xorg
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR"  -eq 1 ]; then
   mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/.local/share/xorg"
   exec startx "$XINITRC" -keeptty > ~/.local/share/xorg/xorg.log 2>&1
fi

# Start and add the ssh-aget private key of github
#eval "$(ssh-agent -s)"
#ssh-add ~/.config/git/ssh/arch
#trap 'kill $SSH_AGENT_PID' EXIT

# Set up the SSH agent for key management.
#if eval `ssh-agent -s`; then
#    # Only want to add keys on an SSH client, not the server.
#    if [ "$HOSTNAME" == 'Z11' ]; then
#	[ -z "$SSH_TTY" ] && ssh-add "$HOME"/.ssh/rsa_{ss,sam,vm}
#    elif [ "$HOSTNAME" == 'Sam' ]; then
#	[ -z "$SSH_TTY" ] && ssh-add "$HOME/.ssh/rsa_gitsam"
#    fi
#    trap 'kill $SSH_AGENT_PID' EXIT
#fi

#{
#	# The RHEL recommended umask for much more safety when creating new files
#	# and directories. This is the equivalent of octal 700 and 600 for
#	# directories and files, respectively; drwx------ and -rw-------.
#	umask 0077
#
#	# I need this for when I use my configurations remotely, via SSH.
#	if [ -n "$SSH_TTY" ] && [ -f "$HOME/.bashrc" ]; then
#		. "$HOME/.bashrc"
#	fi
#
#	# Set up the SSH agent for key management.
#	if eval `ssh-agent -s`; then
#		# Only want to add keys on an SSH client, not the server.
#		if [ "$HOSTNAME" == 'Z11' ]; then
#			[ -z "$SSH_TTY" ] && ssh-add "$HOME"/.ssh/rsa_{ss,sam,vm}
#		elif [ "$HOSTNAME" == 'Sam' ]; then
#			[ -z "$SSH_TTY" ] && ssh-add "$HOME/.ssh/rsa_gitsam"
#		fi
#
#		trap 'kill $SSH_AGENT_PID' EXIT
#	fi
#
#	PATH+=":$HOME/bin"
#} &> /dev/null
