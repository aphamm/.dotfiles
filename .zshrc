# Runs every time a new interactive shell starts
if [ -n "$HOMEBREW_PREFIX" ]; then
    [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

alias c='claude'

# Load Starship prompt if installed
command -v starship &>/dev/null && eval "$(starship init zsh)"

# Source uv env if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Source Rust/Cargo env if it exists
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

clear
