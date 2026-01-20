# Runs every time a new interactive shell starts
# Source zsh plugins if Homebrew is installed and plugins exist
if [ -n "$HOMEBREW_PREFIX" ]; then
    [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias python='python3'
alias pip='pip3'
alias c='claude'

# Load Starship prompt if installed
[ -f "$(which starship 2>/dev/null)" ] && eval "$(starship init zsh)"

# Source uv env if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
