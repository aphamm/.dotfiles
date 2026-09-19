# Design It Twice

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout) — your first idea is unlikely to be the best.

Uses the vocabulary in [SKILL.md](SKILL.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
- A rough illustrative code sketch to ground the constraints — not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

### 2. Spawn one OMP task batch

Call `task` once with 3–4 independent items. The shared `context` MUST use `# Goal`, `# Constraints`, and `# Contract` headings and include the chosen candidate, relevant file paths, coupling details, dependency category from [DEEPENING.md](DEEPENING.md), what sits behind the seam, `CONTEXT.md` vocabulary, and [SKILL.md](SKILL.md) vocabulary.

Every item MUST omit `agent` so OMP uses the default `task` worker, use a distinct `name`, and provide a self-contained task under `# Target`, `# Change`, and `# Acceptance`. Siblings must not see each other's output. Give each item one different design constraint:

- `MinimalInterface`: minimise the interface — aim for 1–3 entry points and maximise leverage per entry point.
- `FlexibleInterface`: maximise flexibility across real use cases and extension needs.
- `CommonCallerInterface`: optimise for the most common caller and make the default case trivial.
- `PortsAndAdaptersInterface` when cross-seam dependencies justify it: design around ports and adapters.

Each task's acceptance criteria MUST require a radically different interface, consistent use of the shared architecture and domain vocabulary, and every output listed below.

Each sub-agent outputs:

1. Interface (types, methods, params — plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
5. Trade-offs — where leverage is high, where it's thin

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu.
