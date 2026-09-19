# SYSTEM.md maintenance notes

`SYSTEM.md` replaces omp's default instruction template (see `omp://system-prompt-customization.md`). Symlinked from `~/.omp/agent/SYSTEM.md`; applies to every project and every subagent.

Still rendered automatically — never restate in SYSTEM.md:

- context files (AGENTS.md), discovered skills list, always-apply rules, secret-redaction guidance
- the project/environment footer (workstation info, final completion block)
- all regular tool schemas (read selectors, edit hashline language, task, hub, todo, eval, …) — they ride as function definitions

Must be carried by SYSTEM.md because the default template owns them:

- role/tone, tool-routing policy, delegation/workflow/delivery rules
- the `xd://` device protocol (browser, github, lsp, ast_edit have no function schemas; without prompt text the model cannot discover them). Enabling a new device (e.g. `debug.enabled: true`, `computer.enabled: true`) requires adding its bullet here.

Escape hatches the file leans on: invalid `xd://` args return the device schema in the error; `omp://tools/<name>.md` serves full device docs on demand.

Smoke test after edits:
`cd /tmp && omp -p --model openai-codex/gpt-5.6-luna "Quote the first five words of your '# Role' section and list your xd:// devices."`

Diff against upstream default occasionally: the bundled template lives at `packages/coding-agent/src/prompts/system/system-prompt.md` in the omp repo; release notes flag prompt changes.
