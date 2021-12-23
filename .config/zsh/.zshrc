#!/bin/zsh
# Source
# [ -f "$XDG_CONFIG_HOME/zsh/.zshalias" ] && source "$XDG_CONFIG_HOME/zsh/.zshalias"
source "$ZDOTDIR/.zshalias" 
source "$ZDOTDIR/.zshprompt" 

# source "zsh-exports"
# source "zsh-vim-mode"
# source "zsh-aliases"
# source "zsh-prompt"

# Add custom funtions completion
fpath+="$ZDOTDIR/completion/"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
mkdir -p "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_CACHE_HOME/zsh/histfile"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Enable colors
autoload -Uz colors && colors

# Basic auto/tab completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
#zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

# Use case-insensitive and partial completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt no_list_ambiguous
zstyle ":completion:*:descriptions" format "%B%d%b"

# Expand Global Alias
globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches


# some useful options (man zshoptions)
setopt autocd  # Automatically cd into directories by just typing the directory name
setopt autopushd # Keep a directory stack of all the directories you cd to in a session
setopt pushdignoredups  # Use Git-like -N instead of the default +N
setopt autocd extendedglob nomatch menucomplete notify

setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
# unsetopt BEEP

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# FZF 
# TODO update for mac
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export FZF_DEFAULT_COMMAND='rg --hidden -l ""'

compinit

# Speedy keys
xset r rate 210 40

# For QT Themes
export QT_QPA_PLATFORMTHEME=qt5ct

eval "$(zoxide init zsh)"

# bindkey -s '^o' 'ranger^M'
# bindkey -s '^f' 'zi^M'
# bindkey -s '^s' 'ncdu^M'
# bindkey -s '^n' 'nvim $(fzf)^M'
# bindkey -s '^v' 'nvim\n'
# bindkey -s '^z' 'zi^M'
# bindkey '^[[P' delete-char
# bindkey "^p" up-line-or-beginning-search # Up
# bindkey "^n" down-line-or-beginning-search # Down
# bindkey "^k" up-line-or-beginning-search # Up
# bindkey "^j" down-line-or-beginning-search # Down
# bindkey -r "^u"
# bindkey -r "^d"

# zsh_add_plugin "zsh-users/zsh-autosuggestions"
# zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
# zsh_add_plugin "hlissner/zsh-autopair"
# zsh_add_completion "esc/conda-zsh-completion" false
