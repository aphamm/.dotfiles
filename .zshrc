# Runs every time a new interactive shell starts

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.starship.toml

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias python='python3'
alias pip='pip3'
alias act='source .venv/bin/activate'
alias pin='uv pip install'

uv_init() {
    
    if [ -z "$1" ]; then
        echo "Error: No Python <version> specified 😡"
        echo "Usage: uv_init <version>"
        return 1
    fi
    
    local version="$1"
    
    # Verify if the specified Python version exists
    if ! uv python list | grep -q "/bin/python${version}" ; then
        echo "Error: Python version ${version} not installed 😕"
        echo "Install via: uv python install ${version}"
        echo "💁‍♂️ To see available and install Python versions use: uv python list"
        return 1
    fi
    
    echo "Successfully making virutal environment 😊"
    uv venv .venv --python ${version}
    source .venv/bin/activate
    uv pip install ipykernel -U --force-reinstall
    uv pip install pandas numpy matplotlib seaborn scikit-learn 
    return 0
}

clear