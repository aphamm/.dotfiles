# aphamm/.dotfiles

default:
    @just --list

# Run full machine bootstrap (brew, languages, symlinks, macOS prefs)
init:
    ./init.sh

# Sync Brewfile with installed packages (review + commit yourself)
save:
    brew bundle dump --describe --force --file=Brewfile
    @git status --short

# Update skill submodules to latest upstream
pull-external:
    git submodule update --init --remote

# Run unit tests (JS lib)
test:
    node --test tests/unit/*.js

# Auto-format JS/JSON with Biome (shell scripts unaffected)
format:
    pnpm dlx @biomejs/biome format --write .

# Lint: shell scripts + verify Biome formatting (no writes)
lint:
    shellcheck --severity=error *.sh init/*.sh
    pnpm dlx @biomejs/biome format .
