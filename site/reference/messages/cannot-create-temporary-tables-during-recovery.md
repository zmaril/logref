---
message: "cannot create temporary tables during recovery"
slug: cannot-create-temporary-tables-during-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_READ_ONLY_SQL_TRANSACTION
    code: "25006"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:4498"
reproduced: false
---

# `cannot create temporary tables during recovery`

## What it means

A `CREATE TEMP TABLE` was attempted while the server was in recovery. Creating a temporary table requires catalog writes, which a read-only standby or a server still replaying WAL cannot perform.

## When it happens

It occurs when a session on a hot standby, or during crash recovery, tries to create a temporary table.

## How to fix

Do not create temporary tables on a standby or before recovery completes. Run such work on the primary, or wait until the server has finished recovery and accepts writes.

## Example

*Illustrative* — a temp table during recovery.

```text
ERROR:  cannot create temporary tables during recovery
```

## Related

- [cannot create temporary tables during a parallel operation](./cannot-create-temporary-tables-during-a-parallel-operation.md)
- [cannot continue wal streaming recovery has already ended](./cannot-continue-wal-streaming-recovery-has-already-ended.md)
