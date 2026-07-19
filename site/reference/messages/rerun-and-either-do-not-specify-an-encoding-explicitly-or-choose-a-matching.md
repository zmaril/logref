---
message: "Rerun %s and either do not specify an encoding explicitly, or choose a matching combination."
slug: rerun-and-either-do-not-specify-an-encoding-explicitly-or-choose-a-matching
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2315"
  - "postgres/src/bin/initdb/initdb.c:2336"
reproduced: false
---

# `Rerun %s and either do not specify an encoding explicitly, or choose a matching combination.`

## What it means

A hint from a tool such as `initdb` or `createdb`. The explicitly requested encoding conflicts with the encoding implied by the chosen locale, and the hint advises either dropping the explicit encoding or picking one that matches the locale. The placeholder is the program name.

## When it happens

It appears when initializing a cluster or creating a database where `--encoding` and the `LC_CTYPE`/locale disagree in a way Postgres will not silently reconcile.

## How to fix

Rerun without `--encoding` (letting the locale determine it), or specify an encoding that is compatible with the locale (for example UTF-8 with a UTF-8 locale). Choose a locale/encoding pair that agrees.

## Example

*Illustrative* — a hint on an encoding/locale mismatch.

```text
HINT:  Rerun initdb and either do not specify an encoding explicitly, or choose a matching combination.
```

## Related

- [unexpected encoding ID %d for WIN character sets](./unexpected-encoding-id-for-win-character-sets.md)
- [requested character too large for encoding: %u](./requested-character-too-large-for-encoding.md)
