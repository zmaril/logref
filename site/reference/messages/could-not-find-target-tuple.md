---
message: "could not find target tuple"
slug: could-not-find-target-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:2613"
  - "postgres/src/backend/commands/repack.c:2629"
reproduced: false
---

# `could not find target tuple`

## What it means

Internal error. During a `REPACK` (or similar rebuild), the code could not locate a tuple it expected to find while remapping rows. It is a consistency check within the rebuild's tuple-tracking, not a condition ordinary data produces.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency during the rebuild — possibly alongside concurrent modification anomalies or corruption — rather than to your data directly.

## How to fix

Treat it as an internal error. Preserve the server log, note the table and the concurrent workload, and report it. If it recurs on a specific table, check that table for corruption (for example with `amcheck` on its indexes) and consider whether concurrent activity is triggering it.

## Example

*Illustrative* — emitted internally during a repack.

```text
ERROR:  could not find target tuple
```

## Related

- [could not apply concurrent on relation](./could-not-apply-concurrent-on-relation.md)
- [could not find tuple for](./could-not-find-tuple-for.md)
