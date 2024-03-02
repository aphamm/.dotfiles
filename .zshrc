# virtual environment based on Homebrew-installed python3
export VIRTUALENVWRAPPER_PYTHON=/opt/homebrew/bin/python3

# creates symlinks to Home-brew python interpreter and copies pip binary
# packages installed in ~/.virtualenv/venv/lib/python3.12/site-packages
source virtualenvwrapper.sh
export WORKON_HOME=~/.virtualenvs
export PROJECT_HOME=~/Documents
alias mkve='mkvirtualenv'
alias mkpr='mkproject'
alias rmve='rmvirtualenv'
alias lsve='lsvirtualenv'

alias python='python3'
alias pip='pip3'