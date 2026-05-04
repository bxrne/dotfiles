# AGENTS.md — Global Coding Standards

> "The design is not just what it looks like and feels like. The design is how it works."
> — Steve Jobs, cited in TigerStyle

---

## Design Goals (in order)

1. **Safety** — correct or crashed. Never silently wrong.
2. **Performance** — mechanical sympathy from the design phase, not the profiler.
3. **Developer Experience** — a small, clean codebase is a gift to your future self.

Readability is table stakes — a means to these ends, not an end in itself.

---

## Before You Touch the Keyboard

> "The lack of back-of-the-envelope sketches is the root of all evil." — TigerStyle

- Understand the requirement fully. If it is ambiguous, ask. Do not infer your way into the wrong solution.
- Sketch the design. Identify the four dimensions: **network, storage, memory, compute** — and their two textures: **bandwidth and latency**. Be roughly right before writing a line.
- Write a short design note for any non-trivial change. One paragraph of clear prose beats a week of refactoring. (ref: *How to Write a Good Design Document* — Slatton)
- Ask: **what could go wrong?** Not: what should happen? The former question is cheaper to answer now than in production.
- Identify which files will change. Check for existing patterns you should follow or reuse.

---

## Zero Technical Debt Policy

> "Code, like steel, is easier to change while it's hot. Do it right the first time."
> — TigerStyle

- Solve problems when you find them. Do not defer to a TODO.
- A feature that does not meet all design goals is not done.
- Momentum comes from knowing that what you have shipped is solid — not from shipping fast and fixing later.
- No commented-out code. No stale TODOs. No known-bad paths left alive.

---

## Safety

### Assert Liberally
- Assertions document invariants better than comments and enforce them at runtime.
- A failing assertion is a liveness bug. Corrupt silent state is a safety bug. Prefer the former.
- Assert the same invariant at **two** different code paths (e.g. before write AND after read).
- Split compound assertions: `assert(a); assert(b);` over `assert(a && b)` — know which one failed.
- Assert both positive space (what must be true) and negative space (what must never be true).
- There are three bugs in every silent failure: the missing assertion, the missing test coverage, and the wrong behaviour. Fix all three.

### Crash, Don't Corrupt
- The only correct response to violated expectations is to crash.
- Never swallow errors. Never ignore return values. Wrap with context.
- Distinguish: **operating errors** (expected, return them) vs **programmer errors** (unexpected, assert/panic).

### Explicit Control Flow
- No hidden control flow. No magic. No implicit fallthrough.
- No recursion unless the problem is provably bounded.
- All loops must have a fixed upper bound. Unbounded loops must be explicitly justified.
- Simple, boring control flow is safer than clever, compact control flow.

### Put a Limit on Everything
- Everything has a limit. Model it explicitly.
- No unbounded queues, buffers, or retries without a ceiling.
- Use explicitly-sized integer types. Avoid architecture-dependent sizes where precision matters.

---

## Performance

- Think about performance **in the design phase**, not after the fact. The 1000x wins live there.
- Have mechanical sympathy: know your allocator, your scheduler, your syscall costs. (ref: *Go Memory Allocator*, *Go Runtime Scheduler* — internals-for-interns)
- Back-of-envelope first: is this algorithm O(n log n) or O(n²)? Does it matter at your scale?
- Do not introduce a performance problem knowingly. Zero tolerance for known algorithmic landmines.
- Avoid dynamic allocation in hot paths. Prefer static or pool allocation where possible.
- Measure before optimising micro-details. Don't guess.

---

## Dependencies

- Every dependency is a liability: supply chain risk, maintenance burden, unexpected behaviour.
- Ask: can this be done in 20 lines instead of adding a library? Often the answer is yes.
- Check the dependency manifest before assuming a library is available. Never introduce a new dep without explicit intent.
- Prefer the platform. (ref: *YOU JUST NEED POSTGRES* — Andrade; *Linux man pages* — Kerrisk)

---

## Naming

> "Great names are the essence of great code, capturing what a thing is or does,
> for a crisp mental model." — TigerStyle

- A good name means you understand the concept. A bad name means you do not yet.
- Include units and qualifiers: `timeout_ms`, `buffer_size_bytes`, `offset_index`.
- Use the same character width for related parallel names so they align visually.
- Do not overload one name with multiple context-dependent meanings.
- Prefix helper/callback names with the calling function: `read_sector`, `read_sector_callback`.
- Main functions go first. Important things go near the top. Files are read top-down.

---

## Abstraction

> "Use only a minimum of excellent abstractions, but only if they make the best sense of the domain.
> Abstractions are never zero cost." — TigerStyle
> (ref: *Abstraction and Design in Computation* — CS51)

- Every abstraction introduces the risk of a leaky abstraction.
- Do not add a layer until two concrete things are clearly the same shape.
- The best abstraction is the one that does not exist yet.
- Simple, explicit code that you can reason about in your head beats clever, compressed code.

---

## Code Shape

- Functions do one thing. If you need "and" to describe it, split it.
- Max ~40 lines of logic per function — not dogma, but a signal worth heeding.
- No boolean parameters. They silently carry meaning callers can't read at the call site.
- No magic numbers. Every constant deserves a name and a reason.
- Comments explain **why**, never **what**. The code explains what.
- Keep diffs small and reviewable. One logical change, one response or commit.

---

## Configuration & Process
> (ref: *The 12 Factor App* — Wiggins)

- Config lives in environment variables, never in code.
- All dependencies are explicit and isolated — no ambient globals.
- Processes are stateless; state lives in the backing store.
- Treat logs as event streams, not files. Write to stdout.
- Build, release, run are strictly separated.

---

## Databases & Migrations
> (ref: *Zero Downtime Migrations at Petabyte Scale* — PlanetScale;
> *Unlocking High-Performance PostgreSQL* — Stormatics)

- Migrations are additive first. Remove old columns only after the code no longer reads them.
- Never rename a column directly — add new, backfill, cut over, drop old.
- Every schema change must be reversible or explicitly documented as irreversible.
- Understand your query planner. Index thoughtfully, not reflexively.
- When in doubt, Postgres can do it. Reach for the database before the service. (ref: *YOU JUST NEED POSTGRES*)

---

## Writing & Communication
> (ref: *Economical Writing* — McCloskey; *How to Write a Good Design Document* — Slatton)

- Write economically. Every word you cut makes the remaining words stronger.
- One idea per sentence. One topic per paragraph. Cut the throat-clearing.
- State your conclusion first, then justify it. Readers should not have to infer your point.
- A design doc is not a journal of your thought process — it is a pitch for a decision.
- When you present options, give the trade-offs. Do not make the reader guess.

---

## Security Baseline

- Never trust input — validate and sanitise at every boundary.
- No hardcoded secrets. Use environment variables or a secrets manager.
- Principle of least privilege on all credentials and permissions.
- Any change touching auth, crypto, secrets, or persistent state warrants explicit human review.
- Flag it. Do not quietly ship it.

---

## Communication With Humans

- No filler. No "Great question!" No "Certainly!".
- If uncertain, say so explicitly with a confidence level.
- Raise risks, debt, and follow-up concerns at the end — not buried in the middle.
- Ask one clarifying question at a time. Not five.
