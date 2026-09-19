# Vendored skills

Skills adapted for omp are real directories here; unmodified skills stay symlinks into `../external/`.

## Adaptation rules

Apply these when vendoring a new skill or editing a vendored one:

- Mechanical ports: Claude Code / Cursor subagent spawning → omp `task` batches + `hub` messaging; slash-command refs → `skill://` URIs; drop `disable-model-invocation` when the skill should fire on its description.
- Skills state orchestration logic only — who runs, what each item owns, what comes back. Never restate wire formats: the `task`/`hub` tool schemas own the batch shape, the `# Goal/Constraints/Contract` and `# Target/Change/Acceptance` heading contracts, the agent roster, and "subagents start blank"; `harness/SYSTEM.md` owns the delegation doctrine. A restated format is a second source of truth that silently goes stale when the harness changes.
- To edit a skill that is still a symlink, materialize it first (remove the link, copy the upstream directory in), add its row to the table, and note the divergence under Adaptations.

To re-sync a vendored skill, 3-way diff: recorded base commit → current upstream vs the vendored copy.

| Skill | Upstream source | Base commit |
|---|---|---|
| code-review | mattpocock/skills `skills/engineering/code-review` | 0986eba |
| codebase-design | mattpocock/skills `skills/engineering/codebase-design` | 0986eba |
| diagnosing-bugs | mattpocock/skills `skills/engineering/diagnosing-bugs` | 0986eba |
| grill-with-docs | mattpocock/skills `skills/engineering/grill-with-docs` | 0986eba |
| grilling | mattpocock/skills `skills/productivity/grilling` | 0986eba |
| prototype | mattpocock/skills `skills/engineering/prototype` | 0986eba |
| implement | mattpocock/skills `skills/engineering/implement` | 0986eba |
| improve-codebase-architecture | mattpocock/skills `skills/engineering/improve-codebase-architecture` | 0986eba |
| setup-matt-pocock-skills | mattpocock/skills `skills/engineering/setup-matt-pocock-skills` | 0986eba |
| tdd | mattpocock/skills `skills/engineering/tdd` | 0986eba |
| to-spec | mattpocock/skills `skills/engineering/to-spec` | 0986eba |
| to-tickets | mattpocock/skills `skills/engineering/to-tickets` | 0986eba |
| triage | mattpocock/skills `skills/engineering/triage` | 0986eba |
| wayfinder | mattpocock/skills `skills/engineering/wayfinder` | 0986eba |
| dialectic | KyleAMathews/hegelian-dialectic-skill (repo root, minus `docs/`) | fc85fdf |
| technical-writing | cursor/plugins `pstack/skills/technical-writing` | 60c641e |
| unslop | cursor/plugins `pstack/skills/unslop` | 60c641e |

Full commits: mattpocock/skills `0986ebaf5d29e812162702b2633a2942c30200d2`; hegelian-dialectic-skill `fc85fdfb2a919defab609e697315c9e64abb25cd` (pre-field-lab; submodule HEAD deliberately newer); cursor/plugins `60c641e4fad674784b30abcf9f8915dea39df38d`.

Adaptations for the pstack pair: dropped `disable-model-invocation` and the `/technical-writing` slash trigger from technical-writing's frontmatter (omp skills fire on description), pointed its unslop references at `skill://unslop`. unslop is verbatim; it is a real directory (not a symlink) because technical-writing instructs agents to append new jargon offenders to its abstract-metaphor rule, which needs a locally editable file.

Adaptations for code-review and improve-codebase-architecture: cut task-batch wire-format restatement (heading templates, "subagents do not inherit the parent conversation") per the orchestration-only rule above; orchestration content unchanged.

Further code-review adaptation: step 5 gained a lead-judgement layer blended from pstack `interrogate` — within-axis buckets (Act on ≤5 / Consider / Noted / Dismissed-with-rationale); the no-cross-axis-reranking rule is unchanged.

codebase-design adaptation: blended from pstack `architect` — a usage-first principle bullet, and a new `RED-FLAGS.md` (ported from architect's `references/design-red-flags.md` at 60c641e, rewritten in the local glossary: seam not boundary, depth-as-leverage, deletion test).

diagnosing-bugs adaptation: new `PERF.md` blended from pstack poteto-mode playbooks `perf-issue.md` + `trace-forensics.md` at 60c641e (eight strategy families as Phase 3 hypothesis generators; SQLite-queryable-shape artifact reading; comparable-artifact rule), pointed at from the Phase 4 perf branch; Cursor plumbing (model roles, PR playbook, throughput checkpoints) dropped.

grilling + prototype adaptation (blended from pstack grilling/prototype fork classifier): grilling's fact-dispatch rule now routes empirically observable frontier questions to `skill://prototype` with the result reporting back as a settled prerequisite; prototype's description gained the "settle an empirical fork by observing it" trigger.
