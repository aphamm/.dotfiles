---
name: slack-recap
description: Turn the current Claude Code session into a tight, team-level Slack update — ≤12 lines, 1-2 short declarative bullets per section, up to four sections (What I Did, Issues Ran Into, Next Steps, What I Learned) with emoji trailing each header. Sections with no real team-level content are OMITTED entirely — no "none" placeholders, no empty headers. Use whenever the user asks for a "recap", "summary", "standup update", "slack message", "wrap up", "write this up", "what did we do today", or mentions posting work to a channel or sharing with teammates — even if they don't explicitly say "Slack". Outputs standard Slack mrkdwn (single-asterisk bold, inline backtick code, bare URLs).
---

# Slack Recap

A ≤12-line Slack update written for the whole team, not the person who did the work.

## The rubric

Before every bullet, ask: *"If a teammate who wasn't in this session reads this, does it tell them something they'd want to know?"* If no, cut it.

**In**: things that shipped, launch status, cost and performance numbers, real blockers, decisions that affect others, high-level learnings, pointers to fuller docs.

**Out**: file paths from refactors, function renames, bug-fix details, individual commits, which directory was reorganized, personal tooling, dev-log entries. *Nobody but you cares that you renamed a variable.*

## Format

Slack's rich-text composer parses standard mrkdwn when the user has *"Format messages with markup"* enabled in Preferences → Advanced → Input options. Assume that's on.

- `*text*` for bold (single asterisks — double asterisks render as literal stars)
- `` `text` `` for inline code — use this for file paths, function names, flags
- Bare URLs auto-link. Never use `<url|label>` — the pipe renders literally.
- `•` for bullets
- Emoji as Unicode directly (not `:shortcode:`), trailing each header line

## Template

```
*{topic, 3-6 words}* {emoji}

*What I Did* {emoji}
• statement
• statement

*Issues Ran Into* {emoji}
• statement

*Next Steps* {emoji}
• statement

*What I Learned* {emoji}
• statement
• statement
```

**Omit any section with no team-level content.** If there were no blockers, delete the entire "Issues Ran Into" block — header, bullets, and the blank line around it. Don't write `• none`. A 3-section recap is common; 4-section only when all four have real content.

## Hard rules

- **≤12 lines total.** Count them.
- **1-2 bullets per section.**
- **Short declarative statements, not sentences.** "Modal server up and running", not "I shipped the Modal inference server this afternoon". Drop the "I", drop obvious subjects.
- **Mix tense naturally.** "Cost is ~$0.60/chunk" (present), "Biggest issue was VFR" (past) — whatever fits.
- **Inline backtick code for technical references.** `src/foo.py`, `--flag`, `docs/ARCHITECTURE.md`. Visually distinct, renders nicely.
- **Bare URLs, not wrapped links.** Slack auto-links.
- **Label-colon patterns are welcome.** "Code: https://..." reads tighter than "Shipped the code to https://...".
- **No "Session recap —" prefix.** Just the topic.
- **No preamble.** No "Today I started…".

## Emoji

Pick one Unicode emoji from each needed section's pool, fresh every invocation. Variety matters — same four every time creates channel fatigue.

- **Topic header**: 📋 📝 📜 🗞️ ✍️ 🗂️ 📇 ✨
- **What I Did**: 🛠️ 📦 🚢 ✅ 🎯 💪 💎 🔨
- **Issues Ran Into**: 🐞 🔥 💥 ⚠️ 🚨 🌩️ 😵‍💫
- **Next Steps**: 🚀 ➡️ 🧭 ⏳ 🌱 🗓️ 🔮 👣
- **What I Learned**: 🧠 💡 🔭 🔬 📚 🎓 🧐

## Example (target shape)

Session: stood up a Modal inference server, pushed the repo, wrote the architecture docs, measured pipeline cost, figured out where the bottleneck actually lives.

```
*only-hands wrap-up* 📋

*What I Did* 📦
• Modal inference server up and running
• Code: https://github.com/your-org/your-repo

*Issues Ran Into* 💥
• Documented in `docs/ARCHITECTURE.md` and `docs/ISSUES.md`
• Biggest issue was variable frame rate

*What I Learned* 🔭
• HaWoR pipeline cost is ~75% masked DROID-SLAM, not the WiLoR hand ViT
• One 2 min chunk takes ~33 min on L4 GPU, ~$0.60/chunk, which means ~$18/hr to run SLAM + tracking on video
```

11 lines. Three sections — "Next Steps" is omitted entirely because nothing team-level was pending. Notice what's absent: no first-person pronouns, no mention of which files were refactored, no commit hashes, no "I shipped" framing.

## Edge cases

- **Sensitive content**: replace secrets and internal URLs with `[redacted]`.
- **Compacted session**: the summary block at the top of your context holds the best team-level highlights — compaction preserves exactly those.
- **mrkdwn not rendering on paste**: one-time user setup — enable *"Format messages with markup"* in Slack Preferences → Advanced. Flag this to the user only if they say the paste looks broken.

## Final check

- ≤12 lines?
- Every bullet team-level, not implementation detail?
- Empty sections dropped entirely (no `• none` placeholders)?
- `*single-asterisk*` bold, not `**double**`?
- Emoji at the end of each header line, not the start?
- Different emoji combo than last time?
- No "Session recap —" prefix, no `[label](url)` links, no outer code fence?
