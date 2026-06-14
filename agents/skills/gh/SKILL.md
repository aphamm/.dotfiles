---
name: gh
description: Use GitHub CLI to explore repos, read source code, search code, and interact with issues/PRs
argument-hint: <command> [args]
---

# GitHub CLI (`gh`)

Use the `gh` CLI to interact with GitHub repositories — read source files, search code, browse repo structure, manage issues/PRs, and more.

## When to Use

- Reading source code from remote repos (don't clone, use the API)
- Searching code across GitHub (faster than cloning + grepping)
- Browsing repository file trees and directory structures
- Viewing issues, PRs, discussions, releases
- Creating/commenting on issues and PRs
- Checking CI/CD status and workflow runs

## Basic Usage

# GitHub CLI reference

You can view all of the GitHub CLI commands in your terminal. The same information is available in the GitHub CLI manual.

To view all top-level GitHub CLI commands, enter `gh` without arguments.

```shell
gh
```

To list all of the subcommands that you can use with a GitHub CLI command, use the top-level command without arguments.

```shell
gh COMMAND
```

For example, to view the environment variables that you can set to affect certain aspects of GitHub CLI, use the `environment` command.

```shell
gh environment
```

To view the configuration settings that you can set, use the `config` command.

```shell
gh config
```

To view help for a particular subcommand, use the `--help` flag.

```shell
gh COMMAND [SUBCOMMAND ...] --help
```

All of the information that's available by running these commands in the terminal is also included in the [GitHub CLI online manual](https://cli.github.com/manual/gh).

## Core Commands

### Read a file from a repo

```bash
# Read a specific file (returns raw content)
gh api repos/{owner}/{repo}/contents/{path} --jq '.content' | base64 -d

# Read from a specific branch/ref
gh api repos/{owner}/{repo}/contents/{path}?ref={branch} --jq '.content' | base64 -d
```

### Browse repo structure

```bash
# List files in a directory
gh api repos/{owner}/{repo}/contents/{path} --jq '.[].name'

# List with type info (file vs dir)
gh api repos/{owner}/{repo}/contents/{path} --jq '.[] | "\(.type)\t\(.name)"'

# List root directory
gh api repos/{owner}/{repo}/contents/ --jq '.[] | "\(.type)\t\(.name)"'
```

### Search code on GitHub

```bash
# Search for code across all of GitHub
gh search code "query" --limit 20

# Search within a specific repo
gh search code "query" --repo {owner}/{repo} --limit 20

# Search with language filter
gh search code "query" --repo {owner}/{repo} --language python --limit 20
```

### Get repo info

```bash
# Repo overview (description, stars, language, topics)
gh repo view {owner}/{repo}

# Just the README
gh repo view {owner}/{repo} --json readme --jq '.readme'
```

### Git tree (for large directory listings)

```bash
# Get full file tree of a repo (recursive)
gh api repos/{owner}/{repo}/git/trees/{branch}?recursive=1 --jq '.tree[] | select(.type=="blob") | .path'

# Filter tree to a subdirectory
gh api repos/{owner}/{repo}/git/trees/{branch}?recursive=1 --jq '.tree[] | select(.type=="blob") | select(.path | startswith("{dir}/")) | .path'
```

### Issues and PRs

```bash
# List open issues
gh issue list --repo {owner}/{repo}

# View a specific issue
gh issue view {number} --repo {owner}/{repo}

# List open PRs
gh pr list --repo {owner}/{repo}

# View a specific PR (with diff)
gh pr view {number} --repo {owner}/{repo}
gh pr diff {number} --repo {owner}/{repo}
```

### Releases and tags

```bash
# List releases
gh release list --repo {owner}/{repo}

# View latest release
gh release view --repo {owner}/{repo}
```

### Workflow runs (CI/CD)

```bash
# List recent workflow runs
gh run list --repo {owner}/{repo}

# View a specific run
gh run view {run_id} --repo {owner}/{repo}
```

## Patterns for Code Exploration

When exploring an unfamiliar repo, follow this order:

1. **Get the lay of the land** — list root directory and read README
2. **Find relevant files** — use `gh search code` or tree listing with grep
3. **Read key files** — fetch raw content via the contents API
4. **Trace dependencies** — follow imports to understand the call graph

### Example: Explore how a library implements a feature

```bash
# 1. Repo overview
gh repo view pytorch/ao

# 2. Find relevant files
gh search code "float8" --repo pytorch/ao --language python --limit 30

# 3. List a specific directory
gh api repos/pytorch/ao/contents/torchao/float8 --jq '.[].name'

# 4. Read a specific file
gh api repos/pytorch/ao/contents/torchao/float8/float8_linear.py --jq '.content' | base64 -d
```

## Tips

- **Rate limits**: GitHub API has rate limits (~5000 req/hr authenticated). Use `--jq` to filter responses server-side.
- **Large files**: The contents API fails for files >1MB. Use the git blobs API instead:
  ```bash
  # Get the SHA first from the tree, then fetch the blob
  gh api repos/{owner}/{repo}/git/blobs/{sha} --jq '.content' | base64 -d
  ```
- **Pagination**: For endpoints returning lists, use `--paginate` to get all results.
- **JSON output**: Add `--json field1,field2` to most `gh` commands for structured output.
- **Prefer `gh api`** over `gh repo clone` when you only need to read a few files — it's faster and doesn't pollute the local filesystem.
