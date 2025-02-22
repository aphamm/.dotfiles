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
    
    # verify if the specified Python version exists
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

export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

eval "$(/opt/homebrew/bin/brew shellenv)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
