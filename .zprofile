alias python='python3'
alias pip='pip3'
alias act='source .venv/bin/activate'
alias pin='uv pip install'

export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

eval "$(/opt/homebrew/bin/brew shellenv)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="/opt/homebrew/opt/python@3.12/libexec/bin:$PATH"

