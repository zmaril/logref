---
message: "cannot make new WAL entries during recovery"
slug: cannot-make-new-wal-entries-during-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:816"
  - "postgres/src/backend/access/transam/xloginsert.c:161"
reproduced: false
---

# `cannot make new WAL entries during recovery`

## What it means

Code tried to write a new WAL record while the server is in recovery (a standby, or a primary still replaying at startup). During recovery the server is replaying existing WAL, not generating new WAL, so any operation that would emit a WAL record is rejected.

## When it happens

Attempting a data-modifying operation on a hot-standby that only permits read-only queries, or an internal action that would write WAL before recovery has finished.

## How to fix

Run write operations against the primary, not a standby. On a standby, only read-only queries are allowed until it is promoted. If this is a primary still in startup recovery, wait for recovery to complete before issuing writes.

## Example

*Illustrative* — a write attempted on a standby.

```text
ERROR:  cannot make new WAL entries during recovery
```

## Related

- [canceling statement due to conflict with recovery](./canceling-statement-due-to-conflict-with-recovery.md)
- [cannot execute on temporary tables of other sessions](./cannot-execute-on-temporary-tables-of-other-sessions.md)
