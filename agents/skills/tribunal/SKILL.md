---
name: tribunal
description: "Adversarial tribunal that exploits agent sycophancy for high-fidelity analysis. Three agents — a maximalist finder, an adversarial challenger, and a referee — compete under asymmetric scoring incentives to produce a verified list of findings. The finder's eagerness produces recall, the challenger's eagerness produces precision, and the referee's caution produces calibration. Use this whenever the user wants to find bugs, review code, audit security, critique a proposal, identify risks, validate claims, stress-test a document, or generally needs exhaustive-then-verified analysis of anything. Also trigger when the user says 'tribunal', 'find all the issues', 'what's wrong with this', 'audit this', 'tear this apart', or 'be brutal'."
---

# Tribunal

An **adversarial verification system** that weaponizes agent sycophancy to produce high-fidelity analysis.

Three agents compete under asymmetric scoring incentives. The Finder's eagerness to score points produces exhaustive recall. The Challenger's fear of penalties produces precise pruning. The Referee's belief that ground truth exists produces calibrated judgment. Each agent's sycophancy is load-bearing — remove it and the system collapses.

## Core Concepts (Read This First)

Three principles drive the tribunal's architecture. Internalize them before executing — they determine how you adapt the process, not just why it works.

**Sycophancy as structural material.** LLM agents want to please. Most multi-agent designs fight this tendency — they add "be critical" instructions that produce performative skepticism. The tribunal does the opposite: it *channels* eagerness in three opposing directions, so each agent's desire to score points produces exactly the epistemic virtue needed. The Finder pleases by finding more. The Challenger pleases by disproving more. The Referee pleases by being more accurate. The same underlying drive — sycophantic eagerness — produces recall, precision, and calibration when the incentive gradients point in different directions. Fighting sycophancy is a design smell. Harnessing it is the point.

**Asymmetric penalties are the load-bearing wall.** The Challenger loses 2x for wrongly dismissing a real finding. This single asymmetry prevents the entire system from collapsing into over-pruning. Without it, the Challenger's eagerness to score points (by disproving findings) would produce reckless dismissal — the same sycophancy that makes the Finder exhaustive would make the Challenger destructive. The 2x penalty transforms "disprove everything" into "disprove carefully" — the Challenger *wants* to disprove but *fears* being wrong. This tension between desire and caution is the system's core mechanism. If you modify the scoring, preserve this asymmetry or the system fails.

**The ground truth lie.** The Referee is told that correct answers already exist and its judgment will be compared against them. This is false — but the Referee doesn't know that. The lie prevents two failure modes: (1) rubber-stamping everything as confirmed (lazy agreement), and (2) dismissing everything the Challenger disputed (lazy deference to the most recent argument). The Referee believes wrong answers are *detectable,* which forces genuine deliberation on each finding. This is structurally parallel to the Electric Monks' full conviction in the dialectic — both exploit a specific belief to produce a specific epistemic behavior. The monk believes its position to free the user from belief weight; the Referee believes ground truth exists to force calibration.

## Why This Works

The tribunal is an **ensemble diversity machine.** Wood et al. (JMLR 2023) formalize why: in the bias-variance-diversity decomposition, diversity is literally subtracted from ensemble error (`E[loss] = noise + avg_bias + avg_variance − diversity`). Three agents with identical prompts produce correlated errors and zero diversity benefit. Three agents with opposing incentive structures produce maximally decorrelated outputs. The tribunal's architecture doesn't just add more agents — it engineers *structural disagreement.*

The three agents map to three epistemic virtues that are naturally in tension:

| Agent | Virtue | Mechanism | What sycophancy produces |
|-------|--------|-----------|-------------------------|
| **Finder** | Recall (completeness) | Rewarded per finding, scaled by severity | Exhaustive search — even low-confidence issues get reported because partial credit beats a miss |
| **Challenger** | Precision (accuracy) | Rewarded for disproof, 2x penalty for wrong dismissal | Aggressive but cautious pruning — the asymmetric penalty creates a fear/desire tension |
| **Referee** | Calibration (judgment) | Believes ground truth exists, scored ±1 per judgment | Careful binary verdicts — can't game the system because it believes errors are detectable |

No single agent can hold all three virtues simultaneously. Recall requires lowering thresholds (report everything). Precision requires raising thresholds (only report real issues). Calibration requires binary commitment without bias toward either. The tribunal resolves this by assigning one virtue per agent and letting the sequential pipeline produce all three.

## When to Use

- Bug finding, code review, security audit
- Critiquing a research proposal, paper, or design doc
- Risk analysis, due diligence, claim verification
- Identifying logical flaws, unstated assumptions, or gaps
- Any task where you need exhaustive identification followed by rigorous verification

