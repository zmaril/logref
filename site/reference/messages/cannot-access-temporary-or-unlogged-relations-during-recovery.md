---
message: "cannot access temporary or unlogged relations during recovery"
slug: cannot-access-temporary-or-unlogged-relations-during-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/util/plancat.c:156"
reproduced: false
---

# `cannot access temporary or unlogged relations during recovery`

## What it means

A query on a standby, or during recovery, referenced a temporary or unlogged relation. Those relations are not maintained in the WAL a standby replays, so their contents are not available during recovery.

## When it happens

It occurs when a read-only query on a hot standby, or a query while the server is in recovery, touches a temporary table or an unlogged table.

## How to fix

Do not query temporary or unlogged relations on a standby. Move such data into logged tables if it must be visible on standbys, or run the query on the primary. Unlogged tables exist only on the server that wrote them.

## Example

*Illustrative* — an unlogged table on a standby.

```text
ERROR:  cannot access temporary or unlogged relations during recovery
```

## Related

- [cannot acquire lock mode on database objects while recovery is in progress](./cannot-acquire-lock-mode-on-database-objects-while-recovery-is-in-progress.md)
- [cannot access temporary tables during a parallel operation](./cannot-access-temporary-tables-during-a-parallel-operation.md)
