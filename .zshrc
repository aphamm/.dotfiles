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

# alias python='python3'
# alias pip='pip3'
alias act='source .venv/bin/activate'
alias pin='uv pip install'

uvinit() {

    if [ -z "$1" ]; then
        echo "Error: No Python <version> specified 😡"
        echo "Usage: uv_init <version>"
        return 1
    fi

    local version="$1"
    shift # remove version argument

    local ds_flag=false
    local ai_flag=false

    # Check for different flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --ds)
                ds_flag=true
                shift
                ;;
            --ai)
                ai_flag=true
                shift
                ;;
            *)
                echo "Error: Unknown flag '$1' 😡"
                echo "Usage: uv_init <version> [--ds] [--ai]"
                return 1
                ;;
        esac
    done

    # Verify if the specified Python version exists
    if ! uv python list | grep -q "/bin/python${version}" ; then
        echo "Error: Python version ${version} not installed 😕"
        echo "Install via: uv python install ${version}"
        echo "💁‍♂️ To see available and install Python versions use: uv python list"
        return 1
    fi

    uv venv .venv --python ${version}
    source .venv/bin/activate


    if $ds_flag; then
        uv pip install ipykernel -U --force-reinstall
        uv pip install pandas numpy matplotlib seaborn scikit-learn
        echo "Successfully installed Data Science packages 😊"
    fi

    if $ai_flag; then
      uv pip install torch
    fi

    echo "Successfully activated virtual environment 😊"
    return 0
}

. "$HOME/.local/bin/env"

clear
