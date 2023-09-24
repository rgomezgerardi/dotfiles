#!/bin/zsh
source "$ZDOTDIR/.zshalias"

[[ -d "$XDG_CACHE_HOME/zsh"  ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

setopt APPEND_HISTORY
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt HIST_BEEP              # Beep when accessing non-existent history.
setopt SHARE_HISTORY

export ZCACHEDIR="$XDG_CACHE_HOME/zsh"
export HISTFILE="$ZCACHEDIR/histfile"
export HISTSIZE=10000
export SAVEHIST=10000

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Folder
_zcompdump="$XDG_CACHE_HOME/zsh/compdump"
_zcompcache="$XDG_CACHE_HOME/zsh/compcache"

# Options
setopt correct
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Styles
# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$_zcompcache"

# zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
# Use case-insensitive and partial completion
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# setopt no_list_ambiguous
# zstyle ":completion:*:descriptions" format "%B%d%b"

zstyle ':completion:*' rehash true # Persistent Rehash


# Init
# Initialize completion styles. Users can set their preferred completion style by
# calling `compstyle <compstyle>` in their .zshrc, or by defining their own
# `compstyle_<name>_setup` functions similar to the zsh prompt system.
fpath+="${0:A:h}/functions"
#autoload -Uz compstyleinit && compstyleinit

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_files=($_zcompdump(Nmh-20))
if (( $#_comp_files )); then
  compinit -i -C -d "$_zcompdump"
else
  compinit -i -d "$_zcompdump"
  # Keep $_zcompdump younger than cache time even if it isn't regenerated.
  touch "$_zcompdump"
fi
# zmodload zsh/complist
# _comp_options+=(globdots)		# Include hidden files.

# Cleanup
unset _comp_files _zcompdump _zcompcache

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zsh/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
source "$ZDOTDIR/.zplugin"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
