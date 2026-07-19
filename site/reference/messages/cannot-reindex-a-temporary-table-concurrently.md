---
message: "cannot reindex a temporary table concurrently"
slug: cannot-reindex-a-temporary-table-concurrently
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:4092"
reproduced: false
---

# `cannot reindex a temporary table concurrently`

## What it means

A `REINDEX ... CONCURRENTLY` targeted a temporary table. Temporary tables are private to one session and never seen by concurrent transactions, so a concurrent reindex is neither needed nor supported for them.

## When it happens

It occurs when you run `REINDEX (CONCURRENTLY)` on a temporary table or its indexes.

## How to fix

Reindex temporary tables with a plain `REINDEX` (no `CONCURRENTLY`). Since no other session can access them, the ordinary reindex is safe and immediate.

## Example

*Illustrative* — concurrent reindex of a temp table.

```text
ERROR:  cannot reindex a temporary table concurrently
```

## Related

- [cannot reindex temporary tables of other sessions](./cannot-reindex-temporary-tables-of-other-sessions.md)
- [cannot reindex this type of relation concurrently](./cannot-reindex-this-type-of-relation-concurrently.md)
