# Performance diagnosis

Extends the **Perf branch** in Phase 4. Two disciplines: generate Phase 3 hypotheses from the strategy families; read captured artifacts by reaching a queryable shape first. (Ported from pstack's perf-issue and trace-forensics playbooks.)

## Strategy families as hypothesis generators

Most perf fixes come from eight families. Use them to generate the Phase 3 ranked hypotheses, never as a checklist: a family earns a hypothesis only when the measurement shows the signal it names, and a focused fix for the dominant cost beats applying all eight.

- **Elimination.** The cheapest work is work that doesn't run. Before optimizing the hot path, ask whether it needs to exist: a computation nobody consumes, a gate that's always off for this user, a sync that redundantly mirrors state, a legacy path kept "just in case". The trace shows what's slow, never that it's deletable — this family needs a code-and-spec reading pass, not the profiler. Deleting the work beats every other family when it applies.
- **Divide and conquer.** The dominant cost scales with input size. Split the work so each piece touches less (chunk, shard, prune the search space) or so independent pieces run in parallel.
- **Caching.** The same computation or fetch repeats on identical inputs. Store and reuse the result; name what invalidates it before claiming the win.
- **Indirection.** The hot path does expensive work a cheaper intermediate could absorb: an index instead of a scan, a queue that shifts work off the interactive thread, a handle that lets a cheaper implementation swap in. Add the hop only when it removes more from the critical path than it adds; a layer on the hot path that removes no work is pure cost.
- **Batching.** Many small operations each pay a fixed overhead (RPC, query, syscall, draw call). Coalesce them to pay the overhead once per batch.
- **Redundancy.** The wait hangs on one slow instance or attempt. Duplicate the work (replicas, hedged requests, speculative execution) and take the fastest result. Trades extra load for lower tail latency — the trace must show the wait dominates and the system has headroom.
- **Lazy evaluation.** Cost lands on results never used or not needed yet (eager init on the boot path, rendering offscreen items). Defer the work until first use.
- **Scheduling.** The work must happen, but not during the interactive moment. Move it to where nobody waits: idle callbacks, background warmup after boot, precompute before the user arrives, cleanup after the frame commits. Distinct from Lazy (later-when-needed): Scheduling often runs the work *earlier* than the hot moment, or in its shadow. The win is perceived latency — measure the interactive path, not total work done.

## Reach the queryable shape before you read

For a captured artifact — `.cpuprofile`, trace JSON, `.heapsnapshot`, spindump — the artifact is a fixed dataset: read it, don't re-run it.

1. Identify the format and load it with the right tool. Parse large artifacts in a subagent; keep only the reduced finding in the main thread.
2. Transform to a queryable shape: dump the trace or heap snapshot into SQLite, one row per sample, frame, or node. Never eyeball a 40 MB JSON.
3. Narrow to the cause: query for the frames holding the most time and walk the call tree to the hot path. For a leak, follow the retainer chain from the leaked object to a GC root. For a spindump, find the thread stuck on-CPU or blocked and its wait reason.
4. Attribute to source: map the hot frame to file, symbol, and line via the artifact's own symbols. A frame with no source mapping is not yet a diagnosis — resolve the symbols, or say plainly the artifact doesn't carry them.
5. Confirm against a paired before/after capture when one exists. Without one, the finding is the strongest hypothesis the artifact supports, not a confirmed cause.

## Comparable-artifact rule

Baseline and post-fix measurements must be the same kind of capture on the same surface. Anything else is `INCONCLUSIVE` — never rounded up to a pass. The finish line is three numbers: baseline, post-fix, delta, with artifact paths.
