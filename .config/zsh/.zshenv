# Change default zsh directory
export ZDOTDIR="$HOME/.config/zsh"

# Environment Variables
[ -f "$HOME/.config/envars" ] && source "$HOME/.config/envars"

# Remove Dot
[ -f "$HOME/.config/zsh/zshrc" ] && source ~/.config/zsh/zshrc
