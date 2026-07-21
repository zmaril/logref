---
message: "UPDATE target count mismatch --- internal error"
slug: update-target-count-mismatch-internal-error
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/analyze.c:2973"
  - "postgres/src/backend/parser/analyze.c:3015"
reproduced: false
---

# `UPDATE target count mismatch --- internal error`

## What it means

Internal error. The executor found the number of rows it planned to update did not match the number the update machinery accounted for.

## When it happens

It fires as a consistency check in `UPDATE` execution when the target bookkeeping disagrees. Ordinary updates do not produce it.

## How to fix

This is an internal consistency guard. If a real `UPDATE` triggers it, capture the statement and the table involved and report it as a reproducible bug.

## Example

*Illustrative* — an update target-count mismatch.

```text
ERROR:  UPDATE target count mismatch --- internal error
```

## Related

- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
- [unexpected param multiexpr id](./unexpected-param-multiexpr-id.md)
