# Change default zsh directory
export ZDOTDIR="$HOME/.config/zsh"

# Environment Variables
[ -f "$HOME/.config/envar" ] && source "$HOME/.config/envar"

# Remove Dot
[ -f "$HOME/.config/zsh/zshrc" ] && source ~/.config/zsh/zshrc
