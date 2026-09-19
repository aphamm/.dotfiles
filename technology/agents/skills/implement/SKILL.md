---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Read and follow `skill://tdd` where possible, at pre-agreed seams.

Use the omp verification contract for the kind of change being made. Run focused typechecking and tests while implementing when they cover the changed contract. Run the full suite once at the end only when the change's scope, risk, or project convention warrants it.

When this skill runs inside an omp task batch, the task worker follows the batch's validation constraint; the parent orchestrator owns integrated validation after the wave completes.

Once implementation is complete:

1. Run the relevant verification.
2. Read and follow `skill://code-review`.
3. Resolve valid review findings.
4. Repeat affected verification and re-review changed areas.
5. Commit the verified work to the current branch, including only changes that belong to this task.

Never push, force-push, publish a branch, or otherwise modify remote state without the user's explicit permission.
