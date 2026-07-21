---
message: "cannot execute %s during recovery"
slug: cannot-execute-during-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_READ_ONLY_SQL_TRANSACTION
    code: "25006"
call_sites:
  - "postgres/src/backend/tcop/utility.c:449"
reproduced: false
---

# `cannot execute %s during recovery`

## What it means

A command that changes data or cluster state was issued on a standby server or during crash recovery. A server in recovery replays WAL and stays read-only, so the named command is rejected. The placeholder is the command name.

## When it happens

It occurs when you run a write or state-changing command against a hot standby, or against a server that is still finishing recovery after a crash or a base-backup restore.

## How to fix

Run the command on the primary, or wait until recovery finishes and the server is promoted to read-write. Point write traffic at the primary and reserve the standby for read-only queries.

## Example

*Illustrative* — a command run on a standby.

```text
ERROR:  cannot execute VACUUM during recovery
```

## Related

- [cannot execute in a read-only transaction](./cannot-execute-in-a-read-only-transaction.md)
- [cannot manipulate replication origins during recovery](./cannot-manipulate-replication-origins-during-recovery.md)