Do NOT use when:
- The target is too large and unbounded — scope first, tribunal second
- You need *understanding* rather than *findings* — use the dialectic instead
- The question is "which approach is better?" rather than "what's wrong with this approach?"

## How It Works

### Step 1: Scope the Target

Read the user's request and identify:
- **Target**: what is being analyzed (code, proposal, document, system, claim)
- **Domain**: what kind of findings to look for (bugs, security issues, logical flaws, risks, weak claims)
- **Severity vocabulary**: map the generic scoring to domain-appropriate language (see Domain Adaptation below)

Gather whatever context is needed — read the files, understand the codebase, study the document. The three agents need a clear, self-contained brief of what they're analyzing and what they're looking for. Write this brief so each agent gets identical context.

**Scoping is critical.** For very large targets (full codebase, 50-page document), narrow the Finder to specific areas, aspects, or risk categories. The tribunal works best on focused, bounded targets. A Finder told to "find everything wrong with this entire codebase" will produce noise. A Finder told to "find every issue in the authentication flow across these 4 files" will produce signal.

### Step 2: The Finder

Launch a subagent with premortem framing and scoring incentives.

**Why premortem?** Gary Klein's research shows that imagining a future failure *has already occurred* increases identification of failure causes by ~30%, compared to asking "what could go wrong?" The temporal reframing breaks selective accessibility — the cognitive tendency to search only for the most available concern, then stop. Asking "what caused the failure?" triggers a search for *all* contributing factors, because the failure is already established and must be fully explained. Scoring incentives motivate *quantity*; premortem reframes the *search strategy.* They're complementary.

```
You are a [domain] analyst performing a premortem. Imagine that the following [target type] has already failed — catastrophically, in production, with consequences. Your job is to determine every possible cause of that failure by examining the [target type] for [finding type].

You are scored as follows:
- Finding that contributed to the failure but was minor: +1 point
- Finding that was a significant contributing factor: +5 points
- Finding that was a root cause of the catastrophic failure: +10 points

Your goal is to maximize your score. Be exhaustive — trace every assumption, every edge case, every interaction. Even if you're only 30% sure something contributed to the failure, report it. Partial credit beats a miss, and a +1 for a minor issue costs you nothing while a missed +10 is irreversible.

If multiple findings share a root cause, report the root cause as a critical finding and the individual manifestations as supporting evidence. Trace symptoms to their source — a missing validation layer that causes null propagation in 5 locations is one critical finding, not five low findings.

For each finding, report:
- ID (sequential number)
- Severity: low (+1) / medium (+5) / critical (+10)
- Location (file path, line number, section — whatever applies)
- Description: what the issue is
- Impact: what goes wrong — be specific about the failure mode
- Confidence: how sure you are (low / medium / high)

[INSERT CONTEXT BRIEF]
```

### Step 3: The Challenger

Once the Finder completes, launch a subagent with the Finder's full output.

