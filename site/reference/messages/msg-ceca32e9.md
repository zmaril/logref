---
message: ": "
slug: msg-ceca32e9
passthrough: true
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:595"
  - "postgres/src/bin/pg_dump/parallel.c:693"
reproduced: false
---

# `: `

## What it means

A passthrough fragment. This text (a colon and a space) is a piece of a larger message that `pg_dump`'s parallel machinery assembles at runtime by concatenation, not a standalone message.

## When it happens

It appears only as part of a composed diagnostic in `pg_dump`'s parallel worker error reporting; the surrounding pieces carry the real content.

## Is this a problem?

There is nothing to act on for this fragment alone. Read the complete assembled message it is part of; that full line carries the actual condition and its guidance.

## Example

*Illustrative* — the fragment within a composed message.

```text
parallel worker: <detail>
```

## Related

- [executing %s](./executing-ddcf88.md)
- [done](./done.md)
