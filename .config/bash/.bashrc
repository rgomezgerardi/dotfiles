# =========================================================
#
#           ██████╗  █████╗ ███████╗██╗  ██╗
#           ██╔══██╗██╔══██╗██╔════╝██║  ██║
#           ██████╔╝███████║███████╗███████║
#           ██╔══██╗██╔══██║╚════██║██╔══██║
#           ██████╔╝██║  ██║███████║██║  ██║
#           ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#   Config File                    Edit By: Ricardo Gomez
# =========================================================

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available
if [ -r /usr/share/bash-completion/bash_completion ]; then 
	. /usr/share/bash-completion/bash_completion
else
	complete -cf sudo
fi

# Set vim as manpager
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist noma' -\""

# Enable vi mode in bash
set -o vi

# Don't put duplicate lines or lines starting with space in the history.
#HISTCONTROL=ignoreboth

# Ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### SHOPT
#shopt -s autocd # change to named directory
#shopt -s cdspell # autocorrects cd misspellings
#shopt -s cmdhist # save multi-line commands in history as single line
#shopt -s dotglob
#shopt -s histappend # do not overwrite history
#shopt -s expand_aliases # expand aliases
#shopt -s checkwinsize # checks term size when bash regains control

# Set the prompt theme
[ -f "$HOME/.local/share/bash/fancy-bash-promt.theme" ] && source "$HOME/.local/share/bash/fancy-bash-promt.theme"

# Load variables, aliases if existent.
[ -f "$HOME/.config/variables" ] && source "$HOME/.config/variables"
[ -f "$HOME/.config/alias" ] && source "$HOME/.config/alias"
