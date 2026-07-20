---
message: "cannot manipulate replication origins during recovery"
slug: cannot-manipulate-replication-origins-during-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_READ_ONLY_SQL_TRANSACTION
    code: "25006"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:215"
reproduced: false
---

# `cannot manipulate replication origins during recovery`

## What it means

A replication-origin management function was called on a server in recovery. Replication origins track apply progress and are read-only on a standby, so creating, dropping, or advancing them is rejected during recovery.

## When it happens

It occurs when functions such as `pg_replication_origin_create()`, `pg_replication_origin_drop()`, or `pg_replication_origin_advance()` are called on a hot standby or during crash recovery.

## How to fix

Manage replication origins on the primary, or wait until the server is promoted to read-write. Standbys inherit origin state through WAL replay and must not be modified directly.

## Example

*Illustrative* — origin management on a standby.

```text
ERROR:  cannot manipulate replication origins during recovery
```

## Related

- [cannot execute during recovery](./cannot-execute-during-recovery.md)
- [cannot get the latest WAL position from the publisher](./cannot-get-the-latest-wal-position-from-the-publisher.md)
