---
message: "wrong tuple length"
slug: wrong-tuple-length
passthrough: false
api: [elog]
level: [ERROR, PANIC]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6487"
  - "postgres/src/backend/access/heap/heapam_xlog.c:1181"
reproduced: false
---

# `wrong tuple length`

## What it means

Internal error, or on-disk corruption. Code reading a tuple found its stored length inconsistent with what the row header or catalog shape implies.

## When it happens

It fires as a low-level consistency check when a tuple's length does not match its descriptor. At the PANIC call site it guards a critical update. It usually indicates corruption rather than ordinary use.

## How to fix

This is a corruption/consistency guard. Investigate storage health, restore the affected relation from a backup if the data is damaged, and capture the relation and surrounding log to report it.

## Example

*Illustrative* — a tuple of unexpected length.

```text
ERROR:  wrong tuple length
```

## Related

- [wrong pg_constraint entry for trigger "%s" on table "%s"](./wrong-pg-constraint-entry-for-trigger-on-table.md)
- [no pg_subtrans entry for subcommitted XID %u](./no-pg-subtrans-entry-for-subcommitted-xid.md)
