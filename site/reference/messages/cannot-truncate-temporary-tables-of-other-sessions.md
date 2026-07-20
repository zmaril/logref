---
message: "cannot truncate temporary tables of other sessions"
slug: cannot-truncate-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2513"
reproduced: false
---

# `cannot truncate temporary tables of other sessions`

## What it means

A `TRUNCATE` named a temporary table that belongs to a different session. Each session's temporary tables are private to that session, so another session cannot truncate them.

## When it happens

It occurs when a `TRUNCATE` list resolves to a temporary relation created by another backend, often through a shared script or a catalog-driven operation that swept it in.

## How to fix

Truncate only your own temporary tables. Remove the other session's temporary table from the command; its owning session must empty it itself.

## Example

*Illustrative* — truncating another session's temp table.

```sql
TRUNCATE pg_temp_3.scratch;
-- ERROR:  cannot truncate temporary tables of other sessions
```

## Related

- [cannot truncate only a partitioned table](./cannot-truncate-only-a-partitioned-table.md)
- [cannot update foreign table](./cannot-update-foreign-table.md)
