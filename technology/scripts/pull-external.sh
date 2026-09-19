#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
submodules=(
    agents/external/hegelian-dialectic-skill
    agents/external/mattpocock-skills
    agents/external/cursor-plugins
)
before=()
for path in "${submodules[@]}"; do
    if ! git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
        git -C .. submodule update --init "technology/$path"
    fi
    if [ -n "$(git -C "$path" status --porcelain --untracked-files=normal)" ]; then
        echo "Refusing to update dirty submodule: $path" >&2
        exit 1
    fi
    before+=("$(git -C "$path" rev-parse HEAD)")
done
git -C .. submodule update --init --remote
for index in "${!submodules[@]}"; do
    path="${submodules[$index]}"
    old="${before[$index]}"
    new="$(git -C "$path" rev-parse HEAD)"
    printf '\n%s: %s -> %s\n' "$path" "${old:0:7}" "${new:0:7}"
    if [ "$old" != "$new" ]; then
        git -C "$path" log --oneline --no-decorate "$old..$new"
    else
        echo "  unchanged"
    fi
done
printf '\nVendored skills were not modified. Recorded bases:\n'
awk -F'|' '/^\| [a-z0-9][a-z0-9-]* \|/ { skill=$2; base=$4; gsub(/^[ \t]+|[ \t]+$/, "", skill); gsub(/^[ \t]+|[ \t]+$/, "", base); printf "  %s @ %s\n", skill, base }' agents/skills/VENDORED.md
bash scripts/check-skills.sh
