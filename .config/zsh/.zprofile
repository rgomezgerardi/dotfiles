# Change default zsh directory
export ZDOTDIR="$HOME/.config/zsh"

# Start Window Manager
[ -z "$DISPLAY" ] && [ "$XDG_VTNR"  -eq 1 ] && exec startx

# Start and add the ssh-aget private key of github
eval "$(ssh-agent -s)"
ssh-add ~/.config/git/ssh/arch
trap 'kill $SSH_AGENT_PID' EXIT
