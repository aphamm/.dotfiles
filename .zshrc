export HOMEBREW_NO_ENV_HINTS=1

# Runs every time a new interactive shell starts
if [ -n "$HOMEBREW_PREFIX" ]; then
    [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

alias gl='git log --oneline --graph --decorate'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gsw='git switch'
alias ga='git add'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias grs='git reset'
alias gcp='git cherry-pick'

c() {
  claude --dangerously-skip-permissions --enable-auto-mode --resume "$@"
}

cn() {
  if [ -z "$1" ]; then
    echo "Usage: cn <session-name> [args...]"
    return 1
  fi
  local name="$1"; shift
  claude --dangerously-skip-permissions --enable-auto-mode --name "$name" "$@"
}

# Source uv env if it exists
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Source Rust/Cargo env if it exists
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# twitter-cli credentials — read from macOS Keychain, never stored in repo
export TWITTER_AUTH_TOKEN="$(security find-generic-password -a "$USER" -s twitter_auth_token -w 2>/dev/null)"
export TWITTER_CT0="$(security find-generic-password -a "$USER" -s twitter_ct0 -w 2>/dev/null)"

# Preferred editor for external-editor actions
export VISUAL="code"
export EDITOR="code"

# nvm — lazy-loaded so it doesn't slow every shell start.
# First call to any of these sources nvm, then runs the real command.
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx pnpm corepack
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
for _cmd in nvm node npm npx pnpm corepack; do
  eval "${_cmd}() { _load_nvm; ${_cmd} \"\$@\"; }"
done
unset _cmd

cdd() { cd ~/Documents/"$1"; }
alias j="just"
alias ur="uv run"
alias px="pnpm dlx"
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lAhF"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

clear
