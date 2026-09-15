<!-- Applies to all code files. Language-specific syntax rules live in `.agents/rules/lang/<lang>.md`. -->

# Comments & documentation placement

Code carries *short* comments; long-form explanation lives in docs. The goal:
skim a file and see what it does, without a wall of prose — and find the *why*
in a predictable place.

## Comment constraints (in code)

- **Explain *why*, not *what*.** The code says what; comments justify a choice,
  flag a gotcha, or link a source. If a comment restates the code, delete it.
- **1–2 lines each.** A single comment must not exceed 2 lines. Need more? It's
  documentation — move it (see below) and leave a one-line pointer.
- **File header ≤ 2 lines.** One line naming the file's concern, optionally one
  more pointing at fuller docs (e.g. `details in README.md § <section>`).
- **No commented-out code.** Delete it (git remembers). The only exception is
  the project's opt-in-by-uncommenting convention for secret-gated host
  features — and that stays a single line with a pointer, not a prose block.
- **No decorative separators / ASCII-art banners** to structure a file. If a
  file needs sections to stay readable, it's probably doing too much — split it
  (see the 300-LOC modularity rule in `AGENTS.md`).
- **No TODO without an owner + intent.** Write `# TODO(user): <what/why>`, not a
  bare `# TODO`. Prefer a `[PROGRESS]`/`[OUTCOMES]` entry in
  `.agents/CONTINUITY.md` for anything that outlives the current edit.
- **No dead/temporary comments.** Remove `builtins.trace`, debug notes, and
  "changed X" history before finishing (git is the history).

## When to move it out of code

Move an explanation into documentation when **any** of these is true:

- it would take **more than 2 lines** to state in a comment,
- it describes **how to use** a feature (setup, flags, secrets, invocation),
- it explains a **cross-cutting design decision** (spans >1 file), or
- it's **reference material** (option tables, upstream API notes, links).

## Where it goes (pick the smallest home that fits)

1. **Inline comment (≤ 2 lines)** — a local *why* or gotcha for one spot.
2. **`README.md`** — how to use / build the repo and per-feature usage notes.
   Default home for feature documentation. Add a `§ <section>` and point the
   code header at it.
3. **A dedicated `docs/<topic>.md`** — only when the README section grows large
   or a topic has real demand (deep dive, many options, diagrams). Create it,
   then link it from the README rather than bloating the README.
4. **`.agents/rules/…` or `.agents/CONTINUITY.md`** — agent-facing conventions
   and living project state (decisions, progress), not end-user docs.

Rule of thumb: **code → why; README → how; `docs/<topic>.md` → deep dive.**
Keep exactly one source of truth — link to it, don't duplicate it.

## Definition of done (this rule)

Before finishing an edit: no comment exceeds 2 lines, no commented-out code or
stray TODOs remain, and any explanation that outgrew a comment has a home in
README/`docs` with a one-line pointer from the code.
