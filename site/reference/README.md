# Message reference pages

One canonical markdown page per **distinct Postgres log/error message text** —
"StackOverflow for log lines." This is the content layer of the design doc's
[Enrich & serve stage](../../notes/design.md) (§4, stage 3): each page explains
what a message means, when it fires, and — for errors — how to fix it, anchored
to the exact source call sites that emit it.

Pages live in [`messages/`](./messages/). This directory is the **pilot**: ~30
hand-reviewed pages that lock the template and slug scheme before the full run.

## Scope of the catalog

The extracted catalog holds **14,806 call sites** across the Postgres tree. Those
collapse to **8,988 distinct message texts** — many call sites share one text
(for example `smallint out of range` is emitted from 7 places), and pages are
**per distinct text**, grouping every call site that shares it onto one page.

A further **159 call sites carry no literal text** at all: their message
argument is computed at runtime (a variable, a `?:` expression, a helper call),
so nothing can be statically extracted. See *Passthrough & computed messages*
below for how those are handled.

## Slug rule

The filename is a stable slug derived deterministically from the message text:

1. Remove every `printf` placeholder (`%s`, `%d`, `%u`, `%m`, `%02d`, `%X`,
   `%.1f%%`, and the length/flag variants).
2. Lowercase; replace every run of non-`[a-z0-9]` with a single `-`; trim
   leading/trailing `-`.
3. Truncate to 80 characters at a `-` boundary.
4. **Empty result** (the text was only placeholders/punctuation, like `%s`):
   fall back to `msg-<sha1(text)[:8]>`.
5. **Collision** (two distinct texts reduce to the same base slug): append
   `-<sha1(text)[:6]>` to disambiguate.

Across all 8,988 texts this yields 8,988 unique slugs: **13** texts fall back to
a `msg-<hash>` slug, and **390** texts (across 183 colliding bases) take a
`-<hash6>` suffix. The rest map to a clean, readable slug.

## Page template

Every page is frontmatter + a fixed set of body sections:

```markdown
---
message: "<exact catalog text, placeholders preserved>"
slug: <slug>
passthrough: <true|false>       # whole text is placeholders (see below)
api: [<one or more logging APIs, e.g. ereport, elog>]
level: [<one or more severity levels> | varies]
level_runtime_chosen: true      # present only if some sites pick severity at runtime
sqlstate:                       # omitted when there is no concrete SQLSTATE
  - symbol: ERRCODE_<NAME>
    code: "<5-char code>"
call_sites:
  - "<path>:<line>"             # every call site that shares this text
reproduced: <true|false>        # in the reproducer coverage set (real example)
---

# `<message text>`

**Severity:** <levels> · SQLSTATE `<code>` (<symbol>)

## What it means      — plain-language explanation of the condition
## When it happens     — what triggers it
## How to fix          — ERROR/FATAL/PANIC only; concrete, actionable steps
   (or)
## Is this a problem?   — LOG/INFO/DEBUG/NOTICE/WARNING; "usually not, but watch…"
## Example             — real trigger if reproduced, else marked illustrative
## Source              — GitHub links to each call site
## SQLSTATE            — code, symbolic name, and error-class meaning
## Related             — sibling messages (same file or SQLSTATE class)
```

The `How to fix` vs `Is this a problem?` heading is chosen by severity: hard
failures (`ERROR`/`FATAL`/`PANIC`) get a fix; informational levels get
problem-triage guidance instead.

## Which fields come from where

| Field | Source |
|---|---|
| `message`, `api`, `level`, `sqlstate` symbol, `call_sites` | **Catalog** (extracted, verbatim) |
| `sqlstate` code + class name | **Catalog symbol → `errcodes.txt` lookup** (deterministic) |
| `reproduced` flag + real `Example` | **Reproducer coverage set** (`reproducers/`) |
| GitHub `Source` links | **Computed** from `path:line` (drop the checkout-root `postgres/` prefix) |
| `What it means`, `When it happens`, `How to fix`, illustrative `Example`, `Related` | **LLM-authored**, grounded in the catalog facts + real Postgres knowledge — never invents SQLSTATEs, locations, or fixes |

The rule for the prose: the structured facts are ground truth and are never
restated inaccurately; where a fix is uncertain, the page says what to
investigate rather than fabricating a remedy.

## Passthrough & computed messages

- **Passthrough texts** — the whole text is a placeholder (`%s` alone is emitted
  from 93 sites at every severity). The real content is assembled at the call
  site, so severity and SQLSTATE are call-site-specific. These pages set
  `passthrough: true`, render `Severity: varies by call site`, and **omit the
  SQLSTATE section** rather than list codes that do not belong to the text. See
  [`messages/msg-347cd9c5.md`](./messages/msg-347cd9c5.md) (the `%s` page).
- **Computed severity/SQLSTATE** — some sites choose the level at runtime
  (`elevel`, `verbose ? INFO : LOG`) or the error code via an expression. The
  generator keeps only the concrete `ERRCODE_*` macros and real severity levels
  for the structured fields, and flags the rest with `level_runtime_chosen`.
- **The 159 no-text call sites** — because they contribute no distinct text,
  they produce **no page of their own**. They surface only on the passthrough
  pages (as extra call sites) and, in the served product, are resolved by
  `path:line` from `jsonlog` rather than by text.

## The pilot set (~30 pages)

Chosen to stress every branch of the template: numeric/data errors with
SQLSTATEs, heavy-placeholder texts, a `FATAL` auth/connection case, a `PANIC`-
class recovery failure with no SQLSTATE, lifecycle `LOG`/`INFO`/`DEBUG` lines, a
`WARNING`, a `NOTICE`, and the `%s` passthrough edge case. **12** are drawn from
the reproducer coverage set and carry a real triggering example; the rest use an
illustrative example clearly marked as such.

## Scaling to all 8,988 messages

The pilot's generator is mechanical: join catalog facts by distinct text →
apply the slug rule → render the template. To go from 30 to 8,988:

1. Load the full `errcodes.txt` symbol→code→class table (the pilot ships a
   subset in the generator).
2. Prioritize by the coverage set and call-site frequency so the most-hit
   messages get authored first; the long tail can start from a
   catalog-only stub (facts + `Source`, no prose) and be enriched over time.
3. Author the four prose sections per message (the only non-mechanical step),
   batching by subsystem/SQLSTATE class so sibling messages share context.
4. Layer in the external references from the design doc (StackOverflow, git
   commits, blogs, bug tracker, mailing list) once the enrichment ranking is
   settled.
5. Regenerate and lint (vale/proselint, codespell) in CI so pages cannot drift
   from the catalog.
