alias python='python3'
alias pip='pip3'
alias act='source .venv/bin/activate'
alias pin='uv pip install'

eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
