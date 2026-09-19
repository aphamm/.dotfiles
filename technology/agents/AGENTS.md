# AGENTS.md

## Alignment

- Interview me about unresolved intent, product decisions, and tradeoffs until our shared understanding is unambiguous; resolve every factual question yourself first.
- Agree on *what* before deciding *how*; surface disagreement and unstated assumptions.

## Principles

- Simplest implementation that fully meets current requirements, architected for the long term — no stopgaps meant to be replaced. An accepted shortcut is marked `YAGNI:`, naming the ceiling and upgrade path.
- Stop at the first rung that holds: don't build it → stdlib → platform feature → installed dependency → one line → minimum code that works.
- Grow in layers: walking skeleton first, each capability added onto a working product — never traded for unfinished complexity.
- Keep data and behavior separate: plain structs and arrays operated on by functions. Data-oriented layout — indexes over pointers, struct-of-arrays. Closed variant set → explicit tag; polymorphism only for extensibility.
- Prefer deep modules: small interfaces, complexity and invariants hidden inside. Immutable data by default; mutable buffers in measured hot paths.

## Documentation

- Turn shared understanding into a domain model before coding. One word per concept, everywhere; no synonyms unless the distinction is real.
- Persisted text (docs, comments) is unsummarizable: each idea once, in one place, shortest encoding.

## Tooling

- Library/API docs: `read "https://context7.com/<github-owner>/<github-repo>/llms.txt?tokens=10000"`
- Repo architecture: `read "https://deepwiki.com/<github-owner>/<github-repo>"`
- YouTube transcripts: `yt-dlp --write-auto-sub --sub-lang en --skip-download --sub-format vtt -o - "<url>"`
- X/Twitter read-only: `twitter -c feed|search|user-posts|tweet`. On `not_authenticated`/`401`/`403`: run `~/Documents/.dotfiles/technology/bin/x-cookies-to-keychain` once, retry. Never post/like/follow/retweet.
- Python: `uv`/`uvx`. TypeScript: `pnpm`/`pnpm dlx`.