**Why defeat classification?** John Pollock distinguishes two types of defeaters: **undercutting** (the inferential link is broken — the evidence doesn't support the conclusion) and **rebutting** (counter-evidence directly contradicts the finding). Undercutting is more structurally revealing — it identifies *how* reasoning fails, not just *that* it fails. When the Challenger classifies its disproofs, the Referee gets richer input: an undercut finding might be real but poorly argued (re-examine with different reasoning), while a rebutted finding is likely genuinely false. This classification costs nothing and sharpens the Referee's judgment.

```
You are an adversarial analyst. A colleague has produced the following list of alleged [finding type] in [target type]. Your job is to disprove as many as possible.

You are scored as follows:
- For each finding you correctly disprove: you receive that finding's severity score (+1 / +5 / +10)
- For each finding you wrongly disprove (it was actually real): you LOSE double that score (-2 / -10 / -20)

Your goal is to maximize your score. Be aggressive — but wrong dismissals hurt you twice as much as correct dismissals help. When you're uncertain, it's safer to let it stand.

For each finding you challenge, classify your disproof:
- **Undercut**: the evidence or reasoning doesn't support the conclusion (explain why the inferential link is broken — e.g., "this function IS called with null, but the null check on line 47 handles it")
- **Rebut**: counter-evidence directly contradicts the finding (cite the specific evidence — e.g., "the Finder claims this API is unauthenticated, but the middleware at line 23 requires a valid JWT")

For each finding, respond with:
- Finding ID (matching the original)
- Verdict: DISPROVE or STANDS
- If DISPROVE: defeat type (undercut / rebut) and your specific reasoning
- If STANDS: brief note on why you couldn't disprove it (optional)

[INSERT CONTEXT BRIEF]
[INSERT FINDER'S FULL OUTPUT]
```

### Step 4: The Referee

Once the Challenger completes, launch a subagent with both outputs.

The Referee performs two functions: **individual judgment** (is each finding valid?) and **pattern synthesis** (what do the confirmed findings reveal as a set?). The individual judgments are the tribunal's bread and butter. The pattern synthesis is its highest-value output per token — a ranked list of bugs is useful; identifying that "your error handling is systematically missing at service boundaries" is transformative.

```
You are an independent referee. Two analysts have examined [target type] for [finding type]. One found issues, the other tried to disprove them. You have access to both their arguments.

Important: the correct ground truth for every finding already exists and your judgment will be compared against it. You are scored:
- Correct judgment: +1 point
- Incorrect judgment: -1 point

For each disputed finding (where the Challenger said DISPROVE), you must decide: is the original finding valid, or is the Challenger's disproof correct?

Pay attention to the Challenger's defeat classification:
- **Undercut** disproofs claim the reasoning is flawed — but the underlying concern might still be real under different reasoning. Consider whether the finding should be confirmed with revised justification.
- **Rebut** disproofs claim counter-evidence exists — verify the counter-evidence is actually correct and relevant.

For each finding, provide:
- Finding ID
- Final verdict: CONFIRMED or DISMISSED
- Severity (you may adjust from the Finder's original if warranted): low / medium / critical
- Reasoning: 2-3 sentences explaining your judgment, referencing specific arguments from both sides
- If CONFIRMED: a concise, actionable description of the issue

For findings the Challenger did not dispute (STANDS), carry them forward as CONFIRMED with the Finder's original severity.

After judging all individual findings, analyze the confirmed findings as a set:
- Do any share a root cause? Name it.
- Do the findings reveal a systemic pattern — a shared assumption, a recurring design flaw, a category of oversight?
- What is the single deepest concern — the one issue that, if you could only fix one thing, you'd fix first and why?

[INSERT CONTEXT BRIEF]
[INSERT FINDER'S OUTPUT]
[INSERT CHALLENGER'S OUTPUT]
```

### Step 5: Compile the Final Report

Collect the Referee's output. Present a clean report to the user:

```markdown
## Tribunal Results: [Target]

**Summary**: X findings confirmed out of Y surfaced. Z dismissed after adversarial challenge.

**Systemic pattern** (if identified): [The structural insight behind the individual findings — the shared root cause, the recurring design flaw, the category of oversight that produces these specific symptoms]

**Deepest concern**: [The single most important issue, in one sentence — what to fix first and why]

### Critical
1. **[Location]**: [Description] — [Impact]

### Medium
2. **[Location]**: [Description] — [Impact]

### Low
3. **[Location]**: [Description] — [Impact]

### Dismissed (for reference)
- ~~Finding N~~ ([undercut/rebut]): [Why it was dismissed]
```

Include the dismissed findings at the bottom — the user may want to sanity-check the dismissals. The defeat type classification (undercut vs. rebut) helps the user assess whether a dismissal was legitimate: undercut dismissals are worth a second look (the concern might be real, just poorly argued), while rebutted dismissals with cited counter-evidence are more definitive.

## Domain Adaptation

The tribunal structure is universal but the vocabulary of severity, the Finder's search strategy, and the report format adapt by domain:

| Domain | Finding Vocabulary | Severity Calibration | Finder Strategy | Report Emphasis |
|--------|-------------------|---------------------|-----------------|----------------|
| **Code / Bugs** | bugs, defects, edge cases | Critical = data loss, crash, security breach. Medium = incorrect behavior. Low = style, minor inefficiency | Trace control flow, check edge cases, verify error handling | Location-precise, with fix suggestions |
| **Security** | vulnerabilities, attack vectors, exposures | Critical = RCE, data exfiltration, auth bypass. Medium = privilege escalation, info disclosure. Low = hardening opportunities | Think like an attacker — what's exploitable? Chain findings into attack paths | Attack narratives, not just individual vulns |
| **Research / Proposals** | weaknesses, gaps, unstated assumptions, flawed reasoning | Critical = invalidates the thesis. Medium = weakens a key argument. Low = minor gap, missing citation | Challenge every claim's evidence, check methodology, find unstated assumptions | Distinguish fatal flaws from improvement opportunities |
| **Design / Architecture** | failure modes, scaling limits, coupling risks | Critical = system-level failure. Medium = degraded performance, operational pain. Low = technical debt | Stress-test under load, failure, and change — what breaks when requirements shift? | Failure scenarios with trigger conditions |
| **Claims / Due Diligence** | inaccuracies, exaggerations, unsupported assertions, omissions | Critical = materially false. Medium = misleading. Low = imprecise | Verify every factual claim, check for cherry-picking, find what's *not* said | Evidence quality assessment per claim |

## Failure Modes

**Over-pruning (Challenger too aggressive).** The Challenger dismisses real findings because the scoring asymmetry isn't strong enough or the prompt doesn't emphasize the penalty. *Fix:* reinforce the 2x penalty language in the prompt. If persistent, increase to 3x.

**Finder noise flood.** The Finder produces 40+ findings, most low-confidence, burying real issues in volume. *Fix:* scope the target more tightly before starting. Add "trace symptoms to root causes" to reduce finding count while increasing finding quality. The tribunal works best on bounded targets.

**Referee rubber-stamping.** The Referee confirms everything, doing minimal analysis. The ground truth lie has failed. *Fix:* add specificity — "your judgment will be compared against expert analysis that has already been completed on this exact target. Errors in your judgment will be flagged and scored."

**Correlated blind spots.** All three agents share the same blind spot — typically a domain assumption none of them question. *Fix:* for high-stakes targets, add a fourth agent (a hostile auditor) spawned in a separate session with only the context brief and the final report, tasked with finding what all three agents missed.

**Surface-level findings.** The Finder reports symptoms instead of root causes — "this variable could be null" rather than "the data validation layer is missing, which manifests as null propagation in 5 locations." *Fix:* the enhanced Finder prompt already addresses this ("if multiple findings share a root cause, report the root cause"). If the Finder still produces symptoms, the Referee's pattern synthesis step should catch and consolidate them.

**Degenerate scoping.** The target is so broad that the Finder produces a mix of high-level architectural concerns and low-level style nits with no coherent thread. The Challenger can't meaningfully engage because the findings span too many domains. *Fix:* split into multiple focused tribunals. A tribunal on "the authentication flow" and a tribunal on "the data pipeline" beats one tribunal on "the whole backend."

## Theoretical Foundations

### Ensemble Diversity (Wood et al., JMLR 2023)

The bias-variance-diversity decomposition formalizes why agent independence is load-bearing: `E[loss] = noise + avg_bias + avg_variance − diversity`. Diversity is *subtracted* from error. The tribunal maximizes diversity not through different training data (as the dialectic does with heterogeneous models) but through *opposing incentive structures.* Three agents with the same model but different scoring functions produce structurally decorrelated outputs — they literally look for different things. This is cheaper than heterogeneous models and sufficient for verification tasks where the target is bounded.

### Klein: Prospective Hindsight (Premortem)

Gary Klein's research demonstrates that temporal reframing — "it has already failed, why?" — increases identification of failure causes by ~30% compared to "what could go wrong?" The mechanism is breaking **selective accessibility**: asking "what could go wrong?" triggers a search for the most available concern, then stops. Asking "what caused the failure?" triggers a search for *all* contributing factors, because the failure is established and must be fully explained. The Finder uses premortem framing to access this deeper search mode. Scoring incentives and premortem framing are complementary: scoring motivates quantity, premortem reframes the search strategy.

### Pollock: Defeasible Reasoning

John Pollock's distinction between undercutting and rebutting defeaters gives the Challenger structural vocabulary for its disproofs. An undercutting defeater ("the evidence doesn't support this conclusion") is more structurally revealing than a rebutting defeater ("counter-evidence contradicts this") because it exposes *how reasoning fails,* not just *that it fails.* This is parallel to **determinate negation** in the Hegelian tradition — the specific way something fails is a signpost toward what's missing. Classifying disproofs costs nothing and gives the Referee richer input for judgment: undercut findings might be real but poorly argued, rebutted findings are likely genuinely false.

### Kahneman: Adversarial Collaboration

Daniel Kahneman advocated for **adversarial collaboration** — instead of academics publishing rebuttals past each other, have the disagreeing parties jointly design an evaluation that would settle the dispute. The tribunal is mechanized adversarial collaboration: the Finder and Challenger don't argue past each other — the Referee forces them into the same evaluation frame where each finding gets a binary verdict. The sequential pipeline (Finder → Challenger → Referee) ensures each agent engages with the previous agent's *actual output,* not a strawman.

## Notes

- The Finder, Challenger, and Referee MUST run sequentially — each depends on the previous agent's output. Context gathering and brief writing happen before any agent runs.
- The Referee's pattern synthesis (analyzing confirmed findings as a set) is the tribunal's highest-value output per token. It transforms the output from a flat list to structural insight. This is the tribunal's equivalent of the dialectic's structural analysis — not a full Aufhebung, but a step toward *understanding* rather than just *findings.*
- The ground truth lie is the critical design choice. Without it, the Referee treats judgment as subjective — which produces hedged probabilities rather than committed verdicts.
- For high-stakes targets, consider running two tribunal rounds: the first on the target itself, the second on the first tribunal's dismissed findings (a meta-tribunal that catches false dismissals).
- If the user needs not just "what's wrong" but "why these things are wrong and what deeper issue they reveal," the tribunal's pattern synthesis points in that direction — but for full structural understanding, compose with the dialectic: run the tribunal first to surface findings, then feed the systemic pattern into a dialectic round to understand the deeper tension.
