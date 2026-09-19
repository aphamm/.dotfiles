#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
failed=0
vendored=()
while IFS= read -r skill; do
    vendored+=("$skill")
    path="agents/skills/$skill"
    if [ ! -d "$path" ] || [ -L "$path" ] || [ ! -f "$path/SKILL.md" ]; then
        echo "Invalid vendored skill: $skill" >&2
        failed=1
    fi
done < <(awk -F'|' '/^\| [a-z0-9][a-z0-9-]* \|/ { skill=$2; gsub(/^[ \t]+|[ \t]+$/, "", skill); print skill }' agents/skills/VENDORED.md)
for path in agents/skills/*; do
    name="$(basename "$path")"
    [ "$name" = "VENDORED.md" ] && continue
    if [ ! -f "$path/SKILL.md" ]; then
        echo "Skill does not resolve to SKILL.md: $name" >&2
        failed=1
    fi
    if [ -d "$path" ] && [ ! -L "$path" ]; then
        found=0
        for skill in "${vendored[@]}"; do
            [ "$name" = "$skill" ] && found=1
        done
        if [ "$found" -ne 1 ]; then
            echo "Unrecorded vendored skill: $name" >&2
            failed=1
        fi
    fi
done
for path in agents/external/hegelian-dialectic-skill agents/external/mattpocock-skills agents/external/cursor-plugins; do
    if ! git -C "$path" rev-parse --git-dir >/dev/null 2>&1; then
        echo "Uninitialized submodule: $path" >&2
        failed=1
        continue
    fi
    if [ -n "$(git -C "$path" status --porcelain --untracked-files=normal)" ]; then
        echo "Dirty submodule: $path" >&2
        failed=1
    fi
    case "$(git -C "$path" stash list)" in
        *"omp: before external skill update"*)
            echo "Stale adaptation stash in: $path" >&2
            failed=1
            ;;
    esac
done
exit "$failed"
