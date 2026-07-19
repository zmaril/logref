---
message: "wrong number of tlist entries"
slug: wrong-number-of-tlist-entries
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:4386"
  - "postgres/src/backend/optimizer/path/allpaths.c:4392"
reproduced: false
---

# `wrong number of tlist entries`

## What it means

Internal error. The planner found a target list whose entry count does not match the number of columns expected at that stage.

## When it happens

It fires as a consistency check while assembling a plan when a target list and its expected shape disagree. Ordinary queries do not produce it.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the query and report it as a reproducible planner bug.

## Example

*Illustrative* — a target-list count mismatch.

```text
ERROR:  wrong number of tlist entries
```

## Related

- [wrong number of output columns in WITH](./wrong-number-of-output-columns-in-with.md)
- [UPDATE target count mismatch --- internal error](./update-target-count-mismatch-internal-error.md)
